module flipflop ( 			
			input  logic Clk,
			input logic Load, 
			input logic Reset, 
			input logic D,
			output logic Q
);	
		
		always_ff @ (posedge Clk)
		begin	
				if (Reset)	
					Q <= 1'b0;
				else	
					if (Load)
						Q <= D;
					else	
						Q <= Q;	//in most cases this is redundant, maintaining Q inferred
		end
		
endmodule