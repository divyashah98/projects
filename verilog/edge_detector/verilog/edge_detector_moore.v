module edge_detector_moore 
    ( input wire  clk, reset, 
      input wire sig,
      output reg tick
    );

    reg [1:0] state_q, state_next;
    localparam [1:0]    S0 = 2'b00,
                        S1 = 2'b01,
                        S2 = 2'b11; //single bit transisition is simpler

    always @(posedge clk, posedge reset)
    if (reset)
        state_q <= S0; 
    else 
        state_q <= state_next;

    always @ *
    begin
        state_next = state_q;
        tick = 1'b0;
        case (state_q)
            S0: 
                begin
                    tick = 1'b0;
                    if (sig)
                    state_next = S1;
                    else
                    state_next = S0;
               end
            S1: 
                begin
                    //state output
                    tick = 1'b1;
                    if (sig)
                    state_next = S2;
                    else
                    state_next = S0;
               end
            S2: 
                begin
                    tick = 1'b0;
                    if (sig)
                    state_next = S2;
                    else
                    state_next = S0;
               end
            default: state_next = S0;
        endcase
    end
endmodule
