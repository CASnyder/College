--**********************************************************
-- Experiment 4 - 4.1 A 
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	bcd_inc.vhd
--
--	Design units:
--		ENTITY bcd_inc
--		ARCHITECTURE inc_arch
--
--	Purpose: Take 3 4-bit inputs in Binary-coded-decimal
--		format and increment it by 1 and output the
--		incremented number in 3 4-bit outputs
--		
--
--	Library/Package:
--		ieee.std_logic_1164
--
--	Software/Version:
--		Simulated by: Altera Quartus v13.0
--		Synthesized by: Altera Quartus v13.0
--
--	Revisiom History:
--		Version 1.0:
--		Date: 9/27/2015
--		Comments: Original
--**********************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bcd_inc IS
	PORT(
		b2, b1, b0: IN std_logic_vector(3 DOWNTO 0);
		y2, y1, y0: OUT std_logic_vector(3 DOWNTO 0)
	);
END bcd_inc; 

ARCHITECTURE inc_arch OF bcd_inc IS
	
	SIGNAL tmp0, tmp1, tmp2: std_logic_vector(3 DOWNTO 0); --tmp varriables to get around VHDL 'change object to buffer' error
	SIGNAL check1, check2: std_logic_vector(3 DOWNTO 0); --variables for verifying the input is between 0000 and 1001


	BEGIN
		
		--b0 + 1
		WITH b0 SELECT
		tmp0 <=  "0001" when "0000", 
					"0010" when "0001",
					"0011" when "0010", 
					"0100" when "0011",
					"0101" when "0100",
					"0110" when "0101",
					"0111" when "0110",
					"1000" when "0111",
					"1001" when "1000",
					"0000" when others;
		
		y0 <= tmp0;
		
		--verify input for b1 is valid (less than 9) 
		--treat value as "0" if it isn't
		check1 <= "0000" when (b1 = "1010") or (b1 = "1011") or (b1 = "1100") or (b1 = "1101") or (b1 = "1110") or (b1 = "1111") else
					  b1;
		
		--b1 + 1 (only if b0 is 9)
		tmp1 <=  "0001" when check1 = "0000" and b0 = "1001" else 
					"0010" when check1 = "0001" and b0 = "1001" else
					"0011" when check1 = "0010" and b0 = "1001" else
					"0100" when check1 = "0011" and b0 = "1001" else
					"0101" when check1 = "0100" and b0 = "1001" else
					"0110" when check1 = "0101" and b0 = "1001" else
					"0111" when check1 = "0110" and b0 = "1001" else
					"1000" when check1 = "0111" and b0 = "1001" else
					"1001" when check1 = "1000" and b0 = "1001" else
					"0000" when check1 = "1001" and b0 = "1001" else 
					check1; 
		
		y1 <= tmp1;
		
		--verify input for b1 is valid
		--treat value as "0" if it isn't 
		check2 <= "0000" when b2 = "1010" or b2 = "1011" or b2 = "1100" or b2 = "1101" or b2 = "1110" or b2 = "1111" else
					  b2;
		
		--b2 + 1 (only if b0 and b1 are 9)
		tmp2 <=  "0001" when check2 = "0000" and check1 = "1001" and b0 = "1001" else 
					"0010" when check2 = "0001" and check1 = "1001" and b0 = "1001" else
					"0011" when check2 = "0010" and check1 = "1001" and b0 = "1001" else
					"0100" when check2 = "0011" and check1 = "1001" and b0 = "1001" else
					"0101" when check2 = "0100" and check1 = "1001" and b0 = "1001" else
					"0110" when check2 = "0101" and check1 = "1001" and b0 = "1001" else
					"0111" when check2 = "0110" and check1 = "1001" and b0 = "1001" else
					"1000" when check2 = "0111" and check1 = "1001" and b0 = "1001" else
					"1001" when check2 = "1000" and check1 = "1001" and b0 = "1001" else
					"0000" when check2 = "1001" and check1 = "1001" and b0 = "1001" else 
					check2;
			
		y2 <= tmp2;
	
END inc_arch;