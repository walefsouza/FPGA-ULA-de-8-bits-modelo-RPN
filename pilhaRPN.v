// ====================================================================
// MÓDULO: Pilha RPN - Lógica Correta com Memória Interna
// ====================================================================
module pilhaRPN (
    MuxSelA,
    Etapa, Reset_borda, Enter_borda, CLOCK // Adicionadas Entradas
);
    input [1:0] Etapa;
    input       Reset_borda;
    input       Enter_borda; // Necessário para saber quando a operação termina
    input       CLOCK;       // Necessário para o flip-flop interno

    output      MuxSelA;

    // --- Flag Interno (Memória) ---
    wire        primeira_op_concluida; // Saída do flip-flop
    wire        d_para_flag_ff;        // Entrada D do flip-flop
    wire        passo_eh_11;           // Fio para detectar Etapa = 11
    wire        set_flag_cond;         // Condição para setar o flag

    // Flip-flop para guardar o estado "primeira operação concluída"
    // Ele é setado para 1 quando a primeira operação termina (Etapa=11 + Enter)
    // Ele é resetado para 0 pelo Reset_borda
    flipflopbase FlagFF (
        .Q(primeira_op_concluida),
        .D(d_para_flag_ff),
        .CLOCK(CLOCK),
        .RESET(Reset_borda) // Usa o Reset_borda para zerar o flag
    );

    // Lógica para setar o flag: set_flag_cond = (Etapa == 11) AND Enter_borda
    and AndPasso11(passo_eh_11, Etapa[1], Etapa[0]);
    and AndSetFlag(set_flag_cond, passo_eh_11, Enter_borda);

    // Lógica da entrada D do flag: Mantém 1 uma vez setado, a menos que Reset
    // D = primeira_op_concluida OR set_flag_cond
    // (O Reset já é tratado pelo flipflopbase)
    or OrDFlag(d_para_flag_ff, primeira_op_concluida, set_flag_cond);

    // --- Lógica de Saída MuxSelA ---
    wire not_etapa0, not_etapa1, passo_eh_00;
    wire not_flag;
    wire condicao_manual_apos_reset;
    wire condicao_resultado_apos_ciclo;
    wire not_reset; // Precisamos do inverso do reset também

    not Not_E0_pilha(not_etapa0, Etapa[0]);
    not Not_E1_pilha(not_etapa1, Etapa[1]);
    and And_Passo00(passo_eh_00, not_etapa0, not_etapa1);
    not NotFlag(not_flag, primeira_op_concluida);
    not NotReset(not_reset, Reset_borda);

    // Condição para selecionar Manual após Reset no passo 00:
    // (passo_eh_00 AND NOT primeira_op_concluida)
    // (Não precisa checar Reset aqui, pois MuxSelA será forçado a 1 pelo Reset na OR final)
    and CondManual(condicao_manual_apos_reset, passo_eh_00, not_flag);

    // Condição para selecionar Resultado Anterior no passo 00:
    // (passo_eh_00 AND primeira_op_concluida AND NOT Reset_borda)
    // (Esta condição define quando MuxSelA deve ser 0)
    and CondResultado(condicao_resultado_apos_ciclo, passo_eh_00, primeira_op_concluida);
    // and CondResultadoFinal(condicao_resultado_apos_ciclo_final, condicao_resultado_apos_ciclo, not_reset); // Checagem de Reset redundante se usarmos a lógica abaixo

    // MuxSelA = NOT condicao_resultado_apos_ciclo_final
    // Ou mais simples: MuxSelA = 1 SE Reset_borda=1 OU Etapa!=00 OU (Etapa==00 E Flag==0)
    // MuxSelA = Reset_borda OR (NOT passo_eh_00) OR condicao_manual_apos_reset

    wire not_passo_00;
    not NotPasso00_Mux(not_passo_00, passo_eh_00);
    wire or_temp_mux;
    or OrTempMux(or_temp_mux, Reset_borda, not_passo_00);
    or OrMuxFinal(MuxSelA, or_temp_mux, condicao_manual_apos_reset);


endmodule