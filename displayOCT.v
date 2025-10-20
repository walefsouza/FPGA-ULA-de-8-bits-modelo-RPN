/* - - - SEGMENTOS DO DISPLAY - - -*/

// --- Segmento A ---
module OCTA(OA, A0, A1, A2);

	input A0, A1, A2;
	output OA;
	
	wire nota0, nota1, nota2;
	wire and0, and1, and2;

	// Inversores
	not NotA0(nota0, A0);
	not NotA1(nota1, A1);
	not NotA2(nota2, A2);

	// OA =  A0'A1'A2 + A0A1'A2'
	and And0(and0, nota0, nota1, A2);
	and And1(and1, A0, nota1, nota2);
	
	or OrFinalA(OA, and0, and1);
	
endmodule


// --- Segmento B ---
module OCTB(OB, A0, A1, A2);
	
	input A0, A1, A2;
	output OB;
	
	wire nota0, nota1, nota2;
	wire and0, and1;

	// Inversores
	not NotA0(nota0, A0);
	not NotA1(nota1, A1);
	not NotA2(nota2, A2);
	
	// OB = A0 A1'A2 + A0 A1 A2'

	and And0(and0, A0, nota1, A2);
	and And1(and1, A0, A1, nota2);

	or OrFinalB(OB, and0, and1);
	
endmodule


// --- Segmento C ---
module OCTC(OC, A0, A1, A2);

	input A0, A1, A2;
	output OC;
	
	wire nota0, nota1, nota2;
	wire and0;

	// Inversores
	not NotA0(nota0, A0);
	not NotA2(nota2, A2);

	// OC = ~A0 & A1 & ~A2
	and And0(and0, nota0, A1);
	and And1(OC, and0, nota2);
	
endmodule


// --- Segmento D ---
module OCTD(OD, A0, A1, A2);
	
	input A0, A1, A2;
	output OD;
	
	wire nota0, nota1, nota2;
	wire and0, and1, and2, and3, and4, or0;

	// Inversores
	not NotA0(nota0, A0);
	not NotA1(nota1, A1);
	not NotA2(nota2, A2);

	// OD = ~A0~A1A2 + A0~A1~A2 + A0A1A2
	and And0(and0, nota0, nota1);
	and And1(and1, and0, A2);
	and And2(and2, A0, nota1);
	and And3(and3, and2, nota2);
	and And4(and4, A0, A1);
	and And5(and5, and4, A2);

	or Or0(or0, and1, and3);
	or OrFinal(OD, or0, and5);
	
endmodule


// --- Segmento E ---
module OCTE(OE, A0, A1, A2);

	input A0, A1, A2;
	output OE;
	
	wire nota0, nota1, nota2;
	wire and0;

	// Inversores
	not NotA0(nota0, A0);
	not NotA1(nota1, A1);
	not NotA2(nota2, A2);

	// OE = A2 + A0~A1
	and And0(and0, A0, nota1);
	or OrFinal(OE, A2, and0);
	
endmodule


// --- Segmento F ---
module OCTF(OF, A0, A1, A2);
	
	input A0, A1, A2;
	output OF;
	
	wire nota0, nota1, nota2;
	wire and0, and1, and2;

	// Inversores
	not NotA0(nota0, A0);
	not NotA1(nota1, A1);
	not NotA2(nota2, A2);
	
	//OF = A0'A2 + A0'A1 + A1A2
	and And0(and0, nota0, A2);
	and And1(and1, nota0, A1);
	and And2(and2, A1, A2);
	
	or OrFinalF(OF, and0, and1, and2);
	
endmodule


// --- Segmento G ---
module OCTG(OG, A0, A1, A2);

	input A0, A1, A2;
	output OG;
	
	wire nota0, nota1, nota2;
	wire and0, and1, and2;

	// Inversores
	not NotA0(nota0, A0);
	not NotA1(nota1, A1);
	not NotA2(nota2, A2);

	// OG = ~A0~A1 + A0A1A2
	and And0(and0, nota0, nota1);
	and And1(and1, A0, A1);
	and And2(and2, and1, A2);
	
	or OrFinal(OG, and0, and2);
	
endmodule


/*- - - DISPLAY OCTAGONAL - - -*/

module displayOCT (OCTSEG, A0, A1, A2);

	input A0, A1, A2;
	output [6:0] OCTSEG;

	OCTA SegA (OCTSEG[0], A0, A1, A2);
	OCTB SegB (OCTSEG[1], A0, A1, A2);
	OCTC SegC (OCTSEG[2], A0, A1, A2);
	OCTD SegD (OCTSEG[3], A0, A1, A2);
	OCTE SegE (OCTSEG[4], A0, A1, A2);
	OCTF SegF (OCTSEG[5], A0, A1, A2);
	OCTG SegG (OCTSEG[6], A0, A1, A2);

endmodule
