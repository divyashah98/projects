`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:30:51 04/06/2017 
// Design Name: 
// Module Name:    Waveform2 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Waveform2(
	input wire         clk,        //1 MHz
	input wire         reset,      //Active low Reset
	input wire         start_f,
	input wire [8:0]   ktp,	      // Weite kathodischer Puls
	input wire [5:0]   sktp,	   // Strom kathodischer puls
	input wire [6:0]   ipd,       // Weite ipd
	input wire [8:0]   adp,      // Weite anodischer Puls
	input wire [5:0]   sadp,     // Strom anodischer Puls
	input wire [3:0]   amp1, 
	input wire [3:0]   amp2,
	input wire [3:0]   amp3,
	input wire [3:0]   amp4,
	input wire [9:0]   period,
	
	output reg  [3:0]  amp_dout1,
	output reg  [3:0]  amp_dout2,
	output wire        done_f,
	output wire [5:0]  src,
	output wire [5:0]  sink
	
);

    //Quantisierung der Parameter
    parameter STATE_WAIT = 0;
    parameter STATE_KATH_START = 1;
    parameter STATE_KATH_CNT = 2;                                                                                                                                                                                                                                                                                                                                                                                              
    parameter STATE_IPD_START = 3;
    parameter STATE_IPD_CNT = 4;
    parameter STATE_ANO_START = 5;
    parameter STATE_ANO_CNT = 6;
    parameter STATE_DONE = 7;
    //Parameter der Elektroden
    parameter STATE_ELKT0 = 0;
    parameter STATE_ELKT1 = 1;                 
    parameter STATE_ELKT2 = 2;
    parameter STATE_ELKT3 = 3;
    
    
    	//...
    reg [11:0] count;  
    reg [3:0]  state,
               next_state;
    			  
    //Periode			 	 
    reg per_reset; 
    reg per_load;
    reg per_done;	 

    reg [1:0] per_state;
    reg [1:0] per_nstate;
    reg [9:0] per_count;	
    
    
    //Mux 			 
    reg [3:0] adw1;
    reg [3:0] adw2;
            			 
    	 	
    
    //FSM
    always @ (posedge clk or negedge reset)
    if(!reset) begin
    	state = STATE_WAIT;
    	count=0;
    end else begin 
    	case(state)
    	
        STATE_WAIT:
    	begin
    		count=0;
    		if( start_f==1) begin
    			state = STATE_KATH_START;
    		end else begin
    			next_state = STATE_WAIT;
    		end	
    	end
    
        STATE_KATH_START: 
      	begin
    		state = STATE_KATH_CNT;
    		count= ktp;
    	end
    	
    	STATE_KATH_CNT:
    	begin
    		count =count-1;
    	   if( count==0) begin
    			state = STATE_IPD_START;
    		end else begin
    			next_state = STATE_KATH_CNT;
    		end
    	end
    	
    	STATE_IPD_START:
    	begin
    		state = STATE_IPD_CNT;
    		count= ipd;
    	end
    	
    	STATE_IPD_CNT:
    	begin
    		count =count-1;
    	   if( count==0) begin
    			state = STATE_ANO_START;	
    		end else begin
    			next_state = STATE_IPD_CNT;
    		end
    	end
    	
    	STATE_ANO_START:
    	begin
    		state = STATE_ANO_CNT;
    		count = adp;
    	end
    	
    	STATE_ANO_CNT:
    	begin
    		count =count-1;
    	   if( count==0) begin
    			state = STATE_DONE;
    		end else begin
    			next_state = STATE_ANO_CNT;
    		end
    	end
    	
    	STATE_DONE:
    	begin
    		state = STATE_WAIT;
    	end
    endcase
    end //FSM
    
    assign done_f = (state == STATE_DONE);
    assign sink   = (state == STATE_KATH_CNT) ? sktp : 0;
    assign src    = ((state==STATE_ANO_START) | (state==STATE_ANO_CNT)) ? sadp : 0;
    
    //Period
    always @ (posedge clk or negedge per_reset)
          if(~per_reset)
              per_count <= 10'b0000000000;
    	  else
    	  if(~per_load)
    	      per_count <= period;
          else		  
              per_count<= per_count-1;
    		  
    always @ (posedge clk or negedge per_reset)
          if( ~per_reset)
              per_state<= STATE_ELKT0;
    	  else 
    		  per_state<= per_nstate;
    		
    always @ (per_state or per_count or per_load)
      case(per_state)
    	 STATE_ELKT1: 
         begin
            if(~per_load)
              	per_nstate =STATE_ELKT2;
    	    else
      	        per_nstate = STATE_ELKT1;
    	 end
    	  
    	 STATE_ELKT2: 
         begin
    	    if(per_count==10'b0000000000)
                per_nstate= STATE_ELKT3;
            else 
    	        per_nstate = STATE_ELKT2;
         end
    	 
         STATE_ELKT3: 
         begin
            if( ~per_load)	  
    	        per_nstate = STATE_ELKT2;
    	    else
                per_nstate= STATE_ELKT3;
         end
      endcase

    always @ (posedge clk or negedge per_reset)
        if(~per_reset)
             per_done <= 0;
        else			
        case( per_nstate)
    	    STATE_ELKT3: per_done <= 1;
    	endcase                       //Period
    		
//4-Bit ADW
    always @ (sktp)
        case(sktp)
              STATE_ELKT0    : adw1= 4'b0001;
    		  STATE_ELKT1    : adw1= 4'b0010; 
    		  STATE_ELKT2    : adw1= 4'b0100;
    		  STATE_ELKT3    : adw1= 4'b1000;
    		  default        : adw1= 4'b0000;
    	endcase
    		  
    always @ (sadp) 
        case(sadp) 
              STATE_ELKT0   : adw2= 4'b0001;
    		  STATE_ELKT1   : adw2= 4'b0010; 
    		  STATE_ELKT2   : adw2= 4'b0100;
    		  STATE_ELKT3   : adw2= 4'b1000;
              default       : adw2= 4'b0000; 		  
    	endcase                //4-Bit ADW
    	
    
    always @ (posedge clk or negedge reset)
    if( !reset) begin  
	// if( !clk)   begin	
		 adw1<= 4'b0000;
         adw2<= 0;
		 amp_dout1<=4'b0000;
		 amp_dout2<=4'b0000;
		 per_reset<= 0;
		 per_load<=1;
	end 
	else 
	    case(next_state)
		    STATE_WAIT: 
            begin
		       adw1<= 4'b0000;
               adw2<= 4'b0000;
		       amp_dout1<=4'b0000;
		       amp_dout2<=4'b0000;
		       per_reset<= 0;
		       per_load<=1;
            end
            STATE_KATH_START: 
            begin
               adw1<=4'b0000;
               if( start_f==STATE_KATH_START)
                   adw2<= 1;
               else
                   adw2<= 0;
               if(( start_f == STATE_KATH_START) | ( start_f == STATE_KATH_CNT)|( start_f == STATE_IPD_START)| ( start_f == STATE_IPD_CNT))
                   adw1<= sktp;
               else
	               adw1<= 4'b0000;
                   adw2<= 4'b0000;
                   amp_dout1<= amp1;
                   amp_dout2<=amp3;		 
                   per_reset<= 1;
                   per_load<=0;
	        end
		    STATE_KATH_CNT:  
            begin 
		        adw1<=start_f;
                if (start_f == STATE_KATH_CNT) 
                      adw2<= 1;
                else
                      adw2<=0;
                if((start_f==STATE_KATH_START) | ( start_f == STATE_KATH_CNT)|( start_f == STATE_IPD_START))
                      adw1<= sktp;
                else
                      adw1<= 4'b0000;
                if( start_f == STATE_KATH_CNT)
                      adw2<= sadp;
                else
	                  adw2<= 4'b0000;
	                  amp_dout1<= amp1;	
                      amp_dout2<= amp2;		  
	                  per_reset<= 1;
	                  per_load<=1;
            end
		    STATE_IPD_START: 
            begin
                       adw1<= start_f;
                       if((start_f==STATE_WAIT)|( start_f == STATE_IPD_START)| ( start_f == STATE_IPD_CNT))
                          adw2<= 1;
                       else
                          adw2<=0;
                       if((start_f==STATE_KATH_START) | ( start_f == STATE_KATH_CNT)|( start_f == STATE_IPD_START))
                          adw1<=sktp;
                       else
                          adw1<= 4'b0000;
                       if( start_f == STATE_IPD_START)	  
                          adw2<=sadp;
                       else  
                          adw2<= 4'b0000;
                       if(( start_f == STATE_IPD_START)|( start_f == STATE_IPD_CNT))
                          adw1<= sktp;
                       else
                          adw1<= 4'b0000;
                       if(( start_f == STATE_IPD_START)|( start_f == STATE_IPD_CNT))	 
                          amp_dout1<=4'b0001;
                       else
                          amp_dout1<=4'b0000;		
                          amp_dout2<= 4'b0000;		  
                          per_reset<= 1;
                          per_load<=1;
            end
            STATE_IPD_CNT : 
            begin
                           adw1<= start_f;
                           if( start_f == STATE_IPD_CNT)	  
                              adw2<=1;
                           else
                              adw2<=0;		
                           if((start_f==STATE_WAIT)|( start_f == STATE_IPD_START)| ( start_f == STATE_IPD_CNT))
                              adw1<= sktp;
                           else
                              adw1<= 4'b0000;
                           if( start_f == STATE_IPD_CNT)		
                              adw2<= sadp;
                           else
                              adw2<= 4'b0000;	
                              amp_dout1<= amp2;
                              amp_dout2<= amp4;		  
   	                          per_reset<= 1;
	                          per_load<=1;
                           end		  
                           STATE_ANO_START: 
                           begin
                              adw1<= start_f;
                              if( start_f==STATE_ANO_START )
                                 adw2<= 1;	
                              else
                                 adw2<= 0;	
                              if(( start_f == STATE_IPD_START)| ( start_f == STATE_IPD_CNT)|(start_f==STATE_ANO_START))		 
                                 adw1<= sktp;
                              else
                                 adw1<= 4'b0000; 
                              if( start_f==STATE_ANO_START )	
                                 adw2<= sadp;	
                              else 
                                 adw2<= 4'b0000;
                              if( ( start_f == STATE_IPD_CNT)|(start_f==STATE_ANO_START))				  
                                 amp_dout1<= 4'b0000;	
                                 amp_dout2<= 4'b0000;		  
                                 per_reset<= 1;
                                 per_load<=1;
            end
            STATE_ANO_CNT: 
            begin
                                 adw1<=4'b1111;
                                 adw2<= 0;
                                 amp_dout1<= 4'b0000;
                                 amp_dout2<= 4'b0000;		  
                                 per_reset<= 1;
                                 per_load<=1;
                           end	  
	                       STATE_DONE: 
                           begin
	                             amp_dout1<= 4'b0000;	
                                 amp_dout2<= 4'b0000;	
                                 amp_dout1<= 4'b0000;	
                                 amp_dout2<= 4'b0000;		
                                 per_reset<= 1;
	                             per_load<=1;		  
	                       end	  
		                   default:
                           begin
		                         adw1<=4'b0000;
	                             adw2<= 4'b1111;
	                             amp_dout1<= 4'b0000;
                                 amp_dout2<= 4'b0000;		  
                                 per_reset<= 0;
	                             per_load<=1;
            end	
		 
        endcase
		

//assign period = ( state==STATE_KATH_START || state==STATE_KATH_CNT || state==STATE_ANO_START || state==STATE_ANO_CNT) ? adp : 1;
		
		

endmodule
