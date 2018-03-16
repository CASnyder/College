--**********************************************************
-- Experiment 5 - 4.3(a)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	counter2.vhd
--
--	Design units:
--		ENTITY counter3
--		ARCHITECTURE counter3_arch
--
--	Purpose: mod-8 counter; uses tick2 pulse
--				can pause, count up, and count down
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

ENTITY counter3 IS 
	PORT(
		clk_c3: IN std_logic;
		tick2_c3, cw_c3, pa_c3: std_logic;
		q: out std_logic_vector(2 DOWNTO 0)
	);
END counter3;

ARCHITECTURE counter3_arch OF counter3 IS
	
	SIGNAL fw_reg, fw_next, bw_reg, bw_next: std_logic_vector(2 DOWNTO 0);
	SIGNAL dir1, dir2: std_logic_vector(2 DOWNTO 0);
	SIGNAL enable: std_logic;
	
	BEGIN
	
	--register
	PROCESS(clk_c3, pa_c3)
		BEGIN
			IF(clk_c3'event and clk_c3='1' and tick2_c3 = '1' and pa_c3='0') THEN
				fw_reg  <= fw_next;
				bw_reg <= bw_next;
				dir1 <= dir2;
			END IF;
	END PROCESS;
	
	--next state logic
	enable <= '1' when tick2_c3 = '1' else '0';
	
	--count forwards
	fw_next <= (others => '0') WHEN (fw_reg  = 7 and enable = '1') else fw_reg WHEN enable = '0' else fw_reg + 1;
	
	--count backwards
	bw_next <= (others => '1') WHEN (bw_next = 0 and enable ='1') else bw_reg WHEN enable = '0' else bw_reg - 1; 
	
	--assign the direction value
	dir2 <= fw_next WHEN (cw_c3 = '1') ELSE bw_next;
	
	--output 
	q <= dir1; 
	
END counter3_arch;
