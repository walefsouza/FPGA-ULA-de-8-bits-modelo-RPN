// ====================================================================
// Pilha RPN - Memória de Primeira Operação Concluída
// ====================================================================
module pilhaRPN ( MuxSelA, Etapa, Reset_borda, LoadResultado, CLOCK);

    input [1:0] Etapa;
    input Reset_borda;      // Reset MANUAL (botão)
    input LoadResultado;    // Sinal de que operação terminou
    input CLOCK;

    output MuxSelA;

    // --- WIRES INTERNOS ---
    wire primeira_op_concluida;  // Flag: já concluiu pelo menos 1 operação
    wire d_flag;                  // Entrada D do flip-flop
    wire passo_eh_00;             // Indica se estamos no passo 00
    wire not_etapa0, not_etapa1;  // Negação dos bits da etapa
    wire not_reset;               // Negação do reset manual
    wire usar_resultado;          // Condição para usar resultado anterior
    wire temp_usar;               // Auxiliar intermediário para AND

    // =================================================================
    // DETECTA PASSO 00
    // =================================================================
    not Not_E0(not_etapa0, Etapa[0]);
    not Not_E1(not_etapa1, Etapa[1]);
    and And_Passo00(passo_eh_00, not_etapa0, not_etapa1);
    // passo_eh_00 = 1 quando Etapa = 2'b00

    // =================================================================
    // FLIP-FLOP DE MEMÓRIA
    // =================================================================
    // Seta quando LoadResultado ativa (operação terminou)
    // Reseta apenas com Reset_borda (botão manual)
    flipflopbase FlagMemoria (
        .Q(primeira_op_concluida),
        .D(d_flag),
        .CLOCK(CLOCK),
        .RESET(Reset_borda)
    );

    // D = primeira_op_concluida OR LoadResultado
    // Uma vez setado, permanece até reset manual
    or OrDFlag(d_flag, primeira_op_concluida, LoadResultado);

    // =================================================================
    // LÓGICA DO MUXSEL
    // =================================================================
    // MuxSelA = 1 → Usa entrada manual (chaves)
    // MuxSelA = 0 → Usa resultado anterior
    
    // NOT do reset para lógica condicional
    not NotReset(not_reset, Reset_borda);

    // Condição para usar resultado anterior:
    // (passo_eh_00 AND primeira_op_concluida AND NOT Reset_borda)
    and AndUsarTemp(temp_usar, passo_eh_00, primeira_op_concluida);
    and AndUsarRes(usar_resultado, temp_usar, not_reset);

    // MuxSelA é o inverso de usar resultado
    not NotMuxSel(MuxSelA, usar_resultado);

endmodule
