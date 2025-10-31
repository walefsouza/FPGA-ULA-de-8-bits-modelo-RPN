// ====================================================================
// Ativa o display RESTO somente quando o seletor for
// 011 (divisão) e a flag RESTO estiver ativa
// ====================================================================

module displayRESTO (
    output S,     // Saída ativa apenas se operação for RESTO e flag RESTO=1
    input  SEL2, 
    input  SEL1, 
    input  SEL0, 
    input  RESTO  // Flag de resto da divisão
);

    wire nSEL2;
    wire OpRESTO;

    // Inversor
    not NotSEL2(nSEL2, SEL2);

    // Detecta operação RESTO (011)
    and AndOpRESTO(OpRESTO, nSEL2, SEL1, SEL0);

    // Saída final depende também da flag RESTO
    and AndSaida(S, OpRESTO, RESTO);

endmodule
