module branch_pred_one_bit(clk,branch_index,branch_action,branch_update,branch_history);
input clk,branch_index;
input [1:0]branch_action;
output branch_update;
output reg [1:0] branch_history =2'b11 ;
  assign branch_update = (branch_action[branch_index]!=branch_history[branch_index])?1:0;
  always @(posedge clk) begin
     branch_history[branch_index] = (branch_update)?(~branch_history[branch_index]):(branch_history[branch_index]);
  end
endmodule
