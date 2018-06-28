module imem #(
   parameter Nloc  =  32,                     // Number of memory locations
   parameter Dbits = 32,                      // Number of bits in data
   parameter Abits = 32,                      // Number of bits in address
   parameter initfile = "sqr_imem.txt"        // Name of file with initial values
)(
   input wire [31:0] pc,
   output logic [31:0] instr

 );

   logic [(Abits)-1:0] i_mem [Nloc-1:0];
   initial $readmemh(initfile, i_mem, 0, 19);  // Instructions to initialize the IMEM

   always_comb
   instr = i_mem[pc >> 2 ];

endmodule
