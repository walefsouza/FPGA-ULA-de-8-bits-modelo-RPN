// ====================================================================
// Decodificador do contador que recebe os sinais de controle e retorna 
// para qual registrador os bits devem ser direcionados (sinais de controle)
// ====================================================================

module decodificadorRPN(
    LoadA, LoadB, LoadCarry, LoadOp, Resultado, Enable,
    StartMult, SelResultado, AguardandoMult,
    Contagem, Enter, Reset_borda,
    RegOp, ProntoMult
);
    input [7:0] Contagem;
    input [2:0] RegOp;        // Operação registrada
    input       Enter;
    input       Reset_borda;
    input       ProntoMult;   // Sinal do multiplicador
    
    output      LoadA;
    output      LoadB;
    output      LoadCarry;
    output      LoadOp;
    output      Resultado;
    output      Enable;
    output      StartMult;    // Inicia multiplicador
    output      SelResultado; // 0=ULA, 1=Multiplicador
	 output 		 AguardandoMult;
    
    wire not0, not1, not2, not3, not4, not5, not6, not7;
    wire passo00, passo01, passo10, passo11;
    wire not_reset;
    wire ehMultiplicacao;
    wire enable_interno;
    
    // ===== INVERTORES DOS BITS DO CONTADOR =====
    not Not0 (not0, Contagem[0]);
    not Not1 (not1, Contagem[1]);
    not Not2 (not2, Contagem[2]);
    not Not3 (not3, Contagem[3]);
    not Not4 (not4, Contagem[4]);
    not Not5 (not5, Contagem[5]);
    not Not6 (not6, Contagem[6]);
    not Not7 (not7, Contagem[7]);
    not NotReset(not_reset, Reset_borda);
    
    // ===== DETECTORES DE PASSO (Apenas bits [1:0]) =====
    // Passo 00: Contagem[1:0] = 00
    and AndPasso00(passo00, not1, not0);
    // Passo 01: Contagem[1:0] = 01
    and AndPasso01(passo01, not1, Contagem[0]);
    // Passo 10: Contagem[1:0] = 10
    and AndPasso10(passo10, Contagem[1], not0);
    // Passo 11: Contagem[1:0] = 11
    and AndPasso11(passo11, Contagem[1], Contagem[0]);
    
    // ===== DETECÇÃO DE MULTIPLICAÇÃO =====
    // RegOp = 010 (Multiplicação)
    wire not_regop2, not_regop0;
    not NotRegOp2(not_regop2, RegOp[2]);
    not NotRegOp0(not_regop0, RegOp[0]);
    
    wire temp_mult;
    and AndMult1(temp_mult, not_regop2, RegOp[1]);
    and AndMult2(ehMultiplicacao, temp_mult, not_regop0);
    
    // ===== LÓGICA DE ESPERA PELA MULTIPLICAÇÃO =====
    // Aguardando = Estamos no passo 11, é multiplicação e multiplicador não terminou
    wire mult_nao_pronto;
    not NotProntoMult(mult_nao_pronto, ProntoMult);
    
    wire aguardando_temp;
    and AndAguard1(aguardando_temp, passo11, ehMultiplicacao);
    and AndAguard2(AguardandoMult, aguardando_temp, mult_nao_pronto);
    
    // ===== START DO MULTIPLICADOR =====
    // Ativa quando entra no passo 11 E é multiplicação E Enter pressionado
    wire start_temp;
    and AndStart1(start_temp, passo11, ehMultiplicacao);
    and AndStart2(StartMult, start_temp, Enter, not_reset);
    
    // ===== LOADS (COM CHECAGEM DE RESET E ESPERA) =====
    wire not_aguardando;
    not NotAguardando(not_aguardando, AguardandoMult);
    
    // LoadA: Passo 00 + Enter + Não aguardando
    and AndLoadA(LoadA, passo00, Enter, not_reset, not_aguardando);
    
    // LoadB: Passo 01 + Enter + Não aguardando
    and AndLoadB(LoadB, passo01, Enter, not_reset, not_aguardando);
    
    // LoadCarry/LoadOp: Passo 10 + Enter + Não aguardando
    and AndLoadCarry(LoadCarry, passo10, Enter, not_reset, not_aguardando);
    and AndLoadOp(LoadOp, passo10, Enter, not_reset, not_aguardando);
    
    // LoadResultado: Passo 11 + Enter + Não aguardando
    // OU (Passo 11 + É multiplicação + ProntoMult)
    wire resultado_normal, resultado_mult;
    and AndResNormal(resultado_normal, passo11, Enter, not_reset, not_aguardando);
    
    wire resultado_mult_temp;
    and AndResMult1(resultado_mult_temp, passo11, ehMultiplicacao);
    and AndResMult2(resultado_mult, resultado_mult_temp, ProntoMult, not_reset);
    
    or OrResultado(Resultado, resultado_normal, resultado_mult);
    
    // ===== ENABLE DO CONTADOR =====
    // Avança se: (Enter OU Reset) E NÃO está aguardando multiplicação
    or OrEnableTemp(enable_interno, Enter, Reset_borda);
    and AndEnable(Enable, enable_interno, not_aguardando);
    
    // ===== SELETOR DE RESULTADO =====
    // 0 = ULA normal, 1 = Multiplicador
    // Usa multiplicador se: É multiplicação E está no passo 11
    and AndSelRes(SelResultado, ehMultiplicacao, passo11);

endmodule
