module edge_detector_mealy (
    input wire  clk, reset, 
    input wire sig,
    output reg tick
);

    reg state_q, state_next;
    localparam     S0 = 1'b0,
                   S1 = 1'b1;

    always @(posedge clk, posedge reset)
    if (reset)
        state_q <= S0; 
    else 
        state_q <= state_next;

    always @ *
    begin
        // Drive the default values
        state_next = state_q;
        tick = 1'b0;
        case (state_q)
            S0: 
               if (sig)
               begin
                 state_next = S1;
                 tick = 1'b1;
               end
               else
                 state_next = S0;
            S1: 
               if (sig)
               begin
                 state_next = S1;
               end
               else
               begin
                 state_next = S0;
               end
            default: state_next = S0;
        endcase
    end
endmodule
