module vga_top (
  input   wire        clk,
  input   wire        reset,
  output  wire [3:0]  red_pix_o,
  output  wire [3:0]  green_pix_o,
  output  wire [3:0]  blue_pix_o,
  output  wire        hs_o,
  output  wire        vs_o
);

  wire          hs;
  wire          vs;
  wire          blanking;
  wire          active;
  wire          screenend;
  wire          animate;
  wire  [16:0]  nxt_clk_count;
  wire  [9:0]   x_pos;
  wire  [8:0]   y_pos;

  reg   [15:0]  clk_count;
  reg           pix_strb;

  vga_640x480 VGA (
    .clk          (clk),
    .reset        (reset),
    .pix_strb_i   (pix_strb),
    .hs_o         (hs),
    .vs_o         (vs),
    .blanking_o   (blanking),
    .active_o     (active),
    .screenend_o  (screenend),
    .animate_o    (animate),
    .x_o          (x_pos),
    .y_o          (y_pos)
  );

  always @ (posedge clk or posedge reset)
  if (reset) begin
    clk_count = 16'h0;
    pix_strb = 1'b0;
  end
  else
    {pix_strb, clk_count} = nxt_clk_count;

  assign nxt_clk_count = clk_count + 16'h8000;
  
  assign hs_o = ~hs; // active low
  assign vs_o = ~vs; // active low

  assign red_pix_o [3]    = ((x_pos > 10'd120) & (y_pos > 9'd40) & (x_pos < 10'd280) & (y_pos < 9'd200));
  assign green_pix_o [3]  = ((x_pos > 10'd200) & (y_pos > 9'd120) & (x_pos < 10'd360) & (y_pos < 9'd280)) |
                            ((x_pos > 10'd360) & (y_pos > 9'd280) & (x_pos < 10'd520) & (y_pos < 9'd440));
  assign blue_pix_o [3]   = ((x_pos > 10'd280) & (y_pos > 9'd200) & (x_pos < 10'd440) & (y_pos < 9'd360));

  assign red_pix_o [2:0] = 3'h0;
  assign green_pix_o [2:0] = 3'h0;
  assign blue_pix_o [2:0] = 3'h0;

endmodule
