--**********************************************************
-- Experiment 8 - 4.1(d)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	reaction_decoder.vhd
--
--	Design units:
--		ENTITY reaction_decoder
--		ARCHITECTURE decoder_arch
--
--	Purpose: uses the double-dabble algorithm to convert
--				a 10 bit integer to bcd format  
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
--		Date: 11/16/2015
--		Comments: Original
--**********************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_Std.ALL; 
USE ieee.std_logic_unsigned.ALL;

ENTITY reaction_decoder IS 
	PORT(
		dec_in : IN std_logic_vector(9 DOWNTO 0);
		dec_out: OUT std_logic_vector(20 DOWNTO 0);
	);
END reaction_decoder;

ARCHITECTURE decoder_arch OF reaction_decoder IS
	
	VARIABLE input : integer;
	VARIABLE i : integer :=0; 
	
	BEGIN
		
		input <= to_integer(unsigned(dec_in));
		
		for i in 0 to 9 loop
		
END decoder_arch; 
	