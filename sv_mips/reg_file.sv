module reg_file (input clk, input [3:0] RA, input [3:0] RB, input [3:0] RD, input [3:0]
                 OPCODE, input opcode, input [2:0] current_state, input [7:0] RF_data_in,
                 output logic [7:0] RF_data_out0, output logic [7:0] RF_data_out1);

  localparam One = 8'd1, Zero = 8'd0, one = 1'b1, zero = 1'b0;

  logic [4:0] i;
  logic [7:0] RF [15:0];
  parameter EX = 3'b011;
  parameter RWB = 3'b100;

  always_ff @ (posedge clk or posedge reset) begin
    i = 5'd0;
    if (reset) begin
      RF_data_out0 <= Zero;
      RF_data_out1 <= Zero;
      for (i = 5'd0; i < 5'd16; i = i +5'd1) RF[i] = Zero;
    end
    else begin
      RF_data_out0 <= RF[RA];
      RF_data_out1 <= RF[RB];
      if ((current_state == RWB) && ~((OPCODE == 4'd11) || ((OPCODE == 4'd12) ||
          ((OPCODE == 4'd15)) )) begin
        RF[RD] <= RF_data_in;
      end
    end
  end

endmodule
