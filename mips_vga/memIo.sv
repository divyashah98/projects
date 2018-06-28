//////////////////////////////////////////////////////////////////////////////////
// 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module memIO #(
    parameter Nloc  = 32,                      // Number of memory locations
    parameter Dbits = 32,                      // Number of bits in data
    parameter Abits = 32,                      // Number of bits in address
    parameter dmem_initfile = "dmem_init.txt",
    parameter screenmem_init = "screenmem_init.txt"
)(
    input wire clk, 
    input wire ps2_clk, 
    input wire mem_wr, 
    input wire [10:0] smem_addr,    //from VGA
    input wire [31:0] mem_addr,     //from CPU
    input wire [31:0] mem_writedata, 
    input wire ps2_data, 
    output logic [31:0] mem_readdata,
    output logic [3:0] charcode     //to VGA
 );

  wire [3:0] charcode0, charcode1;
  wire dmem_wr, smem_wr;
  wire [31:0] mem_readdata_cpu, keyb_char;

  dmem #(32, 32, 32, dmem_initfile) dmem(clk, dmem_wr, mem_addr, mem_writedata, mem_readdata_cpu);
  screenmem #(screenmem_init) Scr1 (clk, smem_wr, mem_addr, smem_addr, mem_writedata, charcode0, charcode1);
  keyboard kbd (clk, ps2_clk, ps2_data, keyb_char);

  assign dmem_wr        = ((mem_addr >= 'h0000_2000) && (mem_addr <= 'h0000_3FFF)) ? mem_wr : 'h0;
  assign mem_readdata   = (mem_addr == 'h0000_6000) ? keyb_char:
                          ((mem_addr >= 'h0000_4000) && (mem_addr <= 'h0000_4FFF)) ? charcode0 : mem_readdata_cpu;
  assign smem_wr        = ((mem_addr >= 'h0000_4000) && (mem_addr <= 'h0000_4FFF)) ? mem_wr : 'h0;
  assign charcode       = charcode1;

endmodule
