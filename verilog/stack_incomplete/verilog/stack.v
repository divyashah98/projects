//Check for stack overflow instead of stack full
//The current scheme  allows the user to write to
//the stack under all conditions. The stack overflow
//signal would be asserted if the user write to it
//when the stack is full.
module stack 
    #( parameter D = 32,
                 A = 4
     )
     ( input  wire clk, reset,
       input  wire push, pop,
       input  wire [D-1:0] wr_data,
       output wire [D-1:0]rd_data
     );
     reg [D-1:0] stack_reg [2**A-1:0];
     reg [A-1:0] push_ptr_q, push_ptr_next, push_ptr_succ;
     reg [A-1:0] pop_ptr_q, pop_ptr_next, pop_ptr_succ;
     reg overflow_q, empty_q, overflow_next, empty_next;
     wire push_en;

     always @(posedge clk)
     if (push_en)
        stack_reg[push_ptr_q] <= wr_data;
     
     assign rd_data = stack_reg[pop_ptr_q];
     assign push_en = (push & ~full_q) ? 1'b1 : 1'b0;

     always @(posedge clk, posedge reset)
     if (reset)
     begin
        push_ptr_q <= 0;
        pop_ptr_q <= 0;
        overflow_q <= 0;
        empty_q <= 1;
     end
     else
     begin
        push_ptr_q <= push_ptr_next;
        pop_ptr_q <= pop_ptr_next;
        overflow_q <= overflow_next;
        empty_q <= empty_next;
     end

     always @ *
     begin
        push_ptr_next = push_ptr_q;
        pop_ptr_next = pop_ptr_q;
        empty_next = empty_q;
        overflow_next = overflow_q;
        push_ptr_succ = push_ptr_q + 1;
        pop_ptr_succ = push_ptr_q - 1;
        case ({push, pop})
            //2'b00: //no operation
            2'b01 : if (~empty_q)
                    begin
                        pop_ptr_next = pop_ptr_succ;
                        empty_next = (pop_ptr_succ == (push_ptr_q - 1)) ? 1'b1 : 1'b0;
                    end
            2'b10 : if (~full_q)
                    begin
                        push_ptr_next = push_ptr_succ;
                        empty_next = 1'b0;
                        full_next = (pop_ptr_q == push_ptr_succ) ? 1'b1 : 1'b0;
                    end
        endcase
     end

endmodule
