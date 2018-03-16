library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity zero is
	port (
		clk, reset: in std_logic;
		start: in std_logic;
		a: in std_logic_vector(9 downto 0);
		ready: out std_logic;
		count: out std_logic_vector(3 downto 0)
	);
end zero;

architecture arch of zero is

constant WIDTH: integer :=10;
type state_type is (load, countzeros);
signal state_reg, state_next: state_type;
signal width_signal: integer;
signal a_next, a_reg: std_logic_vector(9 downto 0);
signal count_next, count_reg: std_logic_vector(3 downto 0);


begin
	process(clk, reset)
	begin
		if reset='1' then
			state_reg <= load;
			a_reg <= (others =>'0');
			count_reg <= (others =>'0');
			ready <='1';
						
		elsif (clk'event and clk = '1') then 
			state_reg <= state_next;
			a_reg <= a_next;
			count_reg <= count_next;
		end if;
		
	end process;
	
	process(start, state_reg, a_reg, count_reg, a)
	
	begin
	
		a_next <= a_reg;
		count_next <= count_reg;
		
		case state_reg is
			when load =>
			
				if (start='1' and reset='0') then
						a_next <= a;
						width_signal <= WIDTH;
						state_next <= countzeros;
				else	
					state_next <= load;
				end if;
				
				ready <='1';
				
			when countzeros =>
				if (width_signal = 0) then 
					state_next <= load;
				elsif a_reg(width_signal) = '0' then
					count_next <= count_reg + '1';
					width_signal<= width_signal - 1;
					state_next <= countzeros;
				end if;
				
		end case;
	end process;
	count<= count_next;	
end arch;