--**********************************************************
-- Experiment 7 - 4.2(c)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	zero_fsm.vhd
--
--	Design units:
--		ENTITY zero_fsm
--		ARCHITECTURE fsm_arch
--
--	Purpose: hold the states for the zero counting circuit  
--
--	Library/Package:
--		ieee.std_logic_1164
--		ieee.std_logic_unsigned
--
--	Software/Version:
--		Simulated by: Altera Quartus v13.0
--		Synthesized by: Altera Quartus v13.0
--
--	Revisiom History:
--		Version 1.0:
--		Date: 10/26/2015
--		Comments: Original
--		Version 2.0
--		Date: 11/02/2015
--		Comments: Edits to states per discussion with Dr Chu
--**********************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
--USE work.util_pkg.ALL;

ENTITY zero_fsm IS 
	PORT(
		fsm_a : IN std_logic_vector(9 DOWNTO 0);
		fsm_clk, fsm_start, fsm_reset : IN  std_logic;
		fsm_count: OUT std_logic_vector(3 DOWNTO 0);
		fsm_ready: OUT std_logic
	);
END zero_fsm;

ARCHITECTURE fsm_arch OF zero_fsm IS
	
	TYPE zero_state IS (reset, idle, counting);
	SIGNAL state_reg, state_next : zero_state;
	SIGNAL temp_reg, temp_next : std_logic_vector(3 DOWNTO 0);
	
	BEGIN
	
	--register
	PROCESS(fsm_clk, fsm_reset)
	BEGIN
	IF(fsm_reset = '0') THEN 
		state_reg <= reset;
		temp_reg <= "0000";
	ELSIF (fsm_clk'event and fsm_clk = '1') THEN
		state_reg <= state_next;
		temp_reg <= temp_next;
	END IF;
	END PROCESS;
	
	--counting block
	PROCESS(fsm_a, fsm_start, fsm_clk, state_reg)
		VARIABLE sum : unsigned(3 DOWNTO 0);
	BEGIN 						
		sum := (others=>'0'); -- initial value
	
	--only count when in counting state
	IF (fsm_start = '0' and state_reg = counting) THEN 
		FOR i IN 9 DOWNTO 0 LOOP
			IF fsm_a(i) = '0' THEN 
				sum := sum + 1;
			END IF;
		END LOOP; 
		temp_next <= std_logic_vector(sum);
		
	--hold state_reg's value until start is pressed and state changes
	ELSIF (fsm_start = '0' and (state_reg = reset or state_reg = idle)) THEN
		temp_next <= temp_reg;
	END IF;
	END PROCESS;		
	
	--next state logic
	PROCESS(state_reg, state_next, fsm_start, fsm_reset)
	BEGIN		
		CASE state_reg IS 
			when reset =>
				
				--stay in reset if the button is being held down regardless
				--regardless of any other inputs
				--or if fsm start hasn't been pushed 
				if fsm_reset = '0' or (fsm_reset ='1' and fsm_start = '1') then
					state_next <= reset;
				
				--move to the idle state if reset isn't on
				--and start has been pressed
				--and the current state is reset 
				elsif (fsm_reset = '1' and fsm_start = '0') then 
					state_next <= idle; 
				end if; 			
			
			when idle =>
				--if the reset button has been pushed 
				--go back to the reset state 
				if fsm_reset = '0' then
					state_next <= reset; 
				
				--if the reset button hasn't been pressed
				--and the start button hasn't been pressed
				--stay in the idle state 
				elsif (fsm_reset = '1' and fsm_start = '1') then
					state_next <= idle;
				
				--if the reset button hasn't been pressed
				--and the start button has been pressed
				elsif (fsm_reset ='1' and fsm_start ='0') then
					state_next <= counting;
				end if;			

			when counting =>
				--if the reset button has been pushed
				--go back to the reset state
				if fsm_reset = '0' then
					state_next <= reset;
				
				--if the reset button hasn't been pressed
				--and the start button hasn't been pressed
				--go back to the idle state
				elsif (fsm_reset = '1') then
					state_next <= idle;
				
				--for the running state 
				--start does not matter
				end if;			
		END CASE;
	END PROCESS;
	
	--outputs for states
	PROCESS(state_reg)
	BEGIN
		CASE state_reg IS
			
			--everything is 0 and ready is off
			when reset => 			
				fsm_count <= "0000";
				fsm_ready <= '1';
			
			--everything is 0 (because the count hasn't happened)
			--ready is on
			when idle =>
				fsm_count <= temp_reg;
				fsm_ready <= '1'; --active low
			
			--count is displayed
			--ready is off
			when counting =>
				fsm_count <= temp_next;
				fsm_ready <= '0'; --active low 		
		END CASE;
	END PROCESS;
	
END fsm_arch;