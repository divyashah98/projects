//AXI implementation in Verilog

module axi_sram_intf
    (
        //Declare the global signals
        input   wire        aclk,
        input   wire        areset_n,  //active low
        input   wire        wr_en, 
        input   wire        chip_en,
        //Write address channel signals
        input  reg[31:0]   awaddr,     //write address
        input  reg         awvalid,    //write address valid
        output  reg        awready,    //write address ready
        //Write data channel signals
        input  reg[31:0]   wdata,      //write data
        input  reg         wvalid,     //write valid
        output  reg         wready,    //write ready
        //Write respsone channel signals
        output  reg         bvalid,    //response valid
        output  reg         bresp,     //response 
        input   wire        bready,    //resp ready
        //Read address channel signals
        input  reg[31:0]   araddr,     //read address
        input  reg         arvalid,    //read address valid
        output  reg         arready,   //read address ready
        //Write data channel signals
        output reg[31:0]   rdata,      //read address
        output reg         rvalid,     //read data valid
        input  reg         rready      //read ready
    );
    
    reg[31:0] data1, addr;
    wire[31:0] data2; 
    reg bvalid_q, bresp_q, awready_q, arready_q, rvalid_q, wready_q;
    wire sram_resp;
    //Slave RAM
    sram sram_intf (.clk(aclk), .resetn(areset_n), .address(addr), .w_data(data1), .chip_select(chip_en), .write_en(wr_en), .r_data(data2), .resp(sram_resp));
    //Master signals driven by testbench
    always @ (posedge aclk)
        if (~areset_n)
        begin
            bvalid      <= 0;
            bresp       <= 0;
            awready     <= 1;
            arready     <= 1;
            rvalid      <= 0;
            wready      <= 0;
        end
        else
        begin
            bvalid      <= bvalid_q;
            bresp       <= bresp_q;
            awready     <= awready_q;
            arready     <= arready_q;
            rvalid      <= rvalid_q;
            wready      <= wready_q;
        end
    always @(*)
    begin
       if (awvalid & awready_q)
       begin
           addr = awaddr;
           awready_q = 0;
           arready_q = 0;
           rvalid_q = 0;
           wready_q = 1;
           bvalid_q = 0;
       end
       else if (wvalid & wready_q)
       begin
           data1 = wdata;
           awready_q = 1;
           arready_q = 1;
           rvalid_q = 0;
           wready_q = 0;
           bvalid_q = 0;
       end
       else if (bready)
       begin
           bvalid_q = 1;
           bresp_q  = sram_resp; // 1 - ok
           awready_q = 1;
           arready_q = 1;
           rvalid_q = 0;
           wready_q = 1;
       end
       else if (arvalid & arready_q)
       begin
           addr = araddr;
           awready_q = 0;
           arready_q = 0;
           rvalid_q = 0;
           wready_q = 0;
           bvalid_q = 0;
       end
       else if (rready)
       begin
           rdata = data2;
           awready_q = 1;
           arready_q = 1;
           rvalid_q = 1;
           wready_q = 1;
           bvalid_q = 0;
       end
       else
       begin
           bvalid_q      = bvalid;
           bresp_q       = bresp;
           awready_q     = awready;
           arready_q     = arready;
           rvalid_q      = rvalid;
           wready_q      = wready;
       end
    end

endmodule
