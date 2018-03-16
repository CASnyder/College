--**********************************************************
-- Experiment 5 - 4.2(a)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	counter2.vhd
--
--	Design units:
--		ENTITY counter2
--		ARCHITECTURE counter2_arch
--
--	Purpose: use tick1 pulse and generate a one-clock pulse every 20 ms
--				40 ms, 80 ms, or 160 ms based on the sp input signal 
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
--		Date: 10/13/2015
--		Comments: Original
--**********************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY counter2 IS
	PORT(
		clk_c2: IN std_logic;
		tick1_c2: IN std_logic;
		sp_c2: IN std_logic_vector(1 DOWNTO 0);
		tick2_c2: OUT std_logic
	);
END counter2; 

ARCHITECTURE counter2_arch OF counter2 IS 

	SIGNAL d0_reg, d0_next: std_logic_vector(3 DOWNTO 0);
	SIGNAL d0_enable, tick20, tick40, tick80, tick160: std_logic; 
	
	BEGIN
	
	
	--do port map of the first counter
	--counter1_unit : ENTITY work.counter1(counter1_arch) 
	--	PORT MAP(
	--		clk => clk
	--		, tick1 => tick1); 
	--not necessary for this block of the circuit
	
	--register
	PROCESS(clk_c2)
		BEGIN 
			IF (clk_c2'event and clk_c2='1') THEN
				d0_reg <= d0_next;
			END IF;
	END PROCESS;

	--next state logic
	
	--count the tick1 ticks
	d0_enable <= '1' when tick1_c2 ='1' else '0';
	
	--5 bits needed to count from 0 to 15 then roll back
	--we downscaled the times by a few ms 
	d0_next <= "0000" when d0_enable = '1' and d0_reg = "1111" else
					d0_reg + 1 when d0_enable  = '1' else
					d0_reg;
	
	--simultaneously run all the ticks for all of the times
	tick20  <= '1' when d0_reg = 0 else '0'; -- 20  ms ticks, equal to 2 tick1 ticks
	tick40  <= '1' when d0_reg = 2 else '0'; -- 40  ms ticks, equal to 4 tick1 ticks
	tick80  <= '1' when d0_reg = 4 else '0'; -- 80  ms ticks, equal to 8 tick1 ticks
	tick160 <= '1' when d0_reg = 15 else '0'; -- 160 ms ticks, equal to 16 tick1 ticks  
	
	--use sp to select the appropriate tick 
	WITH sp_c2 SELECT
	tick2_c2 <= tick20  when "00",
					tick40  when "01",
					tick80  when "10",
					tick160 when others;

END counter2_arch;