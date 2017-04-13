// ---------------------- ALU TESTBENCH-----------------------------------

module ALUTb ();
    reg  [2:0]   instr_tb;
    reg  [31:0]  in1_tb;
    reg  [31:0]  in2_tb;
    wire [63:0]  aluOut_tb;

    ALUTop ALU (
        .instr_i (instr_tb),
        .in1_i (in1_tb),
        .in2_i (in2_tb),
        .ALUOut_o (aluOut_tb)
    );

    initial
    begin
        instr_tb = 3'h0;
        in1_tb = 32'h0;
        in2_tb = 32'h0;
    end

    always
    begin
        # (10);
        instr_tb = 3'h1;
        in1_tb = 32'h3;
        in2_tb = 32'h2;
        # (10);
        instr_tb = 3'h2;
        in1_tb = 32'h3;
        in2_tb = 32'h2;
        # (10);
        instr_tb = 3'h3;
        in1_tb = 32'h4;
        in2_tb = 32'h2;
        # (10);
        instr_tb = 3'h4;
        in1_tb = 32'h4;
        in2_tb = 32'h5;
        # (10);
        instr_tb = 3'h5;
        in1_tb = 32'h5;
        in2_tb = 32'h6;
        # (10);
        instr_tb = 3'h6;
        in1_tb = 32'h6;
        in2_tb = 32'h7;
        # (10);
        instr_tb = 3'h7;
        in1_tb = 32'h7;
        in2_tb = 32'h8;
        # (10);
        instr_tb = 3'h0;
        in1_tb = 32'ha;
        in2_tb = 32'ha;
        $finish;
    end

endmodule
