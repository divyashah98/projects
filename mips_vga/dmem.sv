module dmem #(
   parameter Nloc  = 32,                      // Number of memory locations
   parameter Dbits = 32,                      // Number of bits in data
   parameter Abits = 32,                      // Number of bits in address
   parameter initfile = "dmem.txt"        // Name of file with initial values
)(
    input wire clk, 
    input wire mem_wr, 
    input wire [31:0] mem_addr,
    input wire [31:0] mem_writedata, 
    output logic [31:0] mem_readdata
  );

   logic [Dbits-1:0] d_mem [16383:0];
   initial $readmemh(initfile, d_mem, 0, 16383);  // Data to initialize the DMEM

   always_ff @(posedge clk)                   // Memory write: only when mem_wr==1, and only at posedge clock
      if(mem_wr)
         d_mem[(mem_addr)] <= mem_writedata;

   always_comb
     if (mem_wr == 0)                             // Memory read: only when mem_wr==0 
     begin
        assign mem_readdata = d_mem[(mem_addr)];    // Update mem_readdata with the value stored in dmem
     end
   
endmodule
