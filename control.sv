module control (
		input logic Clk,
		input logic Reset, 
		input logic ClearA_LoadB, 
		input logic Run, 
		input logic M,	//B[0]
		output logic Shift_enable, //shift enable signal
		output logic Clr_Ld, 		//clear register A and load Resigster B enbale signal
		output logic Add, 			//add enable signal
		output logic Sub, 			//subtract enable signal
		output logic clra				//clear reigster A enable signal
);	

		
 		enum logic [4:0] {Start,run, s1, s2, s3, s4, s5, s6, s7, s8, a1, a2, a3, a4, a5, a6, a7, a8, Hold} curr_state, next_state;

		
 		always_ff @ (posedge Clk)
 		begin
 			if (Reset)
 				curr_state <= Start;
 			else
 				curr_state <= next_state;
 		end

 		always_comb
 		begin
 			next_state = curr_state;	

 			unique case (curr_state)
				
 				Start: 	if (Run)					//go to run state only when run is exectued
 								next_state = run;	//go to clearA State everytime it hit run
				run:		next_state = a1;
 				a1 : 		next_state = s1;
 				s1 : 		next_state = a2;
 				a2 : 		next_state = s2;
 				s2 : 		next_state = a3;
 				a3 : 		next_state = s3;
 				s3 : 		next_state = a4;
 				a4 : 		next_state = s4;
 				s4 : 		next_state = a5;
 				a5 : 		next_state = s5;
 				s5 : 		next_state = a6;
 				a6 : 		next_state = s6;
 				s6 : 		next_state = a7;
 				a7 : 		next_state = s7;
 				s7 : 		next_state = a8;
 				a8 : 		next_state = s8;
 				s8 : 		next_state = Hold;
 				Hold: 		if (~Run)			//buffer state
 								next_state = Start;
 			endcase
 		end

 		always_comb
 		begin
 			case (curr_state)

 				Start, Hold:				//buffer state before and after the calculation
				begin
 					Clr_Ld = ClearA_LoadB;
					clra = 1'b0;
 					Shift_enable = 1'b0;
 					Add = 1'b0;
 					Sub = 1'b0;
				end
				
				run:
				begin
				 	Clr_Ld = ClearA_LoadB;
					clra = 1'b1;
 					Shift_enable = 1'b0; //before run, clear register A
 					Add = 1'b0;
 					Sub = 1'b0;
				end
				
 				a1, a2, a3, a4, a5, a6, a7: // execute adder
				begin					
 					Clr_Ld = 1'b0;
 					Shift_enable = 1'b0;
					clra = 1'b0;
 					if (M)		
 					begin
 						Add = 1'b1;
 						Sub = 1'b0;
 					end else begin
 						Add = 1'b0;
 						Sub = 1'b0;
 					end
				end
				
 				a8:								//add the most significant bit
				begin
 					Clr_Ld = 1'b0;
 					Shift_enable = 1'b0;
					clra = 1'b0;
					if (M)
 					begin		
 						Add = 1'b0;
 						Sub = 1'b1;
 					end else begin
 						Add = 1'b0;
 						Sub = 1'b0;
 					end
				end
				
 				s1, s2, s3, s4, s5, s6, s7, s8:	//execute shift
				begin				
 					Clr_Ld = 1'b0;
					clra = 1'b0;
 					Shift_enable = 1'b1;
 					Add = 1'b0;
 					Sub = 1'b0;
				end
			endcase
 		end
endmodule
