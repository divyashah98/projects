//Top level module

module lab5s (
  input   logic       SW0,
  input   logic       SW1,
  input   logic       KEY0,
  input   logic       KEY1,
  input   logic       KEY2,
  input   logic       KEY3,
  output  logic [3:0] OPCODE,
  output  logic [7:0] PC,
  output  logic [7:0] alu_out,
  output  logic [7:0] W_REG,
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

endmodule
