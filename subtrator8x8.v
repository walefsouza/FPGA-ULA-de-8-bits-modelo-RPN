module subtrator8x8 (S, Bout, A, B, Bin);

	input [7:0] A, B; 
	input Bin; 
	output [7:0] S;
	output Bout;

	wire [6:0] Bo;

	// Instanciando o subtrator de 1 bit para cada bit
	subtratorbase s0 (.A(A[0]), .B(B[0]), .Bin(Bin),     .S(S[0]), .Bo(Bo[0]));
	subtratorbase s1 (.A(A[1]), .B(B[1]), .Bin(Bo[0]),   .S(S[1]), .Bo(Bo[1]));
	subtratorbase s2 (.A(A[2]), .B(B[2]), .Bin(Bo[1]),   .S(S[2]), .Bo(Bo[2]));
	subtratorbase s3 (.A(A[3]), .B(B[3]), .Bin(Bo[2]),   .S(S[3]), .Bo(Bo[3]));
	subtratorbase s4 (.A(A[4]), .B(B[4]), .Bin(Bo[3]),   .S(S[4]), .Bo(Bo[4]));
	subtratorbase s5 (.A(A[5]), .B(B[5]), .Bin(Bo[4]),   .S(S[5]), .Bo(Bo[5]));
	subtratorbase s6 (.A(A[6]), .B(B[6]), .Bin(Bo[5]),   .S(S[6]), .Bo(Bo[6]));
	subtratorbase s7 (.A(A[7]), .B(B[7]), .Bin(Bo[6]),   .S(S[7]), .Bo(Bout));

endmodule