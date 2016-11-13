library verilog;
use verilog.vl_types.all;
entity fp_int_conv is
    port(
        sign1           : in     vl_logic;
        exp1            : in     vl_logic_vector(3 downto 0);
        frac1           : in     vl_logic_vector(7 downto 0);
        int_num         : out    vl_logic_vector(7 downto 0)
    );
end fp_int_conv;
