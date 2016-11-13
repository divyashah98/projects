module prog_sqr_wav_gen_tb ();
   reg CLK, reset;
   reg [3:0] m_tb;
   reg [3:0] n_tb;
   wire sqr_wav_tb;

   prog_sqr_wav_gen #(4) f1 (.clk(CLK), .reset(reset), .m(m_tb), .n(n_tb), .sqr_wav_o(sqr_wav_tb));
   localparam T = 20;

   always
   begin
     CLK = 1;
     #(T/2);
     CLK = 0;
     #(T/2);
   end

   initial
   begin
     reset = 1;
     #(T/2);
     reset = 0;
   end
   
   initial
   begin
     m_tb = 4'h0;
     n_tb = 4'h0;
     @ (negedge reset);
     @ (negedge CLK);
     m_tb = 4'h3;
     n_tb = 4'h3;
     repeat(50) @ (negedge CLK);
     @ (negedge CLK);
     m_tb = 4'h2;
     n_tb = 4'h1;
     repeat(50) @ (negedge CLK);
     $stop;
   end

endmodule
