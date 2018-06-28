// ALU Module

module alu (
  input   logic [7:0]  alu_a,
  input   logic [7:0]  alu_b,
  input   logic [3:0]  alu_opc,
  output  logic [7:0]  alu_out
);

`include "alu_params.sv"

  always_comb begin
    case (alu_opc)
      LDI:  begin
         end
      ADD:  begin
            alu_out = alu_a + alu_b;
         end
      ADI:  begin
            alu_out = alu_a + alu_b;
         end
      SUB:  begin
            alu_out = alu_a - alu_b;
         end
      Mul:  begin
            alu_out = alu_a * alu_b;
         end
      Div:  begin
            alu_out = div_out;
         end
      INC:  begin
            alu_out = alu_a + 'h1;
         end
      DEC:  begin
            alu_out = alu_a - 'h1;
         end
      NOR:  begin
            alu_out = ~(alu_a | alu_b);
         end
      NAND:  begin
            alu_out = ~(alu_a & alu_b);
         end
      XOR:  begin
            alu_out = alu_a ^ alu_b;
         end
      COMP:  begin
            alu_out = ~alu_b;
         end
      JMP:  begin
            alu_out = alu_a + alu_b;
         end
      CMPJ:  begin
            alu_out = {7'h0, (alu_a>=alu_b)};
         end
      NOP:  begin
            alu_out = alu_a;
         end
      HALT:  begin
            alu_out = alu_a;
            end
      default: alu_out = alu_a;
    endcase
  end

endmodule
