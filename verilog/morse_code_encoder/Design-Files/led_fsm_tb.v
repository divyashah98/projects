//		Timescale
//--------------------------------------------------------------------
`timescale 1ns / 1ps
`define TCLK 40
`define THCYC 20
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

   //reg clock;

   always begin
      #`THCYC
	clock=~clock;
   end

   initial
     clock=1'b0;

endmodule // clkgen


module led_fsm_tb();
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

   reg [11:0] morse_mem[0:255];
   reg [11:0] morse_char;

   assign charcode_data[7:0] = morse_char[11:4];
   assign charlen_data[3:0] = morse_char[3:0];

   reg [7:0] 		char;
   integer 		i, j, k;
   reg [3:0] 		kmax;
//
// Test led_fsm
//   
   reg 	      sym_strt;
   reg        sym;
 	      
   wire       sym_done;

          
//----------------------------------------------------------------
//		Module Declaration
//----------------------------------------------------------------
   clkgen clkgen0(clock);
   led_fsm ledfsm0(sym_strt, sym, led_drv, sym_done, reset, clock);

//
//----------------------------------------------------------------
//		Test Stimulus
//----------------------------------------------------------------
   reg char_strt;

   initial begin
/*
 Dumping for display with gtkwave
 */
      $dumpfile("led_fsm.vcd");
      $dumpvars(0, ledfsm0);
/*
 Reading the ascii-morse encoding table
 */
      $readmemb("./ascii_morse.txt", morse_mem);
/*
 Test led_fsm
 */
//      $display("sym_strt, sym, led_drv, sym_done, clock");
//      $monitor("%b \t %b \t %b \t %b \t %b", 
//	       sym_strt, sym, led_drv, sym_done, clock);
      reset = 1'b1;
      #35
      sym_strt = 1'b0;
      char = "L"; //pick a letter to test
      morse_char = morse_mem[char];
      sym = 1'b0;
      #(2*`TCLK)
      $display("%s, %b, %b, %b",char,morse_char,charlen_data,charcode_data);    
      reset = 1'b0;
      #`TCLK	 
      kmax = charlen_data;
      char_strt = 1'b1;
      for(k=0;k<kmax;k=k+1) begin
	 sym = charcode_data[7-k];
	 $display("k:%b %b, %b",k, charcode_data, sym);
	 #1
	 sym_strt = 1'b1;
	 #`TCLK
	   sym_strt = 1'b0;
	 wait(sym_done);
	 #`TCLK
	   $display("finished symbol: %b ",sym);
      end
      char_strt = 1'b0;
      
      $finish;
   end // initial begin
// 
// Optional short test 
//
   /*
    initial begin
      reset = 1'b1;
      sym = 1'b1;
      sym_strt = 1'b0;
      #30
      reset = 1'b0;
      #(2*`TCLK)
	sym_strt = 1'b1;
      #`TCLK 
	sym_strt = 1'b0;
      #(5*`TCLK)
	sym_strt = 1'b1;
      sym = 1'b0;
      #`TCLK
	sym_strt = 1'b0;
      #(5*`TCLK)
      $finish;
   end
    */
   //
   //  Monitoring LED
   //
   integer led_cnt, blank_cnt;
   reg 	   led_sym, led_cnt_strt;
   
   always @(posedge clock) begin
      if (sym_strt) begin
	 led_cnt = 0;
	 led_cnt_strt = 1;
         led_sym = sym;
      end
      if (sym_done) begin
	$display("sym:%b, led_cnt:%b", led_sym, led_cnt);
	 led_cnt_strt = 0;
	if (led_cnt==1 && led_sym==0)
	  $display("Correct - DOT");
        else 
	  if (led_cnt==3 && led_sym==1)
	    $display("Correct - DASH");
          else
	    $display("Incorrect");
      end
      if (led_drv) begin
	 if (led_cnt_strt ==1)
	   led_cnt = led_cnt+1;
         if (char_strt == 1)
	   if (blank_cnt>1) 
	    $display("Incorrect - LED off for 2 or more cycles during symbol");
	   blank_cnt = 0;	    
      end
      else begin
         if (led_cnt_strt ==1) 
	    $display("Incorrect - LED off during DASH");
         if (char_strt == 1)
	   blank_cnt = blank_cnt+1;
      end
   end
endmodule

