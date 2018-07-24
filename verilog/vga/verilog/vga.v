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

  reg [9:0] hp_count;               // Horizontal pixel count
  reg [9:0] vp_count;               // Vertical pixel count

  reg [9:0] x;
  reg [9:0] y;

  always @ (posedge clk or posedge reset)
  if (reset) begin
    x <= 10'h0;
    y <= 10'h0;
  end
  else begin
    x <= hp_count;
    y <= vp_count;
  end

  always @(*) begin
    hp_count = x;
    vp_count = y;
    if (pix_strb_i) begin
      if (x == LINE) begin
        hp_count = 10'h0;
        vp_count = y + 1'b1;
      end
      else
        hp_count = x + 1'b1;
      if (y == SCREEN)
        vp_count = 10'h0;
    end
  end

  // Assign the outputs based on the current pixel positions
  assign x_o = (x < HP_STA) ? 10'h0 : (x - HP_STA);
  assign y_o = (y >= VP_END) ? (VP_END - 1) : vp_count;

  assign hs_o = (hp_count >= HS_STA) && (hp_count < HS_END);
  assign vs_o = (vp_count >= VS_STA) && (vp_count < VS_END);

  assign blanking_o = (hp_count < HP_STA) || (vp_count < VP_END);

  assign active_o = ~blanking_o;

  // High when we reach the end of the screen
  assign screenend_o = (vp_count == SCREEN-1) & (hp_count == LINE);
  // High for a cycle once the active pixel area ends
  assign animate_o = (vp_count == VP_END - 1) & (hp_count == LINE);

endmodule
