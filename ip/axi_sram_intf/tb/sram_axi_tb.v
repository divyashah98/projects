module testbench ();
    reg        clk_tb;
    reg        reset_n_tb;
    reg        wr_en_tb;
    reg        chip_en_tb;
    //Write address channel signals
    reg[31:0]  awaddr_tb;     //write address
    reg        awvalid_tb;    //write address valid
    wire       awready_tb;
    //Write data channel signals
    reg[31:0]  wdata_tb;      //write data
    reg        wvalid_tb;     //write valid
    wire       wready_tb;     //write ready
    //Read address channel signals
    reg[31:0]  araddr_tb;     //read address
    reg        arvalid_tb;    //read address valid
    wire       arready_tb;    //read address ready
    //Write data channel signals
    wire[31:0] rdata_tb;      //read data
    wire       rvalid_tb;     //read valid
    reg        rready_tb;     //read ready
    //Write respsone channel signals
    wire       bvalid_tb;     //response valid
    wire       bresp_tb;      //response
    reg        bready_tb;
    localparam T = 20;

    axi_sram_intf sram_slave (
            .aclk(clk_tb),
            .areset_n(reset_n_tb),
            .wr_en(wr_en_tb),
            .chip_en(chip_en_tb),
            .awaddr(awaddr_tb),
            .awvalid(awvalid_tb),
            .awready(awready_tb),
            .wdata(wdata_tb),
            .wvalid(wvalid_tb),
            .wready(wready_tb), 
            .araddr(araddr_tb),
            .arvalid(arvalid_tb),
            .arready(arready_tb),
            .rdata(rdata_tb),
            .rvalid(rvalid_tb),
            .rready(rready_tb), 
            .bvalid(bvalid_tb), 
            .bresp(bresp_tb),   
            .bready(bready_tb) 
    );
    always
    begin
        clk_tb = 1;
        #(T/2);
        clk_tb = 0;
        #(T/2);
    end

    initial
    begin
        reset_n_tb = 'h0;
        #(T/2);
        reset_n_tb = 'h1;
    end

    initial
    begin
        //Write enable should be 1 at the start
        wr_en_tb = 1; //active low
        //Chip enable can be one/zero
        chip_en_tb = 1;
        //All the valid signals should be zero
        awvalid_tb = 0;
        arvalid_tb = 0;
        wvalid_tb = 0;
        bready_tb = 0;
        rready_tb = 0;
        //Wait for reset to be 1
        @(posedge reset_n_tb);
        //Wait for few cycles after the reset
        repeat (2) @(negedge clk_tb);
        //Try to write to SRAM without 
        //asserting the write enable.
        //Use the write channel
        awaddr_tb = 32'hdead_beef;
        awvalid_tb = 1;
        repeat (2) @(negedge clk_tb);
        awvalid_tb = 0;
        repeat (2) @(negedge clk_tb);
        //Use the write data channel
        wdata_tb = 32'h1234;
        wvalid_tb = 1;
        repeat (2) @(negedge clk_tb);
        wvalid_tb = 0;
        repeat (4) @(negedge clk_tb);
        //Use the response channel
        bready_tb = 1;
        repeat (2) @(negedge clk_tb);
        bready_tb = 0;
        repeat (2) @(negedge clk_tb);
        //Read from the same address
        araddr_tb = 32'hdead_beef;
        arvalid_tb = 1;
        repeat (2) @(negedge clk_tb);
        arvalid_tb = 0;
        repeat (4) @(negedge clk_tb);
        //Use the response channel
        rready_tb = 1;
        repeat (2) @(negedge clk_tb);
        rready_tb = 0;
        repeat (2) @(negedge clk_tb);
        //Try to write to SRAM with 
        //the write enabled.
        wr_en_tb = 0; //active low
        //Use the write channel
        awaddr_tb = 32'hfade_cafe;
        awvalid_tb = 1;
        repeat (2) @(negedge clk_tb);
        awvalid_tb = 0;
        repeat (2) @(negedge clk_tb);
        //Use the write data channel
        wdata_tb = 32'h1234;
        wvalid_tb = 1;
        repeat (2) @(negedge clk_tb);
        wvalid_tb = 0;
        repeat (4) @(negedge clk_tb);
        //Use the response channel
        bready_tb = 1;
        repeat (2) @(negedge clk_tb);
        bready_tb = 0;
        repeat (2) @(negedge clk_tb);
        //Read from the same address
        araddr_tb = 32'hfade_cafe;
        arvalid_tb = 1;
        repeat (2) @(negedge clk_tb);
        arvalid_tb = 0;
        repeat (4) @(negedge clk_tb);
        //Use the response channel
        rready_tb = 1;
        repeat (2) @(negedge clk_tb);
        rready_tb = 0;
        $finish;
    end

endmodule
