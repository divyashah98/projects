// Top-Level testbench module

module top ();
    reg         clk_tb;
    reg         s_clk_tb;
    reg         reset_n_tb;
    reg [3:0]   chip_sel_tb;
    reg         miso_tb;

    // Start the Flank clock
    always
    begin
        clk_tb = 0;
        # 10;
        clk_tb = 1;
        # 10;
    end

    // Start the Serial clock
    always
    begin
        s_clk_tb = 0;
        # 30;
        s_clk_tb = 1;
        # 30;
    end

    initial
    begin
        // Set the Reset signal
        reset_n_tb = 1'b0;
        // Wait for few clock cycles
        repeat (3) @ (posedge clk_tb);
        // Deassert the reset signal
        reset_n_tb = 1'b1;
        // Set the MISO signal of master
        miso_tb = 1'b1;
        // Set the chip select for Slave 0
        chip_sel_tb = 'h1;
        // Wait for few clock cycles
        repeat (100) @ (posedge clk_tb);
        // Set the chip select for Slave 1
        chip_sel_tb = 'h2;
        // Wait for few clock cycles
        repeat (3) @ (posedge clk_tb);
        // Set the chip select for Slave 2
        chip_sel_tb = 'h4;
        // Wait for few clock cycles
        repeat (3) @ (posedge clk_tb);
        // Set the chip select for Slave 3
        chip_sel_tb = 'h8;
        // Wait for few clock cycles
        repeat (30) @ (posedge clk_tb);
        $finish ("End of simulation reached");
    end

    SPI_master M1 (
        .clk (clk_tb),
        .s_clk (s_clk_tb),
        .reset_n (reset_n_tb),
        .miso (miso_tb),
        .m_chip_sel (chip_sel_tb),
        .mosi ()
    );

endmodule
