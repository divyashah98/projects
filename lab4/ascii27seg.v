//
// ascii to 7segment display conversion
//
module ASCII27Seg
  (
    input   wire [7:0] AsciiCode,
    output  reg  [6:0] HexSeg
  );

  always @(*)
  begin
    HexSeg = 7'd0;
    $display ("AsciiCode %b", AsciiCode);
    case (AsciiCode)
      // A, a
      8'h41, 8'h61 : HexSeg[3] = 1;
      // B, b
      8'h42, 8'h62 : begin
          HexSeg[0] = 1; HexSeg[1] = 1;
        end
      // C, c
      8'h43, 8'h63 : begin
          HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[6] = 1;
        end
      // D, d
      8'h44, 8'h64 : begin
          HexSeg[0] = 1; HexSeg[5] = 1;
        end
      // E, e
      8'h45, 8'h65 : begin
          HexSeg[1] = 1; HexSeg[2] = 1;
        end
      // F, f
      8'h46, 8'h66 : begin
          HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[3] = 1;
        end
      // G, g
      8'h47, 8'h67 : begin
          HexSeg[4] = 1;
        end
      // H, h
      8'h48, 8'h68 : begin
          HexSeg[0] = 1; HexSeg[3] = 1;
        end
      // I, i
      8'h49, 8'h69 : begin
          HexSeg[0] = 1; HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[3] = 1; HexSeg[6] = 1;
        end
      // J, j
      8'h4a, 8'h6a : begin
          HexSeg[0] = 1; HexSeg[5] = 1; HexSeg[6] = 1;
        end
      // K, k
      8'h4b, 8'h6b : begin
          HexSeg[0] = 1; HexSeg[3] = 1;
        end
      // L, l
      8'h4c, 8'h6c : begin
          HexSeg[0] = 1; HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[6] = 1;
        end
      // M, m
      8'h4d, 8'h6d : begin
          HexSeg[1] = 1; HexSeg[5] = 1; HexSeg[6] = 1; HexSeg[3] = 1;
        end
      // N, n
      8'h4e, 8'h6e : begin
          HexSeg[0] = 1; HexSeg[1] = 1; HexSeg[5] = 1; HexSeg[6] = 1; HexSeg[3] = 1;
        end
      // O, o
      8'h4f, 8'h6f : begin
          HexSeg[6] = 1;
        end
      // P, p
      8'h50, 8'h70 : begin
          HexSeg[2] = 1; HexSeg[3] = 1;
        end
      // Q, q
      8'h51, 8'h71 : begin
          HexSeg[3] = 1; HexSeg[4] = 1;
        end
      // R, r
      8'h52, 8'h72 : begin
          HexSeg[0] = 1; HexSeg[1] = 1; HexSeg[5] = 1; HexSeg[2] = 1; HexSeg[3] = 1;
        end
      // S, s
      8'h53, 8'h73 : begin
          HexSeg[1] = 1; HexSeg[4] = 1;
        end
      // T, t
      8'h54, 8'h74 : begin
          HexSeg[0] = 1; HexSeg[1] = 1; HexSeg[2] = 1;
        end
      // U, u
      8'h55, 8'h75 : begin
          HexSeg[0] = 1; HexSeg[6] = 1;
        end
      // V, v
      8'h56, 8'h76 : begin
          HexSeg[0] = 1; HexSeg[1] = 1; HexSeg[5] = 1; HexSeg[6] = 1;
        end
      // W, w
      8'h57, 8'h77 : begin
          HexSeg[0] = 1; HexSeg[6] = 1; HexSeg[4] = 1; HexSeg[2] = 1;
        end
      // X, x
      8'h58, 8'h78 : begin
          HexSeg[0] = 1; HexSeg[3] = 1;
        end
      // Y, y
      8'h59, 8'h79 : begin
          HexSeg[0] = 1; HexSeg[4] = 1;
        end
      // Z, z
      8'h5a, 8'h7a : begin
          HexSeg[2] = 1; HexSeg[5] = 1;
        end
      // 0
      8'h30 : begin
          HexSeg[6] = 1;
        end
      // 1
      8'h31 : begin
          HexSeg[0] = 1; HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[3] = 1; HexSeg[6] = 1;
        end
      // 2
      8'h32 : begin
          HexSeg[2] = 1; HexSeg[5] = 1;
        end
      // 3
      8'h33 : begin
          HexSeg[4] = 1; HexSeg[5] = 1;
        end
      // 4
      8'h34 : begin
          HexSeg[0] = 1; HexSeg[3] = 1; HexSeg[4] = 1;
        end
      // 5
      8'h35 : begin
          HexSeg[1] = 1; HexSeg[4] = 1;
        end
      // 6
      8'h36 : begin
          HexSeg[1] = 1;
        end
      // 7
      8'h37 : begin
          HexSeg[3] = 1; HexSeg[4] = 1; HexSeg[5] = 1; HexSeg[6] = 1;
        end
      // 8
      8'h38 : begin
        end
      // 9
      8'h39 : begin
          HexSeg[4] = 1;
        end
      // _
      8'h5F : begin
          HexSeg[0] = 1; HexSeg[1] = 1; HexSeg[2] = 1; HexSeg[4] = 1; HexSeg[6] = 1; HexSeg[5] = 1;
        end
      // turn all the bits off by default  
      default : HexSeg = 7'b1111111;
    endcase
  end

endmodule
