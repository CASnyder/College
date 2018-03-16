--**********************************************************
-- Experiment 6 - 4.1(a)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	tbird_counter.vhd
--
--	Design units:
--		ENTITY tbird_counter
--		ARCHITECTURE counter_arch
--
--	Purpose: generate a one-clock pulse every 300 ms 
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
--**********************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL; 
USE ieee.numeric_std.ALL;

ENTITY tbird_counter IS 
	PORT(
		counter_clk: IN std_logic;
		counter_tick: OUT std_logic
	);
END tbird_counter;

ARCHITECTURE counter_arch OF tbird_counter IS 
	
	SIGNAL t_reg, t_next: std_logic_vector(24 DOWNTO 0);
	
	BEGIN
	
	--register
	PROCESS(counter_clk)
		BEGIN 
			IF (counter_clk'event and counter_clk='1') THEN
				t_reg  <= t_next;
			END IF;
	END PROCESS;
	
	--next-state logic
	--goes up on 300 ms ticks
	t_next <= (others => '0') when t_reg = 600000 else t_reg + 1;
	
	--one-tick pulse
	counter_tick <= '1' when t_reg = 600000  else '0';

END counter_arch;
