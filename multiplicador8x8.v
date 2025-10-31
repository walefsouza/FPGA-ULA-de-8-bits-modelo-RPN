// ====================================================================
// MULTIPLICADOR 8x8 COM SATURAÇÃO - VERSÃO CORRIGIDA
// ====================================================================

module multiplicador8x8 (
    Resultado,     
    Overflow,      
    Pronto,        
    A, B,          
    CLOCK, RESET, START
);
    input [7:0] A, B;
    input CLOCK;
    input RESET;
    input START;
    
    output [7:0] Resultado;
    output Overflow;
    output Pronto;
    
    // ================================================================
    // WIRES INTERNOS
    // ================================================================
    
    wire [7:0] Contador_Q;
    wire Contador_Enable;
    wire Contador_Reset;
    
    wire [8:0] Acumulador_Q;
    wire [8:0] Acumulador_D;
    wire Acumulador_Enable;
    wire Acumulador_Reset;
    
    wire [7:0] Soma;
    wire Cout;
    
    wire Igual;
    wire NotIgual;
    
    wire Saturou_Q;
    wire Saturou_D;
    wire Saturou_Enable;
    
    wire GND;
    
    wire Operando_Q;      // 1 = Multiplicação em andamento
    wire Operando_D;      // Próximo estado
    wire Operando_Enable;
    wire Operando_Reset;
    
    or OrGND(GND, 1'b0, 1'b0);
    
    // ================================================================
    // ✅ FLIP-FLOP DE ESTADO "OPERANDO"
    // ================================================================
    // Setado quando START=1
    // Resetado quando Pronto=1 (Contador==B)
    
    // RESET quando o usuário apertar o botão ou quando termina multiplicação
    or OrOperandoReset(Operando_Reset, RESET, Igual);
    
    // D = START ou Operando_Q (mantém 1 após START até reset)
    or OrOperandoD(Operando_D, START, Operando_Q);
    
    or OrOperandoEnable(Operando_Enable, 1'b1, GND);
    
    registrador1x1 EstadoOperando (
        .Q(Operando_Q),
        .D(Operando_D),
        .CLOCK(CLOCK),
        .RESET(Operando_Reset),
        .ENABLE(Operando_Enable)
    );
    
    // ================================================================
    // CONTADOR (conta de 0 até B)
    // ================================================================
    
    // Reset do contador: START ativa o reset
    or OrContadorReset(Contador_Reset, RESET, START);
    
    not NotIgual_wire(NotIgual, Igual);
    and AndContadorEnable(Contador_Enable, NotIgual, Operando_Q);
    
    contador8bits Contador (
        .Q(Contador_Q),
        .CLOCK(CLOCK),
        .RESET(Contador_Reset),
        .ENABLE(Contador_Enable)
    );
    
    // ================================================================
    // COMPARADOR (verifica se Contador == B)
    // ================================================================
    
    comparador8x8 Comparador (
        .A(Contador_Q),
        .B(B),
        .Igual(Igual)
    );
    
    // Pronto = Contador == B
    or OrPronto(Pronto, Igual, GND);
    
    // ================================================================
    // SOMADOR (Acumulador[7:0] + A)
    // ================================================================
    
    somador8x8 Somador (
        .S(Soma),
        .Co(Cout),
        .A(Acumulador_Q[7:0]),
        .B(A),
        .Cin(GND)
    );
    
    // ================================================================
    // ACUMULADOR
    // ================================================================
    
    or OrAcumuladorReset(Acumulador_Reset, RESET, START);
    
    and AndAcumuladorEnable(Acumulador_Enable, NotIgual, Operando_Q);
    
    or OrAcumD0(Acumulador_D[0], Soma[0], GND);
    or OrAcumD1(Acumulador_D[1], Soma[1], GND);
    or OrAcumD2(Acumulador_D[2], Soma[2], GND);
    or OrAcumD3(Acumulador_D[3], Soma[3], GND);
    or OrAcumD4(Acumulador_D[4], Soma[4], GND);
    or OrAcumD5(Acumulador_D[5], Soma[5], GND);
    or OrAcumD6(Acumulador_D[6], Soma[6], GND);
    or OrAcumD7(Acumulador_D[7], Soma[7], GND);
    or OrAcumD8(Acumulador_D[8], Cout, GND);
    
    registrador9bits Acumulador (
        .Q(Acumulador_Q),
        .D(Acumulador_D),
        .CLOCK(CLOCK),
        .RESET(Acumulador_Reset),
        .ENABLE(Acumulador_Enable)
    );
    
    // ================================================================
    // FLAG DE SATURAÇÃO
    // ================================================================
    
    or OrSaturou(Saturou_D, Saturou_Q, Acumulador_Q[8]);
    
    and AndSaturouEnable(Saturou_Enable, NotIgual, Operando_Q);
    
    registrador1x1 FlagSaturacao (
        .Q(Saturou_Q),
        .D(Saturou_D),
        .CLOCK(CLOCK),
        .RESET(Acumulador_Reset),
        .ENABLE(Saturou_Enable)
    );
    
    or OrOverflow(Overflow, Saturou_Q, GND);
    
    // ================================================================
    // SATURADOR
    // ================================================================
    
    saturador8bits Saturador (
        .Saida(Resultado),
        .Valor(Acumulador_Q[7:0]),
        .Overflow(Saturou_Q)
    );

endmodule