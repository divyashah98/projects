`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:07:29 04/27/2017 
// Design Name: 
// Module Name:    shift_reg 
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
module shift_reg(
	 input wire clk,
	 input wire reset_n,
	 input wire pad_din,
	 input wire pad_cs,
	 input wire pad_sck,
	 output wire pad_dout
	 );
	 
	 wire posedge_cs;
	 reg [23:0] shiftreg;
	 
	  flip-flop f1 (.posedgesig_f(posedge_cs), .clk(clk), .reset(reset_n), .sig(pad_cs), .negedgesig_f ());

//Schieberegister	 
	 always @ (posedge pad_sck or negedge reset_n)
	 if (!reset_n) begin
		shiftreg = 24'h000000;
		end else begin
			if (posedge_cs) begin
			shiftreg [23:0] = {shiftreg [22:0], pad_din};
			end else begin
				shiftreg = shiftreg;
		end
	 end

// Assign the output signal
    assign pad_dout = shiftreg [23];
	 
endmodule


