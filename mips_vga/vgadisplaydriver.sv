
//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 10/2/2015 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.sv" // for somereason this line is notworking you may want to use the dir path of this file


module vgadisplaydriver #(
    parameter bitmap_init = "bmem.txt"
)(
    input wire clk,
    output logic [3:0] red, green, blue,
    output logic hsync, vsync,
    input wire [3:0] character_code,
    output wire [10:0] screen_addr
);

   wire [`xbits-1:0] x;
   wire [`ybits-1:0] y;
   wire activevideo;
   wire [11:0] bmem_addr;    //assuming 512 as the address range {2 16x16 characters}
   wire [11:0] bmem_color;   //4 bits for each R,G,B

   vgatimer myvgatimer(clk, hsync, vsync, activevideo, x, y);
   bitmapmem #(bitmap_init) bitmap_mem (bmem_addr, bmem_color);

   assign red   = (activevideo == 1) ? bmem_color[11:8] : 4'b0;
   assign green = (activevideo == 1) ? bmem_color[7:4] : 4'b0;
   assign blue  = (activevideo == 1) ? bmem_color[3:0]: 4'b0;

   //for now we will have two characters on the screen
   //one at (0,0) - (15x15) and the other right next to it
   assign screen_addr = {y[8:4], 5'b0} + {1'b0, y[9:4], 3'b0} + {4'b0, x[9:4]};
   assign bmem_addr = {character_code, y[3:0], x[3:0]};

endmodule
