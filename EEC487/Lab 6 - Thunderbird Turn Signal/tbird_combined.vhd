--**********************************************************
-- Experiment 6 - 4.3(a)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	combined_tbird.vhd
--
--	Design units:
--		ENTITY combined_tbird
--		ARCHITECTURE combined_arch
--
--	Purpose: combine the tbird fsm and tbird counter
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

ENTITY tbird_combined IS
	PORT(
		clk, reset, lft, rt, haz: IN std_logic;
		light: out std_logic_vector(5 downto 0)
	);

END tbird_combined;

ARCHITECTURE combined_arch of tbird_combined is
	
	--SIGNAL light : std_logic_vector(5 DOWNTO 0);
	SIGNAL tick : std_logic; 

	BEGIN
	
	--counter block
	counter_block : entity work.tbird_counter(counter_arch)
		port map(
			counter_clk => clk
			, counter_tick => tick
		);
	
	--fsm block
	fsm_block : entity work.tbird_fsm(tbird_arch)
		port map(
		fsm_clk => clk
		, fsm_reset => reset
		, fsm_haz => haz
		, fsm_tick => tick
		, fsm_light => light
		, fsm_left => lft
		, fsm_right => rt
	);

	
END combined_arch; 