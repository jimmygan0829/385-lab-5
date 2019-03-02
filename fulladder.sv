module full_adder (input x, 	//using full adder, called by 9 bit adder
						 input y, 
						 input z, 
                   output s, 
						 output c);
						 
		assign s = x^y^z; //compute the sum
		assign c = (x&y) | (y&z) | (x&z);  //comput the carry out
		
endmodule