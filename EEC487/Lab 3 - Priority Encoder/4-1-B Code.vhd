--***************************************************************
--
-- Authors: C. A. Snyder
--				B. Rutledge
--				M. Bbela 	
--			
-- File: enhanced_prio.vhd
--
-- Design units:
--
-- ENTITY enhanced_prio
-- ARCHITECTURE prio_arch
-- Purpose:  
-- Inputs: r: 10 bit input request
-- Outputs: fst: 4 bit, binary code of the highest priority request
--				snd: 4 bit, binary code of the second-highest priority request 
-- 
-- Library/Package:
-- ieee.std_logic_1164: to use std_logic
--
-- Software/Version:
-- Simulated by: Altera Quartus v13.0.1
-- Synthesized by: Altera Quartus v13.0.1
--
-- Revision History
-- Version 1.0:
-- Date: 9/15/2015
-- Comments: Original
--
--*************************************************************** 
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;	
ENTITY enhanced_prio IS 
	PORT(
		r: IN std_logic_vector(9 DOWNTO 0);
		fst, snd: OUT std_logic_vector(3 DOWNTO 0)
	);
END enhanced_prio;
ARCHITECTURE prio_arch OF enhanced_prio IS

	SIGNAL tmp: std_logic_vector(3 DOWNTO 0); --temporary variable for holding the value of fst
	
BEGIN
		tmp <= "1001" when r(9) = '1' else 
				 "1000" when r(8) = '1' and r(9) = '0' else 
				 "0111" when r(7) = '1' and r(9 downto 8) = "00" else 
				 "0110" when r(6) = '1' and r(9 downto 7) = "000" else 
				 "0101" when r(5) = '1' and r(9 downto 6) = "0000" else 
				 "0100" when r(4) = '1' and r(9 downto 5) = "00000" else 
				 "0011" when r(3) = '1' and r(9 downto 4) = "000000" else 
				 "0010" when r(2) = '1' and r(9 downto 3) = "0000000" else 
				 "0001" when r(1) = '1' and r(9 downto 2) = "00000000" else 
				 "0000" when r(0) = '1' and r(9 downto 1) = "000000000" else 
				 "1111";

		--set value of fst
		fst <= tmp;
		
		--use tmp / fst to gage where the first 0
		--snd can never be "1001" so starts at "1000" 
		snd <= "1000" when tmp = "1001"  and r(8) = '1' else 
				 "0111" when (tmp = "1001" or tmp = "1000") and r(7) = '1' else
				 "0110" when (tmp = "1001" or tmp = "1000" or tmp = "0111") and r(6) = '1' else 
				 "0101" when (tmp = "1001" or tmp = "1000" or tmp = "0111" or tmp = "0110") and r(5) = '1' else  
				 "0100" when (tmp = "1001" or tmp = "1000" or tmp = "0111" or tmp = "0110" or tmp = "0101") and r(4) = '1' else   
				 "0011" when (tmp = "1001" or tmp = "1000" or tmp = "0111" or tmp = "0110" or tmp = "0101" or tmp = "0100") and r(3) = '1' else
				 "0010" when (tmp = "1001" or tmp = "1000" or tmp = "0111" or tmp = "0101" or tmp = "0100" or tmp = "0100" or tmp = "0011") and r(2) = '1' else  
				 "0001" when (tmp = "1001" or tmp = "1000" or tmp = "0111" or tmp = "0101" or tmp = "0100" or tmp = "0100" or tmp = "0011" or tmp = "0010") and r(1) = '1' else  
				 "0000" when (tmp = "1001" or tmp = "1000" or tmp = "0111" or tmp = "0101" or tmp = "0100" or tmp = "0100" or tmp = "0011" or tmp = "0010" or tmp = "0001") and r(0) = '1' else 
				 "1111"; 
		
END prio_arch;