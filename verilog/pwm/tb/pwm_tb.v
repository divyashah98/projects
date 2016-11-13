module pwm_tb ();
   reg CLK, reset;
   reg [3:0] n_tb;
   wire pwm_tb;

   pwm f1 (.clk(CLK), .reset(reset), .n(n_tb), .pwm(pwm_tb));
   localparam T = 100;

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
     n_tb = 4'h0;
     @ (negedge reset);
     @ (negedge CLK);
     n_tb = 4'h1;
     repeat(50) @ (negedge CLK);
     n_tb = 4'h2;
     repeat(50) @ (negedge CLK);
     n_tb = 4'h3;
     repeat(50) @ (negedge CLK);
     n_tb = 4'h4;
     repeat(50) @ (negedge CLK);
     n_tb = 4'h5;
     repeat(50) @ (negedge CLK);
     n_tb = 4'h6;
     repeat(50) @ (negedge CLK);
     n_tb = 4'h7;
     repeat(50) @ (negedge CLK);
     n_tb = 4'h8;
     repeat(50) @ (negedge CLK);
     n_tb = 4'h9;
     repeat(50) @ (negedge CLK);
     n_tb = 4'ha;
     repeat(50) @ (negedge CLK);
     n_tb = 4'hb;
     repeat(50) @ (negedge CLK);
     n_tb = 4'hc;
     repeat(50) @ (negedge CLK);
     n_tb = 4'hd;
     repeat(50) @ (negedge CLK);
     n_tb = 4'he;
     repeat(50) @ (negedge CLK);
     n_tb = 4'hf;
     repeat(50) @ (negedge CLK);
     $stop;
   end

endmodule
