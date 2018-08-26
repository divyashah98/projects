module num2ascii (input [3:0] num, output logic [7:0] ascii_val);

    always_comb
    if (num > 'h9) begin
      ascii_val = 8'd97 + (num - 8'ha);
    end
    else begin
      ascii_val = num + 8'd48;
    end

endmodule
