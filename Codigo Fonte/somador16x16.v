module somador16x16 (S, Co, A, B, Cin);
	input [15:0] A, B; 
	input Cin; 
	output [15:0] S;
	output Co;
	wire C;
	
	// Instanciando dois somadores de 8 bits
	// Primeiro somador: bits menos significativos (0-7)
	somador8x8 s_low (.A(A[7:0]), .B(B[7:0]), .Cin(Cin), .S(S[7:0]), .Co(C));
	
	// Segundo somador: bits mais significativos (8-15)
	somador8x8 s_high (.A(A[15:8]), .B(B[15:8]), .Cin(C), .S(S[15:8]), .Co(Co));
	
endmodule
