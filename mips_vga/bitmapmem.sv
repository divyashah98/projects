//Bitmap memory module
`timescale 1ns / 1ps
`default_nettype none

module bitmapmem #(
    parameter bitmapmem_init = "bitmap_memory.txt"
  )(
    //2 characters implemented - bitmap_addr needs to go from 0-511 => 9 bits
    //number of bits required = $clog2(noOfCharacters x 256) - 1
    input wire [11:0] bitmap_addr,
    //each character has 256 pixels (16x16), using 12 bits for specifying RGB
    //value for a pixel, there would be 256 * 12 bits for each character
    output reg [11:0] color_value
  );
  //size fo the bitmap_mem depends on the number of characters we are
  //implementing. Currently, size = 512 lines as the number of characters are
  //two only. You can increase the size as you implement more characters
  //increse the size by 256 bits as you add more 16x16 characters
  //Also each location would point to a 12 bit RGB value for a pixel
  logic [11:0] bitmap_mem [1023:0];
  initial $readmemh (bitmapmem_init, bitmap_mem, 0, 1023);

  always_comb
    color_value = bitmap_mem[bitmap_addr];

endmodule
