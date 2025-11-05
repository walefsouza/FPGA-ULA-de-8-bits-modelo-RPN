// ====================================================================
// MULTIPLICADOR 8x8 COM SATURAÇÃO 
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
    
    wire [15:0] Acumulador_Q;
    wire [15:0] Acumulador_D;
    wire Acumulador_Enable;
    wire Acumulador_Reset;
    
    wire [15:0] Soma_16bits;
    wire Cout_16bits;
    wire [15:0] A_Extendido;
    
    wire Igual;
    wire NotIgual;
    wire Igual_Valido;
    wire NotSTART;
    
    wire Saturou_Q;
    wire Saturou_D;
    wire Saturou_Enable;
    wire Saturou_Enable_Durante;
    wire Saturou_Enable_Final;
    wire Saturou_Reset;
    
    wire GND;
    
    wire Operando_Q;
    wire Operando_D;
    wire Operando_Enable;
    wire Operando_Reset;
    
    or OrGND(GND, 1'b0, 1'b0);
    
    or OrA0(A_Extendido[0], A[0], GND);
    or OrA1(A_Extendido[1], A[1], GND);
    or OrA2(A_Extendido[2], A[2], GND);
    or OrA3(A_Extendido[3], A[3], GND);
    or OrA4(A_Extendido[4], A[4], GND);
    or OrA5(A_Extendido[5], A[5], GND);
    or OrA6(A_Extendido[6], A[6], GND);
    or OrA7(A_Extendido[7], A[7], GND);
    or OrA8(A_Extendido[8], GND, GND);
    or OrA9(A_Extendido[9], GND, GND);
    or OrA10(A_Extendido[10], GND, GND);
    or OrA11(A_Extendido[11], GND, GND);
    or OrA12(A_Extendido[12], GND, GND);
    or OrA13(A_Extendido[13], GND, GND);
    or OrA14(A_Extendido[14], GND, GND);
    or OrA15(A_Extendido[15], GND, GND);
    
    // ================================================================
    // FLIP-FLOP DE ESTADO "OPERANDO"
    // ================================================================
    
    not NotStartWire(NotSTART, START);
    and AndIgualValido(Igual_Valido, Igual, NotSTART);
    or OrOperandoReset(Operando_Reset, RESET, Igual_Valido);
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
    
    or OrPronto(Pronto, Igual, GND);
    
    // ================================================================
    // SOMADOR 16 BITS 
    // ================================================================
    
    somador16x16 Somador (
        .S(Soma_16bits),
        .Co(Cout_16bits),
        .A(Acumulador_Q),
        .B(A_Extendido),
        .Cin(GND)
    );
    
    // ================================================================
    // ACUMULADOR D = Resultado do somador 16 bits
    // ================================================================
    
    or OrAcumD0(Acumulador_D[0], Soma_16bits[0], GND);
    or OrAcumD1(Acumulador_D[1], Soma_16bits[1], GND);
    or OrAcumD2(Acumulador_D[2], Soma_16bits[2], GND);
    or OrAcumD3(Acumulador_D[3], Soma_16bits[3], GND);
    or OrAcumD4(Acumulador_D[4], Soma_16bits[4], GND);
    or OrAcumD5(Acumulador_D[5], Soma_16bits[5], GND);
    or OrAcumD6(Acumulador_D[6], Soma_16bits[6], GND);
    or OrAcumD7(Acumulador_D[7], Soma_16bits[7], GND);
    or OrAcumD8(Acumulador_D[8], Soma_16bits[8], GND);
    or OrAcumD9(Acumulador_D[9], Soma_16bits[9], GND);
    or OrAcumD10(Acumulador_D[10], Soma_16bits[10], GND);
    or OrAcumD11(Acumulador_D[11], Soma_16bits[11], GND);
    or OrAcumD12(Acumulador_D[12], Soma_16bits[12], GND);
    or OrAcumD13(Acumulador_D[13], Soma_16bits[13], GND);
    or OrAcumD14(Acumulador_D[14], Soma_16bits[14], GND);
    or OrAcumD15(Acumulador_D[15], Soma_16bits[15], GND);
    
    // ================================================================
    // REGISTRADOR DE 16 BITS
    // ================================================================
    
    or OrAcumuladorReset(Acumulador_Reset, RESET, START);
    and AndAcumuladorEnable(Acumulador_Enable, NotIgual, Operando_Q);
    
    registrador16bits Acumulador (
        .Q(Acumulador_Q),
        .D(Acumulador_D),
        .CLOCK(CLOCK),
        .RESET(Acumulador_Reset),
        .ENABLE(Acumulador_Enable)
    );
    
    // ================================================================
    // DETECÇÃO DE OVERFLOW (qualquer bit 8-15 setado)
    // ================================================================
    
    wire Ov1, Ov2, Ov3, Ov4, Ov5, Ov6, Ov7;
    
    or OrOv1(Ov1, Acumulador_Q[8], Acumulador_Q[9]);
    or OrOv2(Ov2, Acumulador_Q[10], Acumulador_Q[11]);
    or OrOv3(Ov3, Acumulador_Q[12], Acumulador_Q[13]);
    or OrOv4(Ov4, Acumulador_Q[14], Acumulador_Q[15]);
    
    or OrOv5(Ov5, Ov1, Ov2);
    or OrOv6(Ov6, Ov3, Ov4);
    or OrOv7(Ov7, Ov5, Ov6);
    
    // ================================================================
    // FLAG DE SATURAÇÃO
    // ================================================================
    
    // Enable durante as operações normais
    and AndSaturouEnable1(Saturou_Enable_Durante, NotIgual, Operando_Q);
    
    // Enable no ciclo final (quando Igual acabou de ficar 1)
    and AndSaturouEnable2(Saturou_Enable_Final, Igual, Operando_Q);
    
    // Enable total = durante OU no final
    or OrSaturouEnable(Saturou_Enable, Saturou_Enable_Durante, Saturou_Enable_Final);
    
    or OrSaturou(Saturou_D, Saturou_Q, Ov7);
    or OrSaturouReset(Saturou_Reset, RESET, START);
    
    registrador1x1 FlagSaturacao (
        .Q(Saturou_Q),
        .D(Saturou_D),
        .CLOCK(CLOCK),
        .RESET(Saturou_Reset),
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
