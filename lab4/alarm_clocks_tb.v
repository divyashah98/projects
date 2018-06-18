// Testbench
`timescale 1ms/1us

module alarm_clocks_tb ();
    reg           CLK;
    reg           SW0;
    reg           SW1;
    reg           SW2;
    reg           SW3;
    reg           SW4;
    reg           KEY0;
    reg           KEY1;
    reg           KEY2;
    reg           KEY3;
    wire [7:0]    SECOND_LSB;
    wire [7:0]    SECOND_MSB;
    wire [7:0]    MINUTE_LSB;
    wire [7:0]    MINUTE_MSB;
    wire [7:0]    HOUR_LSB;
    wire [7:0]    HOUR_MSB;
    wire          LED0;
    wire          LED1;
    wire          LED2;
    wire          LED3;
    wire          LED4;
    wire          LED7;

    ALARM_CLOCKS CLK0 (
        CLK,
        SW0,
        SW1,
        SW2,
        SW3,
        SW4,
        KEY0,
        KEY1,
        KEY2,
        KEY3,
        SECOND_LSB,
        SECOND_MSB,    
        MINUTE_LSB,
        MINUTE_MSB,
        HOUR_LSB,
        HOUR_MSB,
        LED0,
        LED1,
        LED2,
        LED3,
        LED4,
        LED7
    );

    always
    begin
        CLK = 1'b1; #250;
        CLK = 1'b0; #250;
    end

    initial begin
        SW0 = 1; SW1 = 0; SW2 = 0; SW3 = 0; SW4 = 0;
        @(posedge CLK);
        SW0 = 0;
        repeat (200) @(posedge CLK);
        $finish();
    end

endmodule
