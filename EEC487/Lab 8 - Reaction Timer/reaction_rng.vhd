--**********************************************************
-- Experiment 8 - 4.1(d)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	reaction_rng.vhd
--
--	Design units:
--		ENTITY reaction_rng
--		ARCHITECTURE rng_arch
--
--	Purpose: random number generator (between 1 and 7) 
--				for reaction timer
--				is always counting regardless of whether or not the circuit
--				has been cleared 
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
--		Date: 11/10/2015
--		Comments: Original
--**********************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY reaction_rng IS 
	PORT( 
		rng_clk, rng_start : IN std_logic;
		rng_out : OUT std_logic_vector (2 DOWNTO 0)
	);
END reaction_rng;

ARCHITECTURE rng_arch OF reaction_rng IS
	
	SIGNAL temp_reg, temp_next : std_logic_vector(2 DOWNTO 0);
	
	BEGIN
	
	--register
	PROCESS(rng_clk)
	BEGIN
		IF(rng_clk'event and rng_clk = '1' and rng_start = '1') THEN 
			temp_reg <= temp_next;
	END IF;
	END PROCESS

	--next state logic
	temp_reg <= temp_next + 1 when (temp_next /= "000") else "001";
	
	--output logic
	rng_out <= temp_reg;
		
	
END rng_arch;