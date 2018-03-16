--***************************************************************
--
-- Authors: C. A. Snyder
--				B. Rutledge
--				M. Bbela 	
--			
-- File: maj.vhd
--
-- Design units:
--
-- ENTITY maj
-- ARCHITECTURE maj_arch
-- Purpose: count 4 votes 
-- Inputs: v: 4 bit, represents votes
-- Outputs: pass: 1 bit, asserted when there is a majority
--				tie: 1 bit, asserted when the vote is a tie
--				fail: 1 bit, asserted when the motion fails
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
-- Date: 9/13/2015
-- Comments: Original
--
--*************************************************************** 
LIBRARY ieee;
USE ieee.std_logic_1164.all;	
ENTITY maj IS
	PORT (
		v: IN std_logic_vector(3 DOWNTO 0);
		fail, tie, pass: OUT std_logic
	);
END maj;

ARCHITECTURE maj_arch OF maj IS

	--no need for extra signals in this circuit
	
	BEGIN
			--motion passes; 3 or more "yes" votes
			pass <= (v(1) and v(2) and v(3)) 
							or (v(0) and v(2) and v(3)) 
							or (v(0) and v(1) and v(3)) 
							or (v(0) and v(1) and v(2));
			
			--motion fails; 3 or more "no" votes 
			fail <= ((not v(0)) and (not v(2)) and (not v(3))) 
							or ((not v(0)) and (not v(1)) and (not v(2))) 
							or ((not v(1)) and (not v(2)) and (not v(3))) 
							or ((not v(0)) and (not v(1)) and (not v(3)));
			
			--motion is a tie; 2 "yes" votes and 2 "no" votes
			tie <=  ((not v(0)) and (not v(1)) and (v(2)) and (v(3)))
						or ((not v(0)) and (v(1)) and (not v(2)) and (v(3)))
						or ((not v(0)) and (v(1)) and (v(2)) and (not v(3))) 
						or ((v(0)) and (v(1)) and (not v(2)) and (not v(3))) 
						or ((v(0)) and (not v(1)) and (not v(2)) and (v(3)))
						or ((v(0)) and (not v(1)) and (v(2)) and (not v(3))); 

END maj_arch;