module multiplexador3x1 (Out, A, B, C, S1, S0);

	input A, B, C;    // Entradas de dados
	input S1, S0;     // Entradas de seleção
	output Out;       // Saída selecionada

	/* --- Wires para seleção invertida --- */
	wire S1_n, S0_n;

	/* --- Wires para os termos AND --- */
	wire termA, termB, termC;

	/* --- Wires intermediários para a soma OR --- */
	wire or_temp;

	/* - - - INVERSORES - - - */
	not NotS1(S1_n, S1);
	not NotS0(S0_n, S0);

	/* - - - IMPLEMENTAR OS TERMOS AND - - - */
	and AndTermA(termA, A, S1_n, S0_n); /* Termo para A (Sel=00) */
	and AndTermB(termB, B, S1_n, S0);   /* Termo para B (Sel=01) */
	and AndTermC(termC, C, S1,   S0_n); /* Termo para C (Sel=10) */
												 /* O termo para Sel=11 é omitido, resultando em 0 */

	/* - - - IMPLEMENTAR A SOMA OR FINAL - - - */
	or OrTemp(or_temp, termA, termB);
	or OrFinal(Out, or_temp, termC);

endmodule

module multiplexadordisplayRPN (Segmentos, Decimal, Octal, Hex, Base);

	input [6:0] Decimal;
	input [6:0] Octal;
	input [6:0] Hex;
	input [1:0] Base; // Base[1]=S1, Base[0]=S0
	output [6:0] Segmentos;

	/* - - - MUX 3:1 PARA CADA BIT - - - */

	multiplexador3x1 MuxBit0 (.Out(Segmentos[0]), .A(Decimal[0]), .B(Octal[0]), .C(Hex[0]), .S1(Base[1]), .S0(Base[0]));
	multiplexador3x1 MuxBit1 (.Out(Segmentos[1]), .A(Decimal[1]), .B(Octal[1]), .C(Hex[1]), .S1(Base[1]), .S0(Base[0]));
	multiplexador3x1 MuxBit2 (.Out(Segmentos[2]), .A(Decimal[2]), .B(Octal[2]), .C(Hex[2]), .S1(Base[1]), .S0(Base[0]));
	multiplexador3x1 MuxBit3 (.Out(Segmentos[3]), .A(Decimal[3]), .B(Octal[3]), .C(Hex[3]), .S1(Base[1]), .S0(Base[0]));
	multiplexador3x1 MuxBit4 (.Out(Segmentos[4]), .A(Decimal[4]), .B(Octal[4]), .C(Hex[4]), .S1(Base[1]), .S0(Base[0]));
	multiplexador3x1 MuxBit5 (.Out(Segmentos[5]), .A(Decimal[5]), .B(Octal[5]), .C(Hex[5]), .S1(Base[1]), .S0(Base[0]));
	multiplexador3x1 MuxBit6 (.Out(Segmentos[6]), .A(Decimal[6]), .B(Octal[6]), .C(Hex[6]), .S1(Base[1]), .S0(Base[0]));

endmodule
