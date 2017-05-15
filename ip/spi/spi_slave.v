// SPI-Slave block module

module SPI_slave (
    input   wire        clk,
    input   wire        s_clk,
    input   wire        reset_n,
    input   wire        mosi,   // Master out, slave in
    output  wire        miso,   // Master in, slave out
    input   wire        chip_sel
);
    // Instantiate the shift register at the slave port
    bezugszugriff S_S (
        .clk (clk),
        .reset_n (reset_n),
        .pad_din (mosi),
        .pad_cs (chip_sel),
        .pad_sck (s_clk),
        .pad_dout (miso)
    );

endmodule
