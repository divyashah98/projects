library verilog;
use verilog.vl_types.all;
entity prog_sqr_wav_gen is
    generic(
        \N\             : integer := 4
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        m               : in     vl_logic_vector;
        n               : in     vl_logic_vector;
        sqr_wav_o       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of \N\ : constant is 1;
end prog_sqr_wav_gen;
