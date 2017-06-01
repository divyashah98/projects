`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:25:02 04/27/2017 
// Design Name: 
// Module Name:    flip-flop 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module flip-flop(clk, reset, sig, posedgesig_f, negedgesig_f
    );
	 
	 input clk, sig, reset;
	 output posedgesig_f, negedgesig_f;
	 
	 reg sig_d;
	 
	 
	 always @ (posedge clk or negedge reset) 
	 
	 if (!reset) begin
		sig_d = 0;
	 end else begin
		sig_d = sig;
	 end 
	 
	 assign posedgesig_f = sig & !sig_d;
	 assign negedgesig_f = !sig & sig_d;

endmodule
