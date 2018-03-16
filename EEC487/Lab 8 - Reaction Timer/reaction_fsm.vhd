--**********************************************************
-- Experiment 8 - 4.1(d)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	reaction_fsm.vhd
--
--	Design units:
--		ENTITY reaction_fsm
--		ARCHITECTURE fsm_arch
--
--	Purpose: top level entity of zero counting circuit
--				port maps everything else from the fsm block
--				count the number of 0's in a 10-bit input
--				we originally expected the circuit to require more
--				separate vhdl files
--
--	Library/Package:
--		ieee.std_logic_1164
--		ieee.std_logic_unsigned
--
--
--	Software/Version:
--		Simulated by: Altera Quartus v13.0
--		Synthesized by: Altera Quartus v13.0
--
--	Revisiom History:
--		Version 1.0:
--		Date: 11/09/2015
--		Comments: Original
--**********************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY reaction_fsm IS 
	PORT(
		fsm_clk, fsm_clear, fsm_start, fsm_stop, doneWaiting: IN std_logic;
		fsm_ready, fsm_go : OUT std_logic;
		fsm_time : OUT std_logic_vector(11 DOWNTO 0);
	); 
END reaction_fsm;

ARCHITECTURE fsm_arch OF reaction_fsm IS
	
	TYPE fsm_state IS (reset, initialized, waiting, testing, cheat);
	SIGNAL state_reg, state_next: fsm_start;
	
	BEGIN
	
	--register
	PROCESS(fsm_clk, fsm_reset)
	END PROCESS;
	
	PROCESS(state_reg, state_next, fsm_start, fsm_start, fsm_clear, fsm_reset)
	BEGIN 
		CASE state_reg IS 
			
			WHEN reset => 
				
				--stay in reset state if the switch hasn't been flipped
				--or if the switch has been flipped 
				if fsm_reset = '0' or (fsm_reset '1' and fsm_clear = '1') then
					state_next <= reset;
				
				--move to the initialized state if the user presses clear
				elsif fsm_clear = '0' and fsm_reset = '1' then
					state_next <= initialized
				
				end if;
				
			WHEN initialized =>
				
				--if the user just holds down the clear button forever
				--then stay in the clear state
				if (fsm_clear = '0') then
					state_next <= initialized;
				
				elsif fsm_clear = '1' and )
				
			
			WHEN waiting =>
				
				--
				if(fsm_stop = '0' and doneWaiting = '0') then
					state_next <= cheat;
				
				else
					state_next <= testing; 
			
			WHEN cheat =>
				
				--the circuit can only move out of the cheating state
				--if the user presses clear 
				if(fsm_clear = '0') then
					state_next <= initialized;
				
				--otherwise it just stays there
				else 
					state_next <= cheat; 
				end if; 	
			
			WHEN testing =>
				
				--stay here if nobody hits clear
				if(fsm_clear = '1') then
					state_next <= testing;
				
				--count handles displaying slow
				--so no other signal should control whether or not
				--it moves from testing to another state 
				elsif (fsm_clear = '0') then
					state_next <= initialized; 
				end if; 
		
		END CASE;
	END PROCESS; 

	PROCESS(state_reg)
	BEGIN
		CASE state_reg IS 
			
			--everything is off
			WHEN reset =>
				fsm_ready <= '0';
				fsm_go <= '0';
				fsm_time <= "111111111111111111111"; 
			
			--ready is on
			--go is off
			--hex displays "HI"
			WHEN initialized =>
				fsm_ready <= '1';
				fsm_go <= '0';
				fsm_time <= "111111110010000011111";
			
			--ready is off
			--go is off
			--hex displays 000
			WHEN waiting =>
				fsm_ready <= '0';
				fsm_go <= '0';
				fsm_time <= "000001000000100000010";
			
			--ready is off
			--go is on
			--hex displays the count in BCD
			--until 999, at which point it displays
			--SL for slow 
			WHEN testing =>
				fsm_ready <= '0';
				fsm_go <= '1';
			
			--ready is on
			--go is off
			--hex displays ch
			WHEN cheat => 
				fsm_ready <= '1';
				fsm_go <= '0';
		
		END CASE;
	END PROCESS;
				
END fsm_arch; 


