library verilog;
use verilog.vl_types.all;
entity pwm is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        n               : in     vl_logic_vector(3 downto 0);
        pwm             : out    vl_logic
    );
end pwm;
