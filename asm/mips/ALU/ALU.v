// ---------------------- ALU DATAPATH -----------------------------------

module ALUDataPath (
    input wire [31:0] in1, 
    input wire [31:0] in2, 
    input wire [2:0] ALUOp, 
    output reg [31:0] ALUOut,
    output reg [63:0] ALUMDOut
);
    // Do the operation based on the 
    // ALUop value passed as input
    // from the control circuit
	always@(in1 or in2 or ALUOp)
		case(ALUOp)
			3'b000:	// ADD
                begin
                    ALUOut   = in1+in2;	
                    ALUMDOut = 64'h0;
                end
			3'b001:	// SUB
                begin
                    ALUOut   = in1-in2;
                    ALUMDOut = 64'h0;
                end
			3'b010:	// MUL
                begin
                    ALUOut   = 32'h0;
                    ALUMDOut =in1*in2;	
                end
			3'b011:	// DIV
                begin
                    ALUOut   = 32'h0;
                    ALUMDOut = in1/in2;
                end
			3'b100:	// LOAD
                begin
                    ALUOut   = in1+in2;	
                    ALUMDOut = 64'h0;
                end
			3'b101:	// STORE
                begin
                    ALUOut   = in1+in2;	
                    ALUMDOut = 64'h0;
                end
			3'b110:	// BRANCH
                begin
                    ALUOut   = in1-in2;
                    ALUMDOut = 64'h0;
                end
			3'b111:	// JUMP
                begin
                    ALUOut   = in1+in2;
                    ALUMDOut = 64'h0;
                end
		endcase
endmodule


