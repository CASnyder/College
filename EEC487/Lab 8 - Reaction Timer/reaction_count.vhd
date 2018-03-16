--**********************************************************
-- Experiment 8 - 4.1(d)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	reaction_count.vhd
--
--	Design units:
--		ENTITY reaction_count
--		ARCHITECTURE counter_arch
--
--	Purpose: count from 000 to 999 
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

ENTITY reaction_count IS 
	PORT( 
		c_clk, c_clear, c_stop, c_start : IN std_logic;
		c_count : OUT std_logic_vector(10 DOWNTO 0);
		tooSlow : OUT std_logic; 
	);
END reaction_count;

ARCHITECTURE counter_arch OF reaction_count IS
	
	SIGNAL count_reg, count_next : std_logic_vector(10 DOWNTO 0); 
	SIGNAL t_reg, t_next: std_logic_vector(24 DOWNTO 0);
	SIGNAL ts_Reg, ts_Next : std_logic;
	 
	BEGIN
	
	--register
	PROCESS(c_clk, c_clear, c_stop, c_start)
	BEGIN
		IF (c_clk'event and c_clk = '1') THEN
			t_reg <= t_next; 
			count_reg <= count_next
			ts_Reg <= ts_Next; 
		END IF;
	END PROCESS;
	
	--next state logic
	--increment on 1 ms ticks
	--get to 999 and then stay there forever 
	--the tooslow flag will handle the rest
	t_next <= (others => '0') when t_reg= 500000 else t_reg + 1;
	
	count_next <= count_reg + 1 when (t_reg = 500000 and count_reg /= 999) else count_reg;
	
	ts_Next <= '1' when count_reg = 999 else '0';  
	
	c_count <= count_reg;
	tooSlow <= ts_Reg;
	
END counter_arch;