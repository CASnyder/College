library verilog;
use verilog.vl_types.all;
entity zero_top_vlg_check_tst is
    port(
        count           : in     vl_logic_vector(3 downto 0);
        ready           : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end zero_top_vlg_check_tst;
