// Screen memory module
`timescale 1ns / 1ps
`default_nettype none

module screenmem #(
    parameter screenmem_init = "screen_memory.txt"
  )(
    input wire clk, 
    input wire mem_wr,
    input wire [31:0] screen_addr0, // resolution 640x480, 16x16 characher bits - CPU addr, would depend on the memory map
    input wire [10:0] screen_addr1, // resolution 640x480, 16x16 characher bits - VGA display driver
    input wire [31:0] mem_writedata,
    //each screen address would contain a character code.
    output logic [3:0] character_code0,
    output logic [3:0] character_code1
  );
  logic [3:0] screen_mem [1199:0];

  initial $readmemh (screenmem_init, screen_mem, 0, 1199);

  always_ff @(posedge clk)      // Memory write: only when mem_wr==1, and at posedge clock - Only CPU can write
    if(mem_wr)
      screen_mem[(screen_addr0 - 'h4000)] = mem_writedata;

  always_comb
    if (mem_wr == 0)              // Memory read: only when mem_wr==0 
    begin
      assign character_code0      = screen_mem[(screen_addr0-'h4000)];
      assign character_code1      = screen_mem[(screen_addr1)];
    end
endmodule
