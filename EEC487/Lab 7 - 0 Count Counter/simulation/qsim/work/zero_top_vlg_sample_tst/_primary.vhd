library verilog;
use verilog.vl_types.all;
entity zero_top_vlg_sample_tst is
    port(
        a               : in     vl_logic_vector(9 downto 0);
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        start           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end zero_top_vlg_sample_tst;
