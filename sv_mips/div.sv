function Div divhh;
	input [witdh-1:0] A, B;
	integer i;
	reg signed [width-1:0] D;
	reg [width-1:0] R, Rh;
	divhh.R = {width{1'b0}};
	for (i=width-1;i>=0;i=i-1) begin

		R = (divhh.R<<1)+A[i];
		Rh = divhh.R<<1;
		Rh = {Rh[width-1:1],A[i]};
		D = Rh-B;
			if (D<0)
				begin
				   divhh.D[i] = 1'b0; divhh.R = R;
			    	end 
			else
				begin
				   divhh.D[i] = 1'b1; divhh.R = D;
				end
		end
endfunction
