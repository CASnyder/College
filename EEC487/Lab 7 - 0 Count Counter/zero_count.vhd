--**********************************************************
-- Experiment 7 - 4.1(d)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	zero_count.vhd
--
--	Design units:
--		ENTITY zero_count
--		ARCHITECTURE zero_count_arch
--
--	Purpose: count the number of 0's in a 10-bit input

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
USE work.util_pkg.ALL; 

ENTITY zero_count IS 
	PORT(
		c_clk, c_start, reset IN std_logic;
		a IN std_logic_vector(9 DOWNTO 0);
		ready OUT std_logic;
		count OUT std_logic_vector(3 DOWNTO 0)
	);
END zero_count; 

ARCHITECTURE zero_count_arch OF zero_count IS
	SIGNAL tick std_logic;
	
	BEGIN
	
	PROCESS(a, start)
		
		VARIABLE sum : unsigned(3 DOWNTO 0);
		BEGIN 
			sum := (others=>'0'); -- initial value
		IF (start = '1' and tick = '1' and clk = '1' and clk'event) THEN 
			FOR i IN 9 DOWNTO 0 LOOP
				IF a(i) = '0' THEN 
					sum := sum + 1;
				END IF;
			END LOOP;
		END IF; 
		count <= std_logic_vector(sum);
	END PROCESS;

END zero_count_arch;