module somador4x4 (S, Co, A, B, Cin);

    input [3:0] A, B; 
    input Cin; 
	 
    output [3:0] S;
    output Co;
	 
    wire c1, c2, c3;

    // Instanciando o somador de 1 bit para cada bit
    somadorbase s0 (.A(A[0]), .B(B[0]), .Cin(Cin),  .S(S[0]), .Co(c1));
    somadorbase s1 (.A(A[1]), .B(B[1]), .Cin(c1),   .S(S[1]), .Co(c2));
    somadorbase s2 (.A(A[2]), .B(B[2]), .Cin(c2),   .S(S[2]), .Co(c3));
    somadorbase s3 (.A(A[3]), .B(B[3]), .Cin(c3),   .S(S[3]), .Co(Co));

endmodule
