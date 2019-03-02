module reg_8 //register unit from last lab, 8 bit processor
(
		input  logic Clk, 
		input  logic Reset, 
		input  logic Shift_In, 
		input  logic Load, 
		input  logic Shift_En,
		input  logic [7:0]  D,
		output logic Shift_Out,
		output logic [7:0]  D_Out
);

		always_ff @ (posedge Clk)
		begin
			if (Reset)				
				D_Out <= 8'h0;
			else if (Load)
				D_Out <= D;			
			else if (Shift_En)	
			begin
			//concatenate shifted in data to the previous left-most 3 bits
			//note this works because we are in always_ff procedure block
				D_Out <= {Shift_In, D_Out[7:1]};
			end
		end

		assign Shift_Out = D_Out[0];
		
endmodule