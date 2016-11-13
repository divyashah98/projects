// Generate a PWM signal with period = 1600 ns
module pwm
      (
        input wire clk, reset,
        input wire [3:0] n,
        output wire pwm
      );

      reg [3:0] on, off;
      prog_sqr_wav_gen #(4) sqr_wav (.clk(clk), .reset(reset), .m(on), .n(off), .sqr_wav_o(pwm));
      
      always @ *
      case (n)
        //4'b0000 : //not allowed
        //4'b0001 : begin on = 4'h1;    off = 4'hf;  end 
        4'b0010 : begin on = 4'h2;    off = 4'he;  end
        4'b0011 : begin on = 4'h3;    off = 4'hd;  end
        4'b0100 : begin on = 4'h4;    off = 4'hc;  end
        4'b0101 : begin on = 4'h5;    off = 4'hb;  end
        4'b0110 : begin on = 4'h6;    off = 4'ha;  end
        4'b0111 : begin on = 4'h7;    off = 4'h9;  end
        4'b0000 : begin on = 4'h8;    off = 4'h8;  end
        4'b1001 : begin on = 4'h9;    off = 4'h7;  end
        4'b1010 : begin on = 4'ha;    off = 4'h6;  end
        4'b1011 : begin on = 4'hb;    off = 4'h5;  end
        4'b1100 : begin on = 4'hc;    off = 4'h4;  end
        4'b1101 : begin on = 4'hd;    off = 4'h3;  end
        4'b1110 : begin on = 4'he;    off = 4'h2;  end
        //4'b1111 : begin on = 4'hf;    off = 4'h1;  end
        default : begin on = 4'he;    off = 4'h2;  end
      endcase

endmodule
