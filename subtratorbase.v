module subtratorbase (S, Bo, A, B, Bin);

	input A, B, Bin;
	output S, Bo;

	wire xor0, nxor0, nota, and0, and1;

	xor Xor0 (xor0, A, B);
	xor Xor1 (S, Bin, xor0);

	not NotXor0 (nxor0, xor0);
	not NotA (nota, A);

	and And0 (and0, nxor0, Bin);
	and And1 (and1, nota, B);

	or Or0 (Bo, and0, and1);
	
endmodule