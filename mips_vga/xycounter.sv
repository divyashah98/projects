
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2016 12:35:32 AM
// Design Name: 
// Module Name: xycounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`default_nettype none

module xycounter #(parameter width=2, height=2)(
  input wire clock,
  input wire enable,
  output logic [$clog2(width)-1:0] x=0,
  output logic [$clog2(height)-1:0] y=0
  );
  
  always_ff @(posedge clock) begin
    if(enable)
      if(x != width -1)
        x <= x+1;
      else begin
        x <= 0;
        if(y != height -1)
          y <= y+1;
        else
          y <= 0;  
      end  
  end    
endmodule
