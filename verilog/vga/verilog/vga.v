// Module for 640x480 VGA driver
module vga_640x480 (
  input   wire        clk,          // Actual FPGA clock
  input   wire        pix_strb_i,   // The pixel clocl
  input   wire        reset,        // Reset signal
  output  wire        hs_o,         // Horizontal sync
  output  wire        vs_o,         // Veritical Sync
  output  wire        blanking_o,   // Blanking region
  output  wire        active_o,     // Active Pixel region
  output  wire        screenend_o,  // End of screen
  output  wire        animate_o,    // End of active drawing
  output  wire [9:0]  x_o,          // Pixel x position
  output  wire [8:0]  y_o           // Pixel y position
);

  parameter HS_STA = 16;            // Horizontal sync start
  parameter HS_END = HS_STA + 96;   // Horizontal sync end

  parameter HP_STA = HS_END + 48;   // Horizontal active pixel start
  parameter HP_END = HP_STA + 640;  // Horizontal active pixel end

  parameter VP_END = 480;           // Vertical active pixel end

  parameter VS_STA = VP_END + 11;   // Vertical sync start
  parameter VS_END = VS_STA + 2;    // Vertical sync end

  parameter LINE = 800;             // Complete Horizontal line
  parameter SCREEN = 524;           // Complete Vertical screen

endmodule
