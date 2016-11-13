library verilog;
use verilog.vl_types.all;
entity fifo is
    generic(
        N               : integer := 8;
        D               : integer := 4
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        rd              : in     vl_logic;
        wr              : in     vl_logic;
        wr_data         : in     vl_logic_vector;
        rd_data         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
    attribute mti_svvh_generic_type of D : constant is 1;
end fifo;
