//A simple RAM verilog module

module sram
    (
        input   wire        clk,
        input   wire        resetn,
        input   wire[31:0]  address,
        input   wire[31:0]  w_data,
        input   wire        chip_select,
        input   wire        write_en,       //active low 
        output  wire[31:0]  r_data,
        output  reg         resp
    );

    //Declare a 2-D array as the memory holder
    reg [31:0] ram [1023:0];
    //synchronous write only
    always @ (posedge clk)
        if (~write_en & chip_select)
        begin
            ram[address & 32'h3FF] <= w_data;
            resp <= 1'h1;
        end
        else
            resp <= 1'h0;
    //read data only when write enable is high
    assign r_data = ram[address & 32'h3FF];

endmodule
