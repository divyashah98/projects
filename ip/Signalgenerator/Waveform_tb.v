`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:05:30 04/10/2017
// Design Name:   Waveform2
// Module Name:   /home/oepi_04/B.A/Wavegenerator/Waveform2_TB.v
// Project Name:  Wavegenerator
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Waveform2
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Waveform2_TB;

 // Inputs
 reg clk;
 reg reset;
 reg start_f;
 reg [11:0] ktp;
 reg [5:0]  sktp;
 reg [11:0] ipd;
 reg [11:0] adp;
 reg [5:0] sadp;

 // Outputs
 wire  done_f;
 
 wire [5:0] sink;
 wire [5:0] src;
 
 // Instantiate the Unit Under Test (UUT)
 Waveform2 uut (
  .clk(clk), 
  .reset(reset), 
  .start_f(start_f), 
  .ktp(ktp), 
  .sktp(sktp), 
  .ipd(ipd), 
  .adp(adp), 
  .sadp(sadp), 
  .done_f(done_f) ,
  .sink(sink),
  .src(src)
  
  
 );

 initial begin
  // Initialize Inputs
  clk <= 0;
  reset= 1;
  #50 reset = 0;
  #50 reset = 1;
  start_f = 0;
  ktp = 100;
  sktp = 40;
  ipd = 15;
  adp = 80;
  sadp = 50;
  
  

  // Wait 100 ns for global reset to finish
  #100 start_f = 1;
  #100 start_f = 0;
      
      #2000 start_f = 1;
    
  // Add stimulus here

 end
      
 always @(*)
 begin
  #5 clk <= ~clk;
 end
 /*if (reset==0)begin
 
 end else begin
 
 end
 */
 
 
 
 
 

endmodule
