// Alarm Clock module
module ALARM_CLOCKS (
    input               CLK,
    input               SW0,
    input               SW1,
    input               SW2,
    input               SW3,
    input               SW4,
    input               KEY0,
    input               KEY1,
    input               KEY2,
    input               KEY3,
    output reg [7:0]    SECOND_LSB,
    output reg [7:0]    SECOND_MSB,
    output reg [7:0]    MINUTE_LSB,
    output reg [7:0]    MINUTE_MSB,
    output reg [7:0]    HOUR_LSB,
    output reg [7:0]    HOUR_MSB,
    output reg          LED0,
    output reg          LED1,
    output reg          LED2,
    output reg          LED3,
    output reg          LED4,
    output reg          LED7
);

    reg  [7:0]   h_time      [5:0];
    wire [7:0]   h_time_nxt  [5:0];

    reg [7:0]   alarm       [5:0];
    reg [7:0]   alarm_nxt   [5:0];

    reg [5:0]   sec_val_q, sec_val;
    reg [5:0]   min_val_q, min_val;
    reg [5:0]   hrs_val_q, hrs_val;

    reg [1:0]   clk_cnt_q;

    wire [1:0]  clk_cnt;
    wire        sec_val_tick;
    wire        min_val_tick;
    wire        hrs_val_tick;

    localparam  CLK_SEC_TICK     = 1;
    localparam  SW4_CLK_SEC_TICK = 0;

    always @(posedge CLK)
    if (SW0)
    begin
        sec_val_q <= 6'h0;
        min_val_q <= 6'h0;
        hrs_val_q <= 6'h0;
    end
    else
    begin
        sec_val_q <= sec_val;
        min_val_q <= min_val;
        hrs_val_q <= hrs_val;
    end

    always @(posedge CLK)
    if (SW0)
    begin
        clk_cnt_q <= 1'b0;
    end
    else
    begin
        clk_cnt_q <= clk_cnt;
    end

    always @(posedge CLK)
    begin
        h_time[0] <= h_time_nxt[0];
        h_time[1] <= h_time_nxt[1];
        h_time[2] <= h_time_nxt[2];
        h_time[3] <= h_time_nxt[3];
        h_time[4] <= h_time_nxt[4];
        h_time[5] <= h_time_nxt[5];
    end

    assign clk_cnt = (clk_cnt_q < CLK_SEC_TICK) ? (clk_cnt_q + 2'b01) : 2'b0;

    assign sec_val_tick = (clk_cnt == CLK_SEC_TICK);
    assign min_val_tick = (sec_val_q == 6'd59) && sec_val_tick;
    assign hrs_val_tick = (min_val_q == 6'd59) && min_val_tick;

    always @(SW1 or SW2 or SW3 or SW4 or 
             KEY0 or KEY1 or KEY2 or KEY3 or
             sec_val_tick or sec_val_tick or
             min_val_tick or min_val_tick or
             hrs_val_tick or hrs_val_tick)
    begin
        if (SW1)
        begin
            sec_val = (KEY1) ? ((min_val_tick)? 6'h0: (sec_val_q + 1'b1))       : sec_val_q;
            min_val = (KEY2) ? ((hrs_val_tick)? 6'h0: (min_val_q + 1'b1))       : min_val_q;
            hrs_val = (KEY3) ? ((hrs_val_q == 6'd23)? 6'h0 :(hrs_val_q + 1'b1)) : hrs_val_q;
        end
        else
        begin
            sec_val = (sec_val_tick) ? ((min_val_tick)? 6'h0: (sec_val_q + 1'b1))       : sec_val_q;
            min_val = (min_val_tick) ? ((hrs_val_tick)? 6'h0: (min_val_q + 1'b1))       : min_val_q;
            hrs_val = (hrs_val_tick) ? ((hrs_val_q == 6'd23)? 6'h0 :(hrs_val_q + 1'b1)) : hrs_val_q;
        end
    end

    assign h_time_nxt[5] = hrs_val_q; 
    assign h_time_nxt[4] = hrs_val_q;
    assign h_time_nxt[3] = min_val_q; 
    assign h_time_nxt[2] = min_val_q;
    assign h_time_nxt[1] = sec_val_q; 
    assign h_time_nxt[0] = sec_val_q;

endmodule
