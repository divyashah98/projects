//		Timescale
//--------------------------------------------------------------------
`timescale 1ns / 1ps
`define TCLK 40
`define THCYC 20
`define STRLEN 11
//--------------------------------------------------------------------
//		Design Assignment Testbench for Module Code_Reg
// ***YOU MUST MAKE SURE THAT YOUR CODE RUNS WITH THIS TEST BENCH***
//                   ***WITHOUT ANY MODIFICATION***
// Note: You may however use this testbench as a starting point to create 
// your own tests for debugging
//--------------------------------------------------------------------
/*
 * Utility module to generate a clock signal
 */
module clkgen(output reg clock);

   //reg clock;

   always begin
      #`THCYC
	clock=~clock;
   end

   initial
     clock=1'b0;

endmodule // clkgen


module code_reg_tb();
//----------------------------------------------------------------
//		Parameters
//----------------------------------------------------------------
   parameter charL = 8'h4C;
   
//----------------------------------------------------------------
//		Signal Declarations
//----------------------------------------------------------------
   wire [7:0] charcode_data;
   wire [3:0] charlen_data;
   wire       clock;

   reg 	      reset;

//
// Test code_reg
//
   reg 	      char_load;
   reg 	      shft_cnt;
   wire [3:0] cntr_data;
   wire       shft_data;
          
//----------------------------------------------------------------
//		Module Declaration
//----------------------------------------------------------------
   clkgen clkgen0(clock);
   code_reg codereg0(charcode_data, charlen_data, char_load, 
		     shft_cnt, cntr_data, shft_data, reset, clock);
   
//
//----------------------------------------------------------------
//		Test Stimulus
//----------------------------------------------------------------
   reg [11:0] morse_mem[0:255];
   reg [11:0] morse_char;

   reg [`STRLEN*8-1:0] 	dut_str;

   assign charcode_data[7:0] = morse_char[11:4];
   assign charlen_data[3:0] = morse_char[3:0];

   reg [7:0] 		char;
   integer 		i, j, k;
   reg [3:0] 		kmax;
 		
   initial begin
/*
  Dumping for display with epwave or gtkwave
*/
      $dumpfile("code_reg.vcd");
      $dumpvars(0, codereg0);
/*
  Reading the ascii-morse encoding table
*/
      $readmemb("./ascii_morse.txt", morse_mem);
/*
  Test codereg0
*/
/*
  Monitoring outputs
*/
//      $display("char_load, shft_cnt, cntr_data, shft_data, clock");
//      $monitor("%b \t %b \t %b \t %b \t %b", char_load, shft_cnt, cntr_data, shft_data, clock);
      dut_str= "HELLO WORLD";
      reset = 1'b1;
      shft_cnt=1'b0;
      char_load=1'b0;
      #(2.75*`TCLK)    
      reset = 1'b0;
      #`TCLK    
      for(i=`STRLEN-1;i>=0;i=i-1) begin
	 for(j=0;j<8;j=j+1) 
	    char[j] = dut_str[8*i+j];
	 morse_char = morse_mem[char];
	 char_load = 1'b1;
	 shft_cnt = 1'b0;
	 #`TCLK
	 $display("%s, %b, %b, %b", char, char, morse_char, cntr_data);
	 kmax = cntr_data;
	 if ((charlen_data == 4'b0000) || (cntr_data == charlen_data))
	   $display("Correct length of data loaded");
	 else
	   $display("Incorrect length of data loaded");	   
 	 char_load = 1'b0;
	 for(k=0;k<kmax;k=k+1) begin
//	    $display("%d, %b, %b, %b",k,charcode_data,cntr_data, shft_data);
	    if (shft_data == charcode_data[7-k])
	      $display("Char: %s Test #%b: match ok with %b",
		       char, k, charcode_data[7-k]);
	    else 
	      $display("Char: %s Test #%b: match failed with %b",
		       char, k, charcode_data[7-k]);
	    shft_cnt = 1'b1;
	    #`TCLK
	      shft_cnt = 1'b0;
	 end // for (k=0;k<kmax;k=k+1)
	 if (cntr_data == 4'b0000)
	   $display("Correct final cntr data");
	 else
	   $display("Incorrect final cntr data: %b", cntr_data);
      end // for (i=`STRLEN-1;i>=0;i=i-1)
      $finish;
   end
endmodule 

