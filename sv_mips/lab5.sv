module lab5 (
  input   logic       clk,
  input   logic       SW0,
  input   logic       SW1,
  input   logic       KEY0,
  input   logic       KEY1,
  input   logic       KEY2,
  input   logic       KEY3,
  output  logic [6:0] HEX5,
  output  logic [6:0] HEX4,
  output  logic [6:0] HEX3,
  output  logic [6:0] HEX2,
  output  logic [6:0] HEX1,
  output  logic [6:0] HEX0,
  output  logic       LED0,
  output  logic       LED1,
  output  logic       LED2,
  output  logic       LED3,
  output  logic       LED4,
  output  logic       LED5,
  output  logic       LED6,
  output  logic       LED7
);

  logic s_clk;
  logic [2:0] keys;
  logic [7:0] msg [5:0];
  logic [7:0] hex_num; 
  logic [15:0] ascii_msg;
  logic [7:0] w_reg, pc, alu_out;
  logic [3:0] opcode;

  assign keys = {~KEY3, ~KEY2, ~KEY1};

  always_comb begin
    hex_num = 8'h0;
    case (keys)
      3'h0: begin
        msg[5] = "C"; msg[4] = "A"; msg[3] = "B"; msg[2] = "R";
        msg[1] = "E"; msg[0] = "R";
      end
      3'h6: begin
        hex_num = w_reg;
        msg[5] = "0"; msg[4] = "0"; msg[3] = "0"; msg[2] = "0";
        msg[1] = ascii_msg[15:8]; msg[0] = ascii_msg[7:0];
      end
      3'h5: begin
        hex_num = alu_out;
        msg[5] = "0"; msg[4] = "0"; msg[3] = "0"; msg[2] = "0";
        msg[1] = ascii_msg[15:8]; msg[0] = ascii_msg[7:0];
      end
      3'h3: begin
        hex_num = {4'h0, opcode};
        msg[5] = "0"; msg[4] = "0"; msg[3] = "0"; msg[2] = "0";
        msg[1] = "0"; msg[0] = ascii_msg[7:0];
      end
      3'h7: begin
        hex_num = pc;
        msg[5] = "0"; msg[4] = "0"; msg[3] = "0"; msg[2] = "0";
        msg[1] = ascii_msg[15:8]; msg[0] = ascii_msg[7:0];
      end
      default: begin
        msg[5] = " "; msg[4] = " "; msg[3] = " "; msg[2] = " ";
        msg[1] = " "; msg[0] = " ";
      end
    endcase
  end

  assign s_clk = (SW1)? KEY0: clk ;

  num2ascii A0 (hex_num[3:0], ascii_msg[7:0]);
  num2ascii A1 (hex_num[7:4], ascii_msg[15:8]);

  lab5s L0 (
    s_clk,
    SW0,
    SW1,
    KEY0,
    KEY1,
    KEY2,
    KEY3,
    opcode,
    pc,
    alu_out,
    w_reg,
    hex5,
    hex4,
    hex3,
    hex2,
    hex1,
    hex0,
    LED0,
    LED1,
    LED2,
    LED3,
    LED4,
    LED5,
    LED6,
    LED7
  );

    ASCII27Seg Hex0 (msg[0], HEX0);
    ASCII27Seg Hex1 (msg[1], HEX1);
    ASCII27Seg Hex2 (msg[2], HEX2);
    ASCII27Seg Hex3 (msg[3], HEX3);
    ASCII27Seg Hex4 (msg[4], HEX4);
    ASCII27Seg Hex5 (msg[5], HEX5);

endmodule
