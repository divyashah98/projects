`timescale 1ns/1ns
module tb_branch_pred_one_bit;
  reg clk_tb ,branch_index_tb ;
  reg [1:0] branch_action_tb;
  wire branch_update_tb;
  wire [1:0] branch_history_tb;
  //reg data_file,scan_file;
  reg  [40:0] captured_data;
  reg  [200:0] str;
  integer   data_file;
  integer   scan_file;
  integer mispredicts;
  branch_pred_one_bit b1(
    .clk(clk_tb),
    .branch_index(branch_index_tb),
    .branch_action(branch_action_tb),
    .branch_update(branch_update_tb),
    .branch_history(branch_history_tb)
  );
initial
  begin
    clk_tb =0;
    data_file = $fopen("/home/rahul/Desktop/seq.txt","r");
      if (!data_file)
        $fatal(1, "Could not open  the mentioned file : \"seq.txt\"");
    //$display("data_file is %d",data_file);
     
    //$ferror(data_file,str);

    //scan_file = $fscanf(data_file, "%s\n", captured_data);
    //$display("Contents of the file are %s",captured_data);
    //$display("BRANCH INDEX VAL: %s",captured_data[15:0]);
    //$display("BRANCH TAKENESS: %s",captured_data[40:24]);
    //scan_file = $fscanf(data_file, "%s\n", captured_data);
    //$display("Contents of the file are %s",captured_data);
    //$display("BRANCH INDEX VAL: %s",captured_data[15:0]);
    //$display("BRANCH TAKENESS: %s",captured_data[40:24]);
  end
always 
  #10 clk_tb = ~clk_tb;
always @(posedge clk_tb)
  begin
    if (!$feof(data_file))
    begin
      scan_file = $fscanf(data_file, "%s\n", captured_data);
      assign branch_index_tb = captured_data[40:24];
      $display ("branch_index_tb: %s", captured_data[39:16]);
      $display ("branch_action_tb: %s", captured_data[15:0]);
      if(captured_data[15:0] == ",T")
        branch_action_tb[branch_index_tb] = 1'b1;
      else
        branch_action_tb[branch_index_tb] = 1'b0;
    end
    else
    begin
      $display ("End of file reached. Ending Simulation\n");
      $finish;
    end
  end
endmodule
