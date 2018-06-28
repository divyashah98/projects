`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2016 06:53:14 PM
// Design Name: 
// Module Name: datapath
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


module datapath#(
  parameter Nloc = 32,           
  parameter Dbits = 32,
  parameter Abits = 32
  )(
    input  wire clk,
    input  wire reset,
    input  wire [31:0] instr,
    input  wire [1:0] pcsel,
    input  wire [1:0] wasel, 
    input  wire sext,
    input  wire bsel,
    input  wire [1:0] wdsel, 
    input  wire [4:0] alufn,
    input  wire werf, 
    input  wire [1:0] asel,
    
    output bit [31:0] pc, 
    output wire Z,
    output wire [31:0] mem_addr, 
    output wire [31:0] mem_writedata,
    input wire [31:0] mem_readdata
    );
      
      wire [31:0] ReadAddr1, ReadAddr2, ReadData1, ReadData2, reg_writeaddr, reg_writedata; 
      wire [31:0] aluA, aluB, alu_result;
      wire [31:0] signImm;
      wire RegWrite;
      wire [31:0] BT, JT;
      bit [31:0] pc_reg;

      assign pc_reg = (pcsel == 'h0) ? (pc + 'h4) :
                (pcsel == 'h1) ? (BT)     :
                (pcsel == 'h2) ? ({pc[31:28], instr[25:0], 2'b00}) :
                (pcsel == 'h3) ?  JT :
                (pcsel == 'h4) ? 'h0: 'h0;
      assign RegWrite = werf;
      assign ReadAddr1 = instr[25:21];
      assign ReadAddr2 = instr[20:16];
      assign reg_writeaddr = (wasel == 0) ? instr[15:11] :
                          (wasel == 1) ? instr[20:16] :
                          'h1F;
      assign reg_writedata = (wdsel == 0) ? (pc + 'h4)  :
                          (wdsel == 1) ? alu_result :
                          mem_readdata;
      assign aluA = (asel == 0) ? ReadData1 :
                     (asel == 1) ? instr[10:6] : 
                     'h10;
      assign signImm = (sext == 0) ? {{(16){1'b0}}, instr[15:0]} :
                           {{(16){instr[15]}}, instr[15:0]};
      assign aluB = (bsel == 0) ? ReadData2 :
                     signImm; 
      assign BT = (signImm << 2) + pc + 'h4;
      assign JT = ReadData1;
      assign mem_addr = alu_result;
      assign mem_writedata = ReadData2;
      pc_register pc1 (pc, pc_reg, clk, reset);
      register_file register_file (clk, RegWrite, ReadAddr1, ReadAddr2, reg_writeaddr, reg_writedata, ReadData1, ReadData2);
      ALU ALU (aluA, aluB, alu_result, alufn, Z);
endmodule

module pc_register (
                output logic [31:0] pc_out,
                input  logic [31:0] pc_in,
                input  wire  clk  ,
                input  wire  reset
                );
always_ff @(posedge clk )
      pc_out <= pc_in;
endmodule
