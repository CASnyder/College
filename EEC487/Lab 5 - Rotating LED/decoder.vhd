--**********************************************************
-- Experiment 5 - 4.4(b)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	decoder.vhd
--
--	Design units:
--		ENTITY decoder
--		ARCHITECTURE decoder_arch
--
--	Purpose: generate the desired LED patterns from counter1, counter2, and counter3 
--
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

ENTITY decoder IS 
	PORT(
		clk: IN std_logic;
		pa, cw: IN std_logic;
		sp: IN std_logic_vector(1 DOWNTO 0);
		hex3, hex2, hex1, hex0: OUT std_logic_vector(6 DOWNTO 0)
	);
END decoder;

ARCHITECTURE decoder_arch OF decoder IS
	
	SIGNAL counterSig: std_logic_vector(2 DOWNTO 0);
	SIGNAL tick1, tick2 : std_logic;
	
	BEGIN
	
	--counter 1 block
	counter1_block : entity work.counter1(counter1_arch)
		port map (
			clk_c1 => clk
			, tick1_c1 => tick1
		);
	
	--counter 2 block
	counter2_block : entity work.counter2(counter2_arch)
		port map (
			clk_c2 => clk
			, tick1_c2 => tick1
			, sp_c2 => sp
			, tick2_c2 => tick2
		);
	
	--counter 3 block
	counter3_block : entity work.counter3(counter3_arch)
		port map(
			clk_c3 => clk
			, tick2_c3 => tick2
			, pa_c3 => pa
			, cw_c3 => cw
			, q => counterSig
		);
	
	--0011100 top segment
	--0100011 bottom segment
	
	WITH counterSig SELECT
	hex3 <= "0011100" when "000", 
			  "0100011" when "111",
			  "1111111" when others;
	
	WITH counterSig SELECT
	hex2 <= "0011100" when "001", 
			  "0100011" when "110",
			  "1111111" when others;
			  
	WITH counterSig SELECT
	hex1 <= "0011100" when "010", 
			  "0100011" when "101",
			  "1111111" when others;
	
	WITH counterSig SELECT
	hex0 <= "0011100" when "011", 
			  "0100011" when "100",
			  "1111111" when others;			  
			  
END decoder_arch;