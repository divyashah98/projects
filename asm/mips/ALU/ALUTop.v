// ---------------------- ALU TOP -----------------------------------
`include "instr_defines.v"

module ALUTop
    (
        input  wire [2:0]      instr_i,
        input  wire [31:0]      in1_i,
        input  wire [31:0]      in2_i,
        output wire [63:0]      ALUOut_o
    );

    wire [2:0]  alu_op;
    wire [31:0] aluOut;
    wire [63:0] aluOutMD;
    wire        isDivMul;

    assign isDivMul = ((alu_op == `MUL) || (alu_op == `DIV));
    // Instantiate the ALU Control
    ALUControl CTRL (
        .instr_op_i (instr_i),
        .alu_op_o (alu_op)
    );
    // Instantiate the ALU Datapath
    ALUDataPath DP (
        .in1(in1_i),
        .in2(in2_i),
        .ALUOp (alu_op),
        .ALUOut (aluOut),
        .ALUMDOut (aluOutMD)
    );

    assign ALUOut_o = (isDivMul) ? aluOutMD : {32'h0, aluOut};

endmodule
