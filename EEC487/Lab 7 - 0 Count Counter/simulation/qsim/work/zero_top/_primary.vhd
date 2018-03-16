library verilog;
use verilog.vl_types.all;
entity zero_top is
    port(
        clk             : in     vl_logic;
        start           : in     vl_logic;
        reset           : in     vl_logic;
        a               : in     vl_logic_vector(9 downto 0);
        ready           : out    vl_logic;
        count           : out    vl_logic_vector(3 downto 0)
    );
end zero_top;
