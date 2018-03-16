library verilog;
use verilog.vl_types.all;
entity eq2 is
    port(
        a               : in     vl_logic_vector(1 downto 0);
        b               : in     vl_logic_vector(1 downto 0);
        aeqb            : out    vl_logic
    );
end eq2;
