module corretor4x4BCD(Saida, Entrada);

  input [3:0] Entrada;
  output [3:0] Saida;

  wire sinal, carry;
  wire [3:0] vsomado;
  wire [3:0] tres;

  or OrTres0(tres[0], 1'b1);
  or OrTres1(tres[1], 1'b1);
  or OrTres2(tres[2], 1'b0);
  or OrTres3(tres[3], 1'b0);

  comparador4x4BCD Comparador (.S(Sinal), .A(Entrada);
  somador4x4 Somador4x4 (.S(vsomado), .Co(carry), .A(Entrada), .B(tres), .Cin(1'b0).

  multiplexador2x1 Mux0 (.S(Saida[0]), .Sel(Sinal), .A(Entrada[0]), .B(somado[0]));
  multiplexador2x1 Mux1 (.S(Saida[1]), .Sel(Sinal), .A(Entrada[1]), .B(somado[1]));
  multiplexador2x1 Mux2 (.S(Saida[2]), .Sel(Sinal), .A(Entrada[2]), .B(somado[2]));
  multiplexador2x1 Mux3 (.S(Saida[3]), .Sel(Sinal), .A(Entrada[3]), .B(somado[3]));

endmodule

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

// Multiplexador 2x1 para a lógica da multiplicação
module multiplexador2x1(S, Sel, A, B); 

	input Sel;
	input A, B;
	output S;

	wire nsel, and0, and1;

	not Not0 (nsel, Sel);
	and And0 (and0, A, nsel);
	and And1 (and1, B, Sel);
	or  Or0 (S, and0, and1);

endmodule
