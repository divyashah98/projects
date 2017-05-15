// SPI-Master block module

module SPI_master (
    input   wire        clk,
    input   wire        s_clk,
    input   wire        reset_n,
    input   wire        miso,       // Master in, slave out
    input   wire[3:0]   m_chip_sel, // Master chip-sel to drive slave chip selects
    output  wire        mosi        // Master out, slave in
);
    // Wires for the daisy chain connection of the slaves
    wire    miso_s0;
    wire    miso_s1;
    wire    miso_s2;
    wire    miso_s3;
    // Instantiate the shift register at the master port
    bezugszugriff S_M (
        .clk (clk),
        .reset_n (reset_n),
        .pad_din (miso),
        .pad_cs (s_clk),    // Master should be accept data on every posedge
        .pad_sck (s_clk),
        .pad_dout (mosi)
    );

    // Instantiate all the slave ports here
    // SPI Slave 0 
    SPI_slave S_0 (
        .clk (clk),
        .s_clk (s_clk),
        .reset_n (reset_n),
        .mosi (mosi),
        .miso (miso_s0),
        .chip_sel (m_chip_sel[0])
    );
    // SPI Slave 1 
    SPI_slave S_1 (
        .clk (clk),
        .s_clk (s_clk),
        .reset_n (reset_n),
        .mosi (miso_s0),
        .miso (miso_s1),
        .chip_sel (m_chip_sel[1])
    );
    // SPI Slave 2 
    SPI_slave S_2 (
        .clk (clk),
        .s_clk (s_clk),
        .reset_n (reset_n),
        .mosi (miso_s1),
        .miso (miso_s2),
        .chip_sel (m_chip_sel[2])
    );
    // SPI Slave 3 
    SPI_slave S_3 (
        .clk (clk),
        .s_clk (s_clk),
        .reset_n (reset_n),
        .mosi (miso_s2),
        .miso (miso_s3),
        .chip_sel (m_chip_sel[3])
    );

endmodule
