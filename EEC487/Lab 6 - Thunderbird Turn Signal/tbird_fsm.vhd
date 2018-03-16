--**********************************************************
-- Experiment 6 - 4.2(c)
--	Author: C. A. Snyder
--			  M. Bbela
--			  B. Rutledge
--	
--	File:	tbird_fsm.vhd
--
--	Design units:
--		ENTITY tbird_fsm
--		ARCHITECTURE tbird_arch
--
--	Purpose: hold states for tbird  
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
--		Date: 10/26/2015
--		Comments: Original
--**********************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL; 

ENTITY tbird_fsm IS
	PORT(
		fsm_clk, fsm_reset: std_logic;
		fsm_tick, fsm_left, fsm_right, fsm_haz: std_logic;
		fsm_light: out std_logic_vector(5 downto 0)
	);
 END tbird_fsm;
 
ARCHITECTURE tbird_arch OF tbird_fsm IS
		type state_tbird is (s0,s1,s2,s3,s4,s5,s6,s7);
		signal state_reg, state_next: state_tbird; 
begin
		process(fsm_clk,fsm_reset)
		begin
			if (fsm_reset= '1') then
				state_reg <= s0;
			elsif (fsm_clk'event and fsm_clk = '1' and fsm_tick='1') then
				state_reg<=state_next;
			end if;
		end process;
		-- next_state logic
		process(state_reg,fsm_left,fsm_right,fsm_clk,fsm_haz)
		begin
			case state_reg is
			when s0=>
						if fsm_left = '1' then
							state_next<= s1; 
							elsif fsm_right = '1' then
							state_next <= s4 ;	
						elsif fsm_haz = '1' then
							state_next <= s7;
						end if;
			when s1=>
						if fsm_haz ='1' then
							state_next <= s0;
						else
							state_next <= s2;
						end if;
			when s2=>
						if fsm_haz ='1' then
							state_next <= s0;
						else
							state_next <= s3;
						end if;
			when s3=>
						state_next <= s0;
			when s4=>						
						if fsm_haz ='1' then
							state_next <= s0;
						else
							state_next <= s5;
						end if;
			when s5=>
						if fsm_haz ='1'	then
							state_next <= s0;
						else
							state_next <= s6;
						end if;
			when s6=>
						state_next <= s0;
			when s7=>
						state_next <= s0;
			end case;
						
		end process;		
		process(state_reg)
		begin	
			case state_reg is
				when s0 =>
							 fsm_light<="000000";
				when s1 =>
							 fsm_light<="001000";
				when s2 =>
							 fsm_light<="011000";
				when s3 =>
							 fsm_light<="111000";
				when s4 =>
							 fsm_light<="000100";
				when s5 =>
							 fsm_light<="000110";
				when s6 =>
							 fsm_light<="000111";
				when s7 =>
							 fsm_light<="111111";
				end case;
			end process;
			
			
								
	
END tbird_arch; 
