// Control state machine

module control (
  input logic         clk,
  input logic         reset,
  output logic[3:0]   opcode,
  output logic[7:0]   pc,
  output logic[7:0]   alu_out,
  output logic[7:0]   rf_data_in
);

  `include "alu_params.sv"
  parameter [2:0] IF = 3'b000,
                  ID = 3'b001,
                  FD = 3'b010,
                  EX = 3'b011,
                  RWB = 3'b100,
                  HLT = 3'b101;

  logic [2:0] state, nxt_state;
  logic [7:0] nxt_pc;
  logic [15:0] instr_reg, nxt_instr_reg;
  logic [15:0] instr_data;
  logic [3:0] RA, RB, RD, nxt_opcode;
  logic [7:0] nxt_rf_data_in;
  logic [7:0] rf_outa, rf_outb;
  logic [7:0] alu_in_a, alu_in_b;
  logic [7:0] fetch_data_a, fetch_data_b;

  ROM instr_mem (pc, instr_data);
  reg_file RF (clk, reset, RA, RB, RD, opcode, 1'b1, state, rf_data_in, rf_outa, rf_outb);
  alu ALU (alu_in_a, alu_in_b, opcode, alu_out);

  always_ff @ (posedge clk or posedge reset)
  if (reset) begin
    state <= IF;
    pc <= 'h0;
    instr_reg <= 'h0;
    fetch_data_a <= 'h0;
    fetch_data_b <= 'h0;
    rf_data_in <= 'h0;
    opcode <= 'hFFFF;
  end
  else begin
    state <= nxt_state;
    pc <= nxt_pc;
    instr_reg <= nxt_instr_reg;
    fetch_data_a <= rf_outa;
    fetch_data_b <= rf_outb;
    rf_data_in <= nxt_rf_data_in;
    opcode <= nxt_opcode;
  end

  always_comb begin
    nxt_pc = pc;
    nxt_instr_reg = instr_reg;
    alu_in_a = 'h0;
    alu_in_b = 'h0;
    nxt_opcode = opcode;
    nxt_rf_data_in = rf_data_in;
    RA = 'h0; RB = 'h0; RD = 'h0;
    case (state)
      IF: begin
        nxt_state = ID;
        nxt_instr_reg = instr_data;
      end
      ID: begin
        nxt_state = FD;
        RA = instr_reg [11:8];
        RB = instr_reg [7:4];
        nxt_opcode = instr_reg [15:12];
      end
      FD: begin
        nxt_state = EX;
      end
      EX: begin
        nxt_state = RWB;
        nxt_pc = pc + 1'b1;
        alu_in_a = fetch_data_a;
        alu_in_b = fetch_data_b;
        nxt_rf_data_in = alu_out;
        RA = instr_reg [11:8];
        RB = instr_reg [7:4];
        RD = instr_reg [3:0];
        case (opcode)
          LDI:  begin
              alu_in_a = instr_reg [11:8];
              alu_in_b = instr_reg [7:4];
             end
          JMP:  begin
              nxt_pc = {instr_reg[11:8], instr_reg [7:4]};
             end
          CMPJ:  begin
              if (alu_out[0]) begin
                nxt_pc = pc + instr_reg [3:0];
              end
             end
          HALT:  begin
              nxt_pc = pc;
              nxt_state = HALT;
             end
        endcase
      end
      RWB: begin
        nxt_state = IF;
        RD = instr_reg [3:0];
      end
      HLT: begin
        nxt_state = HALT;
      end
      default: nxt_state = state;
    endcase
  end

endmodule
