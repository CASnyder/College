--**********************************************************
-- Experiment 7 - 4.2d)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	zero_count_counter.vhd
--
--	Design units:
--		ENTITY zero_count_counter
--		ARCHITECTURE counter_arch
--
--	Purpose: generate a one-tick pulse for the zero counting circuit
--					slow down the 50 MHz clock
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
--		Date: 11/01/2015
--		Comments: Original
--**********************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL; 

ENTITY zero_count_counter IS 
	PORT(
		clk_c: IN std_logic;
		tick_c: OUT std_logic
	);
END zero_count_counter;

ARCHITECTURE counter_arch OF zero_count_counter IS
 
	SIGNAL t_reg, t_next: std_logic_vector(24 DOWNTO 0);

	BEGIN
	
	--register
	PROCESS(clk_c)
		BEGIN 
			IF (clk_c'event and clk_c1='1') THEN
				t_reg <= t_next;
			END IF;
	END PROCESS;
	
	--next-state logic	
	t_next <= (others => '0') when t_reg= 5000000 else t_reg + 1;

	--one-tick pulse
	tick_c <= '1' when t_reg = 5000000 else '0';
	
END counter_arch;	