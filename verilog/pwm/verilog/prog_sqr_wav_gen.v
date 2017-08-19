/* 
    The inputs m and n are interpreted as unsigned integers
    The on and off intervals are m * 100ns and n * 100ns
*/
module prog_sqr_wav_gen
    # ( parameter N = 4 // bits to specify the duration of the interval
      )
      (
        input wire clk, reset,
        input wire [N-1:0] m, n,
        output wire sqr_wav_o
      );
      //It is assumed that this program
      //is run on an FPGA board with
      //oscillator period as 20 ns
      localparam DESIRED_CYCLE = 5;
      reg   [2:0] hundred_ns_q; 
      wire  [2:0] hundred_ns_next;
      reg   [N-1:0] on_time_q, off_time_q;
      reg   [N-1:0] on_time_next, off_time_next;
      wire  hundred_ns_tick;
      reg   on_time_comp_next, off_time_comp_next;
      reg   on_time_comp_q, off_time_comp_q;

      always @ (posedge clk, posedge reset)
      if (reset)
      begin
        hundred_ns_q        <= 0;
        on_time_q           <= 0;
        off_time_q          <= 0;
        off_time_comp_q     <= 1;
        on_time_comp_q      <= 0;
      end
      else
      begin
        hundred_ns_q        <= hundred_ns_next;
        on_time_q           <= on_time_next;
        off_time_q          <= off_time_next;
        off_time_comp_q     <= off_time_comp_next;
        on_time_comp_q      <= on_time_comp_next;
      end

      assign hundred_ns_next = (hundred_ns_q == DESIRED_CYCLE) ? 0: hundred_ns_q + 1;
      assign hundred_ns_tick = (hundred_ns_q == DESIRED_CYCLE);

      always @ *
      if (hundred_ns_tick)
      begin
        if (on_time_q >= (m-1))
        begin
            on_time_comp_next  = 1'b1;
            off_time_comp_next = 1'b0;
        end
        else if (off_time_q >= (n-1))
        begin
            on_time_comp_next  = 1'b0;
            off_time_comp_next = 1'b1;
        end
        else
        begin
            on_time_comp_next  = on_time_comp_q;
            off_time_comp_next = off_time_comp_q;
        end
        if (off_time_comp_q)
        begin
            on_time_next = (on_time_q >= (m-1)) ? 0 : on_time_q + 1;
            off_time_next = off_time_q;
        end
        if (on_time_comp_q)
        begin
            off_time_next = (off_time_q >= (n-1)) ? 0 : off_time_q + 1;
            on_time_next = on_time_q;
        end
      end
      else 
      begin
        on_time_comp_next = on_time_comp_q;
        off_time_comp_next = off_time_comp_q;
        on_time_next = on_time_q;
        off_time_next = off_time_q;
      end

     assign sqr_wav_o = ~on_time_comp_q;
endmodule
