//////////////////////////////////////////////////////////////////////////////////
// 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module top #(
    parameter imem_init="imem.txt",
    parameter dmem_init="dmem.txt",
    parameter scrmem_init="smem.txt",		// text file to initialize screen memory
    parameter bitmap_init="bmem.txt"			// text file to initialize bitmap memory
)(
    input wire clk, reset
);
   
   wire [3:0] red;	// add I/O signals here
   wire [3:0] green;	// add I/O signals here
   wire [3:0] blue;	// add I/O signals here
   wire hsync;      // incl. VGA signals
   wire vsync;
   wire [31:0] pc, instr, mem_readdata, mem_writedata, mem_addr;
   wire mem_wr;
   wire clk100, clk50, clk25, clk12;
   wire [10:0] smem_addr;    //resolution of 640x480 and 16x16 characters (1200)
   wire [3:0] charcode;  //assuming only 2 characters for now

   // Uncomment *only* one of the following two lines:
   //    when synthesizing, use the first line
   //    when simulating, get rid of the clock divider, and use the second line
   //
   //clockdivider_Nexys4 clkdv(clk, clk100, clk50, clk25, clk12);
   assign clk100=clk; assign clk50=clk; assign clk25=clk; assign clk12=clk;

   // For synthesis:  use an appropriate clock frequency(ies) below
   //   clk100 will work for only the most efficient designs (hardly anyone)
   //   clk50 or clk 25 should work for the vast majority
   //   clk12 should work for everyone!
   //
   // Use the same clock frequency for the MIPS and data memory/memIO modules
   // The vgadisplaydriver should keep the 100 MHz clock.
   // For example:

   mips mips(clk12, reset, pc, instr, mem_wr, mem_addr, mem_writedata, mem_readdata);
   imem #(32, 32, 32, imem_init) imem(pc[31:0], instr);
   memIO #(32, 32, 32, dmem_init, scrmem_init) memIO(clk12, clk12, mem_wr, smem_addr, mem_addr, mem_writedata, 1'h1, mem_readdata, charcode); 
   //'h1 in the above module is for the ps2_data which should be 1 in this case 
   //as the keyboard won't be accepting any commands
   vgadisplaydriver #(bitmap_init) display(clk100, red, green, blue, hsync, vsync, charcode, smem_addr);

endmodule
