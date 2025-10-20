/* - - - SEGMENTOS DO DISPLAY - - -*/

module HEXA(SA, A, B, C, D); 

	input A, B, C, D;
	output SA;

	wire nota, notb, notc, notd;

	not NotA(nota, A);
	not NotB(notb, B);
	not NotC(notc, C);
	not NotD(notd, D);

	wire and0, and1, and2, and3;

	/* a(a, b, c, d) = a'b'c'd + a'bc'd' + ab'cd + abcd' */
	
	and And0(and0, nota, notb, notc, D);
	and And1(and1, nota, B, notc, notd);
	and And2(and2, A, notb, C, D);
	and And3(and3, A, B, C, notd);

	or Or(SA, and0, and1, and2, and3);

endmodule

module HEXB (SB, A, B, C,D);

    input  A;
    input  B;
    input  C;
    input  D;
    output SB;

    // --- Inversores ---
    wire nota, notb, notc, notd;
    not NotA(nota, A);
    not NotB(notb, B);
    not NotC(notc, C);
    not NotD(notd, D);

/* b(a, b, c, d) = a'bc'd + a'bcd' + acd + abc'd' */
   
    wire and0, and1, and2, and3;
    and And0(and0, nota, B, notc, D);
	and And1(and1, nota, B, C, notd);
	and And2(and2, A, C, D);
	and And3(and3, A, B, notc, notd);
   
    // --- ORs finais ---
    or Or(SB, and0, and1, and2, and3);    

endmodule


module HEXC (SC, A, B, C, D);

	input A, B, C, D;
	output SC;

	wire nota, notb, notc, notd;

	not NotA(nota, A);
	not NotB(notb, B);
	not NotC(notc, C);
	not NotD(notd, D);

	wire and0, and1, and2;

	/* c(a, b, c, d) = a'b'cd' + abd' + abc */

	and And0(and0, nota,notb, C, notd);
	and And1(and1, A, B, notd);
	and And2(and2, A, B, C);
	or Or(SC, and0, and1, and2);

endmodule

module HEXD (SD, A, B, C, D);

	input A, B, C, D;
	output SD;

	wire nota, notb, notc, notd;

	not NotA(nota, A);
	not NotB(notb, B);
	not NotC(notc, C);
	not NotD(notd, D);

	wire and0, and1, and2, and3;

	/* d(a, b, c, d) = a'b'c'd + a'bc'd' + bcd + ab'cd' */

	and And0(and0, nota, notb, notc, D);
	and And1(and1, nota, B, notc, notd);
	and And2(and2, B, C, D);
	and And3(and3,A, notb, C, notd);

	or Or(SD, and0, and1, and2, and3);

endmodule

module HEXE (SE, A, B, C, D);

	input A, B, C, D;
	output SE;

	wire nota, notb, notc, notd;

	not NotA(nota, A);
	not NotB(notb, B);
	not NotC(notc, C);
	not NotD(notd, D);

	wire and0, and1, and2, and3;

	/* e(a, b, c, d) = a'd + a'bc' + b'c'd */

	and And0(and0, nota, D);
	and And1(and1, nota, B, notc);
	and And2(and2, notb, notc, D);

	or Or0(SE, and0, and1, and2);

endmodule

module HEXF (SF, A, B, C, D);

	input A, B, C, D;
	output SF;

	wire nota, notb, notc, notd;

	not NotA(nota, A);
	not NotB(notb, B);
	not NotC(notc, C);
	not NotD(notd, D);

	wire and0, and1, and2, and3;

	/* f(a, b, c, d) = a'b'd + a'b'c + a'cd + abc'd */

	and And0(and0, nota, notb, D);
	and And1(and1, nota, notb, C);
	and And2(and2, nota, C, D);
	and And3(and3, A, B, notc, D);
	
	or Or(SF, and0, and1, and2, and3);

endmodule

module HEXG (SG, A, B, C, D);

	input A, B, C, D;
	output SG;

	wire nota, notb, notc, notd;
	wire and0, and1, and2;

	not NotA(nota, A);
	not NotB(notb, B);
	not NotC(notc, C);
	not NotD(notd, D);

	/* g(a, b, c, d) = a'b'c' + a'bcd + abc'd' */
 
	and And0(and0, nota, notb, notc);
	and And1(and1, nota, B, C, D);
	and And2(and2, A, B, notc, notd);

	or Or(SG, and0, and1, and2);

endmodule


/*- - - DISPLAY HEXADECIMAL - - -*/

module displayHEX (HEXSEG, A, B, C, D);

	input A, B, C, D;
	output [6:0] HEXSEG;

	HEXA SegA (HEXSEG[0], A, B, C, D);
	HEXB SegB (HEXSEG[1], A, B, C, D);
	HEXC SegC (HEXSEG[2], A, B, C, D);
	HEXD SegD (HEXSEG[3], A, B, C, D);
	HEXE SegE (HEXSEG[4], A, B, C, D);
	HEXF SegF (HEXSEG[5], A, B, C, D);
	HEXG SegG (HEXSEG[6], A, B, C, D);

endmodule