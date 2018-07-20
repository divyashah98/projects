// Instruction memory ROM
module ROM (input [7:0] PC, output logic [15:0] data);

  logic [15:0] mem [20:0];

  assign mem [0] = 16'h1000;
  assign mem [1] = 16'h1011;
  assign mem [2] = 16'h1002;
  assign mem [3] = 16'h10a3;
  assign mem [4] = 16'he236;
  assign mem [5] = 16'h2014;
  assign mem [6] = 16'h3100;
  assign mem [7] = 16'h3401;
  assign mem [8] = 16'h7022;
  assign mem [9] = 16'hd040;
  assign mem [10] = 16'h3405;
  assign mem [11] = 16'h6536;
  assign mem [12] = 16'h5637;
  assign mem [13] = 16'h4578;
  assign mem [14] = 16'h3828;
  assign mem [15] = 16'h8089;
  assign mem [16] = 16'h809a;
  assign mem [17] = 16'hb89b;
  assign mem [18] = 16'ha9ac;
  assign mem [19] = 16'hc0cd;
  assign mem [20] = 16'h0000;

  assign data = mem [PC];

endmodule
