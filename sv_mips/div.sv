module div (
    input wire [7:0] A, 
    input wire [7:0] B,
    output logic [7:0] D
);

    always_comb begin
        D = divhh (A, B);
    end

    function logic [7:0] divhh;
    	input [7:0] A, B;
    	integer i;
    	logic signed [7:0] D;
    	logic [7:0] R, Rh;
    	R = {8{1'b0}};
    	for (i=7;i>=0;i=i-1) begin
    
    		R = (R<<1)+A[i];
    		Rh = R<<1;
    		Rh = {Rh[7:1],A[i]};
    		D = Rh-B;
    			if (D<0)
    				begin
    				   D[i] = 1'b0; R = R;
    			    	end 
    			else
    				begin
    				   D[i] = 1'b1; R = D;
    				end
    		end
            return D;
    endfunction
endmodule
