// ---------------------- ALU CONTROL -----------------------------------
`include "instr_defines.v"

module ALUControl
    (
        input   wire[2:0]   instr_op_i,
        output  wire[2:0]    alu_op_o
    );

    reg  [2:0]  alu_op;
    wire [2:0]  instr_funct;

    assign  alu_op_o    = alu_op;

    always @ *
    begin
      case (instr_op_i)
            `ADD    :   alu_op = 3'b000;
            `SUB    :   alu_op = 3'b001;
            `MUL    :   alu_op = 3'b010;
            `DIV    :   alu_op = 3'b011;
            `LW     :   alu_op = 3'b100;
            `SW     :   alu_op = 3'b101;
            `BR     :   alu_op = 3'b110;
            `J      :   alu_op = 3'b111;
            default :   alu_op = 3'b000;
      endcase
    end

endmodule
