module somadorbase (S, Co, A, B, Cin);

	input A, B, Cin;
	output S, Co;
	
	wire xor0, and0, and1;
	
	xor Xor0 (xor0, A, B);
	xor Xor1 (S, Cin, xor0);
	
	
	and And0 (and0, xor0, Cin);
	and And1 (and1, A, B);
	
	or Or0 (Co, and0, and1);
	
endmodule
