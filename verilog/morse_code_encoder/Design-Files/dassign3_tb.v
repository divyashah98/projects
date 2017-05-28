//--------------------------------------------------------------------
//		Timescale
//--------------------------------------------------------------------
`timescale 1ns / 1ps
`define TCLK 40
`define THCYC 20
`define STRLEN 13
//--------------------------------------------------------------------
//		Design Assignment Testbench.
// ***YOU MUST MAKE SURE THAT YOUR CODE RUNS WITH THIS TEST BENCH***
//                   ***WITHOUT ANY MODIFICATION***
// Note: You may however use this testbench as a starting point to create 
// your own tests for debugging
//--------------------------------------------------------------------
/*
 * Utility module to generate a clock signal
 */
module clkgen(output reg clock);

   // reg clock;

   always begin
      #`THCYC
	clock=~clock;
   end

   initial
     clock=1'b0;

endmodule // clkgen


module dassign3_tb();
//----------------------------------------------------------------
//		Parameters
//----------------------------------------------------------------
   
//----------------------------------------------------------------
//		Signal Declarations
//----------------------------------------------------------------
   wire       clock;
   reg 	      reset;

   wire       led_drv;
      
   wire [7:0] charcode_data;
   wire [3:0] charlen_data;

//----------------------------------------------------------------
//		Module Declaration
//----------------------------------------------------------------
   reg 			char_vald;
   wire 		char_next;

   clkgen clkgen0(clock);
   dassign3 DUT(char_vald, charcode_data, charlen_data,
		char_next, led_drv,
		reset, clock
		);

////////////////////////////////////////////////////////////////
//  Variable Declaration
////////////////////////////////////////////////////////////////
   
   reg [`STRLEN*8-1:0] 	dut_str;

 			
   reg [7:0] 		char;
   integer 		i, j, k;
 			
   reg [11:0] morse_mem[0:255];
   reg [11:0] morse_char;

   assign charcode_data[7:0] = morse_char[11:4];
   assign charlen_data[3:0] = morse_char[3:0];

   reg [3:0] 		kmax;

//
//----------------------------------------------------------------
//		Test Stimulus
//----------------------------------------------------------------
   initial begin
/*
 Dumping for display with epwave or gtkwave
 */
      $dumpfile("dassign3.vcd");
//      $dumpvars(0, DUT);
      $dumpvars(0);

      dut_str= "M16 TA FATIMA";
/*
 Reading the ascii-morse encoding table
 */
      $readmemb("./ascii_morse.txt", morse_mem);

      reset = 1'b1;
      #35
	char_vald = 1'b0;
      #`TCLK
	reset=1'b0;
      #`TCLK
      for(i=`STRLEN-1;i>=0;i=i-1) begin
      	 for(j=0;j<8;j=j+1) 
	    char[j] = dut_str[8*i+j];
	 morse_char = morse_mem[char];
	 char_vald = 1'b1;
	 #`TCLK
	 char_vald = 1'b0;
	 wait(char_next);
	 #(1.5*`TCLK)
	 $display("%s, %b, %b, %b",
		  char,morse_char,charlen_data,charcode_data);
      end // for (i=`STRLEN-1;i>=0;i=i-1)
      #(3*`TCLK)
      $finish;
   end // initial begin
   //
   //  Monitoring LED
   //
   integer led_cnt,cyc_cnt, sym_cnt;
   reg 	   led_sym, led_cnt_strt, sym_cnt_strt;
   reg [7:0] charcode_targ;
   reg [7:0] morse_seq;
   reg [3:0] charlen_targ;
 	   
   always @(posedge clock) begin
      if (char_vald) begin
	 sym_cnt = 0;
	 cyc_cnt = 0;
	 led_cnt = 0;
	 sym_cnt_strt = 1;
	 morse_seq = 8'b0000_0000;
	 charcode_targ = charcode_data;
	 charlen_targ = charlen_data;
      end
      if (sym_cnt_strt) begin //symbols counting
	 if (led_drv) begin //if LED then don't count blank cycles
	    led_cnt = led_cnt+1;
	    cyc_cnt = 0;
	 end
	 else begin
	    cyc_cnt = cyc_cnt+1; //when no LED: count blank cyc, and check count
	    if (led_cnt == 1) begin
	       $display("DOT detected");
	       morse_seq[7-sym_cnt] = 1'b0;
	       sym_cnt = sym_cnt+1;
	    end
	    else begin
	       if (led_cnt == 3) begin
		  $display("DASH detected");
		  morse_seq[7-sym_cnt] = 1'b1;
		  sym_cnt = sym_cnt+1;
	       end
	       else begin
		  $display("Blank detected (may be a fault)");
	       end
	    end // else: !if(led_drv)
	    led_cnt = 0; //blank the led count
	 end // else: !if(led_drv)
      end // if (sym_cnt_strt ==1)
   end // always @ (posedge clock)

   //
   // Hack to detect when to check if a character ends
   //
   always @(posedge char_next) begin 
      if (sym_cnt_strt) begin
//	 $display("sym: %b, symcnt:%b", morse_seq, sym_cnt);
	 if (cyc_cnt <= 3) begin
	    $display("Character Found:");
	    if (morse_seq == charcode_targ)
	      $display("\tMatch code: %b", morse_seq);
	    else 	   
	      $display("\tIncorrect Match to code: %b to: %b", morse_seq, charcode_targ);
	    if (sym_cnt == charlen_targ)
	      $display("\tMatch length: %b", sym_cnt);	   
	    else 	   
	      $display("\tIncorrect Match to length: %b to: %b", sym_cnt, charlen_targ);
	 end
         else begin
	   if ((cyc_cnt >=7) && (cyc_cnt<=12)) begin
	      $display("Space Found:");
	      if (charlen_targ == 4'b0000)
		$display("\tMatch space");
              else
	        $display("\tIncorrect Blanks");
	   end
	   else
	      $display("\tIncorrect Blanks");
	 end // else: !if(cyc_cnt <= 3)
	 sym_cnt_strt = 0;
      end // if (sym_cnt_strt == 1)
   end // always @ (posedge char_next)

endmodule // dassign3_tb


