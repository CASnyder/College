--**********************************************************
-- Experiment 5 - 4.1(a)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	counter1.vhd
--
--	Design units:
--		ENTITY counter1
--		ARCHITECTURE counter1_arch
--
--	Purpose: generate a one-clock pulse every 10 ms 
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

ENTITY counter1 IS 
	PORT(
		clk_c1: IN std_logic;
		tick1_c1: OUT std_logic
	);
END counter1;

ARCHITECTURE counter1_arch OF counter1 IS
 
	SIGNAL t_reg, t_next: std_logic_vector(24 DOWNTO 0);

	BEGIN
	
	--register
	PROCESS(clk_c1)
		BEGIN 
			IF (clk_c1'event and clk_c1='1') THEN
				t_reg <= t_next;
			END IF;
	END PROCESS;
	
	--next-state logic
	--goes up on 0.01 second ticks; 5000000 would be 1 second ticks	
	t_next <= (others => '0') when t_reg= 500000 else t_reg + 1;

	--one-tick pulse
	tick1_c1 <= '1' when t_reg = 500000 else '0';
	
END counter1_arch;	