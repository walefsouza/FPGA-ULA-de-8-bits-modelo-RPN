// ====================================================================
// COMPARADOR 8x8 — Saída "Igual" ativa se A == B
// Sendo essencial para a execução do multiplicador sequencial
// ====================================================================

module comparador8x8 (A, B, Igual);

    input  [7:0] A, B;
    output       Igual;

    // ================================================================
    // Fios internos (resultado dos XNORs e ANDs)
    // ================================================================

    wire xnor0, xnor1, xnor2, xnor3;
    wire xnor4, xnor5, xnor6, xnor7;
    wire and0, and1, and2, and3;
    wire and4, and5;
    wire and6;

    // ================================================================
    // Comparação bit a bit (XNOR)
    // ================================================================

    xnor Xnor0 (xnor0, A[0], B[0]);
    xnor Xnor1 (xnor1, A[1], B[1]);
    xnor Xnor2 (xnor2, A[2], B[2]);
    xnor Xnor3 (xnor3, A[3], B[3]);
    xnor Xnor4 (xnor4, A[4], B[4]);
    xnor Xnor5 (xnor5, A[5], B[5]);
    xnor Xnor6 (xnor6, A[6], B[6]);
    xnor Xnor7 (xnor7, A[7], B[7]);

    // ================================================================
    // Combinação dos resultados
    // ================================================================

    and And0 (and0, xnor0, xnor1);
    and And1 (and1, xnor2, xnor3);
    and And2 (and2, xnor4, xnor5);
    and And3 (and3, xnor6, xnor7);

    and And4 (and4, and0, and1);
    and And5 (and5, and2, and3);

    and And6 (and6, and4, and5);

    or OrFinal (Igual, and6, 1'b0);

endmodule