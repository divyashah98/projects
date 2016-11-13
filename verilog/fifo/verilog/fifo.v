module fifo 
    # ( parameter N = 8,
                  D = 4
      )
      (
        input wire clk, reset,
        input wire rd, wr, 
        input wire [N-1:0] wr_data,
        output wire [N-1:0] rd_data
      );

      reg [N-1:0] fifo_reg [2**D-1:0];
      reg [D-1:0] w_pointer_q, w_pointer_next, w_pointer_succ;
      reg [D-1:0] r_pointer_q, r_pointer_next, r_pointer_succ;
      reg full_q, full_next, empty_q, empty_next;

      wire wr_en;

      always @ (posedge clk)
      if (wr_en)
        fifo_reg [w_pointer_q] <= wr_data;
      
      assign rd_data = fifo_reg [r_pointer_q];
      assign wr_en = wr & ~full_q;

      always @ (posedge clk, posedge reset)
      if (reset)
      begin
        w_pointer_q <= 0;
        r_pointer_q <= 0;
        full_q      <= 0;
        empty_q     <= 1;
      end
      else
      begin
        w_pointer_q <= w_pointer_next;
        r_pointer_q <= r_pointer_next;
        full_q      <= full_next;
        empty_q     <= empty_next;
      end

      always @ *
      begin
        //assign the default values
        w_pointer_next = w_pointer_q;
        r_pointer_next = r_pointer_q;
        full_next      = full_q;
        empty_next     = empty_q;
        w_pointer_succ = w_pointer_q + 1;
        r_pointer_succ = r_pointer_q + 1;
        case ({wr, rd})
            //2'b00:  // no operation
            2'b01:  
                if (~empty_q)
                begin
                  r_pointer_next = r_pointer_succ;
                  empty_next = (r_pointer_succ == w_pointer_q) ? 1'b1 : empty_q;
                  full_next = 1'b0;
                end
            2'b10:  // write
                if (~full_q)
                begin
                  w_pointer_next = w_pointer_succ;
                  full_next = (w_pointer_succ == r_pointer_q) ? 1'b1 : full_q;
                  empty_next = 1'b0;
                end
            2'b11: 
                begin
                  w_pointer_next = w_pointer_succ;
                  r_pointer_next = r_pointer_succ;
                end
        endcase
      end
endmodule
