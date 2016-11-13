library verilog;
use verilog.vl_types.all;
entity fp_adder is
    port(
        sign1           : in     vl_logic;
        sign2           : in     vl_logic;
        exp1            : in     vl_logic_vector(3 downto 0);
        exp2            : in     vl_logic_vector(3 downto 0);
        frac1           : in     vl_logic_vector(7 downto 0);
        frac2           : in     vl_logic_vector(7 downto 0);
        sign_out        : out    vl_logic;
        exp_out         : out    vl_logic_vector(3 downto 0);
        frac_out        : out    vl_logic_vector(7 downto 0)
    );
end fp_adder;
