////////////////////////////////////////////////////////////////
//  module LED FSM 
////////////////////////////////////////////////////////////////
module led_fsm(
	       input  sym_strt, symbol,
	       output reg led_drv, sym_done,
	       input  reset, clock
	       );
////////////////////////////////////////////////////////////////
//  parameter declarations
////////////////////////////////////////////////////////////////
   parameter START  = 3'b000;
   //declare each state name as a parameter
   parameter DASH0  = 3'b001;
   parameter DASH1  = 3'b010;
   parameter DASH2  = 3'b011;
   parameter DOT0   = 3'b100;

   reg [2:0]  led_nx_st;
////////////////////////////////////////////////////////////////
//  State register for FSM
////////////////////////////////////////////////////////////////
   reg [2:0] 	     led_st;
 
   always @(posedge clock) begin
      led_st <= led_nx_st;
   end


////////////////////////////////////////////////////////////////
//  State and Output logic for statemachine
////////////////////////////////////////////////////////////////
   //reg 	      led_drv, sym_done; //outputs you need to generate
   
   always @(*) begin
      if (reset) begin
	 //
	 // your code here
	 //
        led_nx_st= START;
        led_drv     = 1'b0;
        sym_done    = 1'b0;
      end
      else begin
	    case (led_st)
	      START: begin
	        //
	        // Your code here
	        //
            if (sym_strt)
            begin
               led_nx_st= symbol ? DASH0 : DOT0;
               led_drv     = 1'b1;
               sym_done    = 1'b0;
            end
            else
            begin
               led_nx_st= START;
               led_drv     = 1'b0;
               sym_done    = 1'b0;
            end
	      end // case: START
	      //
	      // Your code here for each of the other states
	      //
	      DASH0: begin
            led_drv     = 1'b1;
            sym_done    = 1'b0;
            led_nx_st   = DASH1;
	      end // case: DASH0
	      DASH1: begin
            led_drv     = 1'b1;
            sym_done    = 1'b0;
            led_nx_st   = DASH2;
	      end // case: DASH1
	      DASH2: begin
            led_drv     = 1'b0;
            sym_done    = 1'b1;
            led_nx_st   = START;
	      end // case: DASH2
	      DOT0: begin
            led_drv     = 1'b0;
            sym_done    = 1'b1;
            led_nx_st   = START;
	      end // case: DASH2
	      default: begin
            led_drv     = 1'bx;
            sym_done    = 1'bx;
            led_nx_st   = START;
	      end
	    endcase // case (led_st)
      end // else: !if(reset)
   end // always @ (*)
endmodule // led_fsm
