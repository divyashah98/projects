library verilog;
use verilog.vl_types.all;
entity edge_detector_mealy is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        sig             : in     vl_logic;
        tick            : out    vl_logic
    );
end edge_detector_mealy;
