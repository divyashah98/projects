module fp_adder (
        input wire sign1, sign2,
        input wire [3:0] exp1, exp2,
        input wire [7:0] frac1, frac2,
        output reg sign_out,
        output reg [3:0] exp_out,
        output reg [7:0] frac_out
    );

    //Decalare the different signals here
    reg signl, signs, signn;
    reg [3:0] expl, exps, expn, exp_diff;
    reg [7:0] fracl, fracs, fracn;
    reg [8:0] sum_int;
    reg [2:0] lead0;

    //Stage1 - Find the larger fraction
    always @ *
    begin
      if ({exp1, frac1} > {exp2, frac2})
      begin
          signl = sign1;
          fracl = frac1;
          expl  = exp1;
          signs = sign2;
          fracs = frac2;
          exps  = exp2;
      end
      else 
      begin
          signl = sign2;
          fracl = frac2;
          expl  = exp2;
          signs = sign1;
          fracs = frac1;
          exps  = exp1;
      end

      //Stage2 - Align the numbers
      exp_diff = expl - exps;
      fracs = fracs >> exp_diff;

      //Stage3 - Add/Sub the numbers
      if (signl == signs)
        sum_int = {1'b0, fracl} + {1'b0, fracs};
      else
        sum_int = {1'b0, fracl} - {1'b0, fracs};

      //Stage4 - Get the normalised result
      if (sum_int[7])
        lead0 = 3'h0;
      else if (sum_int[6])
        lead0 = 3'h1;
      else if (sum_int[5])
        lead0 = 3'h2;
      else if (sum_int[4])
        lead0 = 3'h3;
      else if (sum_int[3])
        lead0 = 3'h4;
      else if (sum_int[2])
        lead0 = 3'h5;
      else if (sum_int[1])
        lead0 = 3'h6;
      else if (sum_int[0])
        lead0 = 3'h7;

      //Normalize with special conditions
      if (sum_int[8]) //Adjust the carry out
      begin
        // not right shifting here since the sum_int
        //is a 9 bit signal but we need the upper 
        //8 bits only
        fracn = sum_int[8:1]; 
        expn = expl + 1;
      end
      if (lead0 > expl) //Make the result as Zero
      begin
        fracn = 8'h0;
        expn = 4'h0;
      end
      else //Get the normalised result
      begin
        fracn = sum_int << lead0;
        expn  = expl - lead0;
        signn = signl;
      end
      
      //Assign the output signals
      frac_out = fracn;
      exp_out = expn;
      sign_out = signn;
    end
endmodule

