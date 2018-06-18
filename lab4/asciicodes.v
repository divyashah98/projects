module ASCIICodes
  (
    input   wire [2:0]  state,
    output  wire [6:0]  HexSeg0,
    output  wire [6:0]  HexSeg1,
    output  wire [6:0]  HexSeg2,
    output  wire [6:0]  HexSeg3
  );

  reg [7:0] Message [3:0];

  always @ (state) begin
    Message[3] = "C"; Message[2] = "A"; Message[1] = "B"; Message[0] = "R";
    case (state)
        3'b000: begin
                Message[3] = "C"; Message[2] = "A"; Message[1] = "B"; Message[0] = "R";
            end
        3'b001: begin
                Message[3] = "S"; Message[2] = "_"; Message[1] = "0"; Message[0] = "1";
            end
        3'b010: begin
                Message[3] = "S"; Message[2] = "_"; Message[1] = "0"; Message[0] = "2";
            end
        3'b011: begin
                Message[3] = "S"; Message[2] = "_"; Message[1] = "0"; Message[0] = "3";
            end
        3'b100: begin
                Message[3] = "S"; Message[2] = "_"; Message[1] = "0"; Message[0] = "4";
            end
    endcase
  end

    ASCII27Seg SevH0 (Message[0], HexSeg0);
    ASCII27Seg SevH1 (Message[1], HexSeg1);
    ASCII27Seg SevH2 (Message[2], HexSeg2);
    ASCII27Seg SevH3 (Message[3], HexSeg3);

endmodule
