--**********************************************************
-- Experiment 8 - 4.1(d)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	reaction_top.vhd
--
--	Design units:
--		ENTITY reaction_top
--		ARCHITECTURE top_level_arch
--
--	Purpose: top level entity of reaction timer circuit
--				record the amount of time it takes a person 
--				to press the stop button
--				
--				also contains a decoder function for 
--				converting 10 bit binary to 12 bit bcd format
--				using the double dabble algorithm 
--				(info on double dabble algorithm found online)
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
--		Date: 11/05/2015
--		Comments: Original
--**********************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY reaction_top IS 
	PORT (
		clk, reset, clear, start, stop: IN std_logic;
		ready, go : OUT std_logic;
		counter1, counter2, counter3 : std_logic_vector(6 DOWNTO 0)	
	);
END reaction_top;

ARCHITECTURE top_level_arch OF reaction_top IS 
	SIGNAL check : std_logic_vector(2 DOWNTO 0); --check time value for cheating user 
	SIGNAL t_out : std_logic_vector(1 DOWNTO 0); --10 bit time value for decoder 
	
	BEGIN
		
	--rng block 
	rng_block : entity work.reaction_rng(rng_arch)
		port map(
			rng_clk => clk
			, rng_start => clear
			, rng_out => check
		);
	
	--fsm block
	fsm_block : entity work.reaction_fsm(fsm_arch)
		port map(
			fsm_clk => clk
			, fsm_clear => clear
			, fsm_start => start
			, fsm_stop => stop
			, fsm_ready => ready
			, fsm_go => go
			, fsm_time => t_out
		);
	
	--decoder block 
	
END top_level_arch;