module fp_int_conv 
    (
        input wire sign1,
        input wire[3:0] exp1,
        input wire[7:0] frac1,
        output reg [7:0] int_num
    );

    reg int_sign;
    reg [7:0] int_mag;
    localparam EXP_BASE = 4'ha;

    always @ *
    begin
        if (EXP_BASE > exp1)
        begin
            int_sign = sign1;
            int_mag  = frac1 >> (EXP_BASE - exp1);
        end
        else
        begin
            int_sign = sign1;
            int_mag  = frac1 << (EXP_BASE - exp1);
        end
        int_num = {int_sign, int_mag[7:1]};
    end
endmodule
