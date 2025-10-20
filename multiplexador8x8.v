module multiplexador8x8(Out, Sel, Soma, Sub, Multi, Div, AndOp, OrOp, XorOp, NotOp);

	input  [2:0] Sel;
	input  [7:0] Multi, Div;
	input  [7:0] Soma, Sub;
	input  [7:0] AndOp, OrOp, XorOp, NotOp;
	output [7:0] Out;

	// =========================================================
	// INSTÂNCIAS DO MULTIPLEXADOR BASE
	// Cada instância é responsável por selecionar um bit da saída final.
	// =========================================================

	multiplexadorbase BIT0 (
		.Z(Out[0]), 
		.S2(Sel[2]), .S1(Sel[1]), .S0(Sel[0]),
		.E0(Soma[0]), .E1(Sub[0]), .E2(Multi[0]), .E3(Div[0]), 
		.E4(AndOp[0]), .E5(OrOp[0]), .E6(XorOp[0]), .E7(NotOp[0])
	);

	multiplexadorbase BIT1 (
		.Z(Out[1]), 
		.S2(Sel[2]), .S1(Sel[1]), .S0(Sel[0]),
		.E0(Soma[1]), .E1(Sub[1]), .E2(Multi[1]), .E3(Div[1]), 
		.E4(AndOp[1]), .E5(OrOp[1]), .E6(XorOp[1]), .E7(NotOp[1])
	);

	multiplexadorbase BIT2 (
		.Z(Out[2]), 
		.S2(Sel[2]), .S1(Sel[1]), .S0(Sel[0]),
		.E0(Soma[2]), .E1(Sub[2]), .E2(Multi[2]), .E3(Div[2]), 
		.E4(AndOp[2]), .E5(OrOp[2]), .E6(XorOp[2]), .E7(NotOp[2])
	);

	multiplexadorbase BIT3 (
		.Z(Out[3]), 
		.S2(Sel[2]), .S1(Sel[1]), .S0(Sel[0]),
		.E0(Soma[3]), .E1(Sub[3]), .E2(Multi[3]), .E3(Div[3]), 
		.E4(AndOp[3]), .E5(OrOp[3]), .E6(XorOp[3]), .E7(NotOp[3])
	);

	multiplexadorbase BIT4 (
		.Z(Out[4]), 
		.S2(Sel[2]), .S1(Sel[1]), .S0(Sel[0]),
		.E0(Soma[4]), .E1(Sub[4]), .E2(Multi[4]), .E3(Div[4]), 
		.E4(AndOp[4]), .E5(OrOp[4]), .E6(XorOp[4]), .E7(NotOp[4])
	);

	multiplexadorbase BIT5 (
		.Z(Out[5]), 
		.S2(Sel[2]), .S1(Sel[1]), .S0(Sel[0]),
		.E0(Soma[5]), .E1(Sub[5]), .E2(Multi[5]), .E3(Div[5]), 
		.E4(AndOp[5]), .E5(OrOp[5]), .E6(XorOp[5]), .E7(NotOp[5])
	);

	multiplexadorbase BIT6 (
		.Z(Out[6]), 
		.S2(Sel[2]), .S1(Sel[1]), .S0(Sel[0]),
		.E0(Soma[6]), .E1(Sub[6]), .E2(Multi[6]), .E3(Div[6]), 
		.E4(AndOp[6]), .E5(OrOp[6]), .E6(XorOp[6]), .E7(NotOp[6])
	);

	multiplexadorbase BIT7 (
		.Z(Out[7]), 
		.S2(Sel[2]), .S1(Sel[1]), .S0(Sel[0]),
		.E0(Soma[7]), .E1(Sub[7]), .E2(Multi[7]), .E3(Div[7]), 
		.E4(AndOp[7]), .E5(OrOp[7]), .E6(XorOp[7]), .E7(NotOp[7])
	);

	endmodule