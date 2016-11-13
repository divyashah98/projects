module fifo_tb ();
   reg CLK, reset;
   reg rd_tb, wr_tb;
   reg [31:0] wr_data_tb;
   wire [31:0] rd_data_tb;

   fifo #(32, 4) f1 (.clk(CLK), .reset(reset), .rd(rd_tb), .wr(wr_tb), .wr_data(wr_data_tb), .rd_data(rd_data_tb));
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
     rd_tb = 0;
     wr_tb = 0;
     wr_data_tb = 32'h0;
     @ (negedge reset);
     //Wait for few clk cycles
     repeat (2) @ (negedge CLK);
     //try to read from an empty buffer
     rd_tb = 1;
     @ (negedge CLK);
     //write data the very next cycle
     rd_tb = 0;
     wr_tb = 1;
     wr_data_tb = 32'hdeadbeef;
     @ (negedge CLK);
     //read and write data in the next cycle
     rd_tb = 1;
     wr_data_tb = 32'h12345678;
     @ (negedge CLK);
     //Read the data to empty the buffer
     //Flip write data as well
     rd_tb = 1;
     wr_tb = 0;
     wr_data_tb = ~wr_data_tb;
     //Wait for few cycles in the same state
     //read data should still same as previous
     repeat (4) @ (negedge CLK);
     //Fill the buffer completely
     @(negedge CLK);
     rd_tb = 0;
     wr_tb = 1;
     wr_data_tb = 32'h0;
     @(negedge CLK);
     wr_data_tb = 32'h1;
     @(negedge CLK);
     wr_data_tb = 32'h2;
     @(negedge CLK);
     wr_data_tb = 32'h3;
     //Try to write to a full buffer
     @(negedge CLK);
     wr_data_tb = 32'h4;
     //Read back all the data
     @(negedge CLK);
     rd_tb = 1;
     wr_tb = 0;
     repeat (4) @(negedge CLK);
     $finish;
   end

   initial
   begin
     $monitor ("Time:%d\tCLK:%b\treset:%b\tRead:%b\tWrite:%b\tWriteData:%h\tReadData:%h",$time, CLK, reset, rd_tb, wr_tb, wr_data_tb, rd_data_tb);
   end

endmodule
