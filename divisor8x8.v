
module divisor8x8 (E, Q, R, A, B);
    input [7:0] A, B; // DIVIDENDO E DIVISOR
    output [7:0] Q;   // QUOCIENTE FINAL
    output [7:0] R;   // RESTO FINAL
    output E;         // FLAG ERRO (DIVISAO POR ZERO)
    
    wire [7:0] R0, R1, R2, R3, R4, R5, R6; // RESTOS INTERMEDIARIOS
    wire Q7, Q6, Q5, Q4, Q3, Q2, Q1, Q0;   // BITS DO QUOCIENTE
    
    // =========================================================
    // FLAG ERRO: ATIVA SE DIVISOR = 00000000
    
    nor (E, B[7], B[6], B[5], B[4], B[3], B[2], B[1], B[0]);
    
    // =========================================================
    // ESTAGIOS DA DIVISAO
    
    estagiodivisao8x8 E0 (R0, Q7, 8'b00000000, A[7], B); // ESTAGIO 0
    estagiodivisao8x8 E1 (R1, Q6, R0, A[6], B);          // ESTAGIO 1
    estagiodivisao8x8 E2 (R2, Q5, R1, A[5], B);          // ESTAGIO 2
    estagiodivisao8x8 E3 (R3, Q4, R2, A[4], B);          // ESTAGIO 3
    estagiodivisao8x8 E4 (R4, Q3, R3, A[3], B);          // ESTAGIO 4
    estagiodivisao8x8 E5 (R5, Q2, R4, A[2], B);          // ESTAGIO 5
    estagiodivisao8x8 E6 (R6, Q1, R5, A[1], B);          // ESTAGIO 6
    estagiodivisao8x8 E7 (R, Q0, R6, A[0], B);           // ESTAGIO 7
    
    // =========================================================
    // MONTAR QUOCIENTE FINAL
    
    or (Q[7], Q7, 1'b0);
    or (Q[6], Q6, 1'b0);
    or (Q[5], Q5, 1'b0);
    or (Q[4], Q4, 1'b0);
    or (Q[3], Q3, 1'b0);
    or (Q[2], Q2, 1'b0);
    or (Q[1], Q1, 1'b0);
    or (Q[0], Q0, 1'b0);
	 
endmodule
