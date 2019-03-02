//8 bit multiplier with sign extend

module lab5_toplevel
(
	input	logic				Clk,	// input clock
	input	logic				Reset,	//reset button 0
	input logic 			ClearA_LoadB,	//ClearA_LoadB button 2
	input logic 			Run, //Run button 3,
	input	logic [7:0]		S, //switches

	output 	logic 		X,	//extend signed bit
	output 	logic [7:0]	Aval,	//output register A
								Bval,	//output register B
	output	logic [6:0]	AhexU,
								AhexL,	
								BhexU,
								BhexL
);

	//local logic variables
	logic [8:0]	XA;	// register A with signed bit
	logic [7:0]	A, B;	// output of register A and register B
	logic A_out;	// output of A shift register
	logic Add, Sub, Clr_Ld, Shift_en, clra;	// output of control unit

	//call 8 bit adder with signed bit
	add_9 Bit_Adder
	(
		.A (A),
		.B (S),
		.fn (Sub),
		.S (XA)
	);

	
	//call flipflop for signed bit
	flipflop Dflipflop
	(
		.Clk (Clk),
		.Load (Add | Sub), 
		.Reset (Reset^1'b1 | Clr_Ld | clra),
		.D (XA[8]),
		.Q (X)
	);


	//call 8 bit register for register A
	reg_8 Register_A
	(
		.Clk (Clk),
		.Reset (Reset^1'b1 | Clr_Ld | clra),
		.Shift_In (X),					
		.Load (Add | Sub),			
		.Shift_En (Shift_XAB),
		.D (XA[7:0]),
		.Shift_Out (A_out),			
		.D_Out (A)
	);


	//call 8 bit register for register B
	reg_8 Register_B
	(
		.Clk (Clk),
		.Reset (Reset^1'b1),		
		.Shift_In (A_out),			
		.Load (Clr_Ld),
		.Shift_En (Shift_XAB),
		.D (S),
		.Shift_Out (),
		.D_Out (B)
	);


	// control unit
	control controlunit
	(
		.Clk (Clk),
		.Reset (Reset^1'b1),
		.ClearA_LoadB (ClearA_LoadB^1'b1),
		.Run (Run^1'b1),
		.M (B[0]),					
		.Shift_enable (Shift_XAB),
		.Clr_Ld (Clr_Ld),
		.Add (Add),
		.Sub (Sub),
		.clra(clra)
	);
	
	
	HexDriver AhexU_inst
	(
		.In0 (A[7:4]),
		.Out0 (AhexU)
	);

	HexDriver AhexL_inst
	(
		.In0 (A[3:0]),
		.Out0 (AhexL)
	);

	HexDriver BhexU_inst
	(
		.In0 (B[7:4]),
		.Out0 (BhexU)
	);

	HexDriver BhexL_inst
	(
		.In0 (B[3:0]),
		.Out0 (BhexL)
	);

	assign Aval = A;	
	assign Bval = B;  




endmodule