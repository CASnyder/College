--**********************************************************
-- Experiment 7 - 4.1(d)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	zero_top.vhd
--
--	Design units:
--		ENTITY zero_top
--		ARCHITECTURE zero_top_arch
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
USE ieee.numeric_std.ALL; 

ENTITY zero_top IS 
	PORT(
		clk, start, reset : IN std_logic;
		a :IN std_logic_vector(9 DOWNTO 0);
		ready: OUT std_logic;
		count: OUT std_logic_vector(3 DOWNTO 0)
	);
END zero_top;

ARCHITECTURE zero_top_arch OF zero_top IS 
	BEGIN	
	--fsm block
	fsm_block : entity work.zero_fsm(fsm_arch)
		port map(
			fsm_clk => clk
			, fsm_start => start
			, fsm_reset => reset
			, fsm_a => a
			, fsm_count => count
			, fsm_ready => ready
		);
END zero_top_arch;