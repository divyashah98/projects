`timescale 1ns/1ps

module lab5_tb ();

  logic clk, reset;
  logic       SW1;
  logic       KEY0;
  logic       KEY1;
  logic       KEY2;
  logic       KEY3;
  logic [3:0] OPCODE;
  logic [7:0] PC;
  logic [7:0] alu_out;
  logic [7:0] W_REG;
  logic [6:0] HEX5;
  logic [6:0] HEX4;
  logic [6:0] HEX3;
  logic [6:0] HEX2;
  logic [6:0] HEX1;
  logic [6:0] HEX0;
  logic       LED0;
  logic       LED1;
  logic       LED2;
  logic       LED3;
  logic       LED4;
  logic       LED5;
  logic       LED6;
  logic       LED7;

  lab5s MCU (
    clk,
    reset,
    SW1,
    KEY0,
    KEY1,
    KEY2,
    KEY3,
    OPCODE,
    PC,
    alu_out,
    W_REG,
    HEX5,
    HEX4,
    HEX3,
    HEX2,
    HEX1,
    HEX0,
    LED0,
    LED1,
    LED2,
    LED3,
    LED4,
    LED5,
    LED6,
    LED7
  );

  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end

  initial begin
    SW1 = 0;
    KEY0 = 0;
    KEY1 = 0;
    KEY2 = 0;
    KEY3 = 0;
    reset = 1'b1;
    @ (posedge clk);
    reset = 1'b0;
  end

  always @(posedge clk) begin
    if (MCU.C0.state == 3'b011) begin
      $display ("%x,\t%x,\t%x,\t%x,\t%x,\t%x,\t%x,\t%x,\t%x", MCU.C0.pc, MCU.C0.instr_reg, MCU.C0.opcode, MCU.C0.RA, MCU.C0.RB, MCU.C0.RD, MCU.C0.alu_in_a, MCU.C0.alu_in_b, MCU.C0.RF.RF[MCU.C0.RD]);
    end
    if (MCU.OPCODE == 'b0000) begin
      repeat (6) @(posedge clk);
      $finish();
    end
  end

endmodule
