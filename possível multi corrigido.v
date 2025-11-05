// ====================================================================
// MULTIPLICADOR 8x8 COM SATURAÇÃO - 16 BITS - 1 SOMADOR
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
    
    wire [7:0] Soma_Baixa;
    wire Cout_Baixa;
    
    wire Igual;
    wire NotIgual;
    wire Igual_Valido;      // ← NOVO: Igual só quando não está em START
    wire NotSTART;          // ← NOVO
    
    wire Saturou_Q;
    wire Saturou_D;
    wire Saturou_Enable;
    wire Saturou_Reset;
    
    wire GND;
    
    wire Operando_Q;
    wire Operando_D;
    wire Operando_Enable;
    wire Operando_Reset;
    
    or OrGND(GND, 1'b0, 1'b0);
    
    // ================================================================
    // FLIP-FLOP DE ESTADO "OPERANDO" (CORRIGIDO!)
    // ================================================================
    
    // Inverte START para criar janela de proteção
    not NotStartWire(NotSTART, START);
    
    // Igual só é válido quando NÃO está em START (evita race condition)
    and AndIgualValido(Igual_Valido, Igual, NotSTART);
    
    // Reset apenas por Igual_Valido (não durante START)
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
    // SOMADOR (Acumulador[7:0] + A)
    // ================================================================
    
    somador8x8 Somador (
        .S(Soma_Baixa),
        .Co(Cout_Baixa),
        .A(Acumulador_Q[7:0]),
        .B(A),
        .Cin(GND)
    );
    
    // ================================================================
    // PROPAGAÇÃO DO CARRY PARA OS BITS ALTOS (RIPPLE CARRY MANUAL)
    // ================================================================
    
    wire [7:0] Carry;
    
    // Carry[0] = Cout do somador baixo
    or OrCarry0(Carry[0], Cout_Baixa, GND);
    
    // Bit 8: Acum[8] + Carry[0] (Half-Adder)
    xor XorBit8(Acumulador_D[8], Acumulador_Q[8], Carry[0]);
    and AndCarry1(Carry[1], Acumulador_Q[8], Carry[0]);
    
    // Bit 9: Acum[9] + Carry[1]
    xor XorBit9(Acumulador_D[9], Acumulador_Q[9], Carry[1]);
    and AndCarry2(Carry[2], Acumulador_Q[9], Carry[1]);
    
    // Bit 10: Acum[10] + Carry[2]
    xor XorBit10(Acumulador_D[10], Acumulador_Q[10], Carry[2]);
    and AndCarry3(Carry[3], Acumulador_Q[10], Carry[2]);
    
    // Bit 11: Acum[11] + Carry[3]
    xor XorBit11(Acumulador_D[11], Acumulador_Q[11], Carry[3]);
    and AndCarry4(Carry[4], Acumulador_Q[11], Carry[3]);
    
    // Bit 12: Acum[12] + Carry[4]
    xor XorBit12(Acumulador_D[12], Acumulador_Q[12], Carry[4]);
    and AndCarry5(Carry[5], Acumulador_Q[12], Carry[4]);
    
    // Bit 13: Acum[13] + Carry[5]
    xor XorBit13(Acumulador_D[13], Acumulador_Q[13], Carry[5]);
    and AndCarry6(Carry[6], Acumulador_Q[13], Carry[5]);
    
    // Bit 14: Acum[14] + Carry[6]
    xor XorBit14(Acumulador_D[14], Acumulador_Q[14], Carry[6]);
    and AndCarry7(Carry[7], Acumulador_Q[14], Carry[6]);
    
    // Bit 15: Acum[15] + Carry[7]
    xor XorBit15(Acumulador_D[15], Acumulador_Q[15], Carry[7]);
    
    // ================================================================
    // ACUMULADOR D[7:0] = Resultado do somador
    // ================================================================
    
    or OrAcumD0(Acumulador_D[0], Soma_Baixa[0], GND);
    or OrAcumD1(Acumulador_D[1], Soma_Baixa[1], GND);
    or OrAcumD2(Acumulador_D[2], Soma_Baixa[2], GND);
    or OrAcumD3(Acumulador_D[3], Soma_Baixa[3], GND);
    or OrAcumD4(Acumulador_D[4], Soma_Baixa[4], GND);
    or OrAcumD5(Acumulador_D[5], Soma_Baixa[5], GND);
    or OrAcumD6(Acumulador_D[6], Soma_Baixa[6], GND);
    or OrAcumD7(Acumulador_D[7], Soma_Baixa[7], GND);
    
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
    
    or OrSaturou(Saturou_D, Saturou_Q, Ov7);
    or OrSaturouReset(Saturou_Reset, RESET, START);
    and AndSaturouEnable(Saturou_Enable, NotIgual, Operando_Q);
    
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



/*REG 16 BITS*/

// ====================================================================
// REGISTRADOR DE 16 BITS COM ENABLE (USANDO flipflopbase + MUX)
// ====================================================================

module registrador16bits (
    output [15:0] Q,
    input [15:0] D,
    input CLOCK,
    input RESET,
    input ENABLE
);
    
    wire [15:0] DADOSFF;
    
    // Bit 0
    multiplexador2x1 Mux0 (.S(DADOSFF[0]), .Sel(ENABLE), .A(Q[0]), .B(D[0]));
    flipflopbase FF0 (.Q(Q[0]), .D(DADOSFF[0]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 1
    multiplexador2x1 Mux1 (.S(DADOSFF[1]), .Sel(ENABLE), .A(Q[1]), .B(D[1]));
    flipflopbase FF1 (.Q(Q[1]), .D(DADOSFF[1]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 2
    multiplexador2x1 Mux2 (.S(DADOSFF[2]), .Sel(ENABLE), .A(Q[2]), .B(D[2]));
    flipflopbase FF2 (.Q(Q[2]), .D(DADOSFF[2]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 3
    multiplexador2x1 Mux3 (.S(DADOSFF[3]), .Sel(ENABLE), .A(Q[3]), .B(D[3]));
    flipflopbase FF3 (.Q(Q[3]), .D(DADOSFF[3]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 4
    multiplexador2x1 Mux4 (.S(DADOSFF[4]), .Sel(ENABLE), .A(Q[4]), .B(D[4]));
    flipflopbase FF4 (.Q(Q[4]), .D(DADOSFF[4]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 5
    multiplexador2x1 Mux5 (.S(DADOSFF[5]), .Sel(ENABLE), .A(Q[5]), .B(D[5]));
    flipflopbase FF5 (.Q(Q[5]), .D(DADOSFF[5]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 6
    multiplexador2x1 Mux6 (.S(DADOSFF[6]), .Sel(ENABLE), .A(Q[6]), .B(D[6]));
    flipflopbase FF6 (.Q(Q[6]), .D(DADOSFF[6]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 7
    multiplexador2x1 Mux7 (.S(DADOSFF[7]), .Sel(ENABLE), .A(Q[7]), .B(D[7]));
    flipflopbase FF7 (.Q(Q[7]), .D(DADOSFF[7]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 8
    multiplexador2x1 Mux8 (.S(DADOSFF[8]), .Sel(ENABLE), .A(Q[8]), .B(D[8]));
    flipflopbase FF8 (.Q(Q[8]), .D(DADOSFF[8]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 9
    multiplexador2x1 Mux9 (.S(DADOSFF[9]), .Sel(ENABLE), .A(Q[9]), .B(D[9]));
    flipflopbase FF9 (.Q(Q[9]), .D(DADOSFF[9]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 10
    multiplexador2x1 Mux10 (.S(DADOSFF[10]), .Sel(ENABLE), .A(Q[10]), .B(D[10]));
    flipflopbase FF10 (.Q(Q[10]), .D(DADOSFF[10]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 11
    multiplexador2x1 Mux11 (.S(DADOSFF[11]), .Sel(ENABLE), .A(Q[11]), .B(D[11]));
    flipflopbase FF11 (.Q(Q[11]), .D(DADOSFF[11]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 12
    multiplexador2x1 Mux12 (.S(DADOSFF[12]), .Sel(ENABLE), .A(Q[12]), .B(D[12]));
    flipflopbase FF12 (.Q(Q[12]), .D(DADOSFF[12]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 13
    multiplexador2x1 Mux13 (.S(DADOSFF[13]), .Sel(ENABLE), .A(Q[13]), .B(D[13]));
    flipflopbase FF13 (.Q(Q[13]), .D(DADOSFF[13]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 14
    multiplexador2x1 Mux14 (.S(DADOSFF[14]), .Sel(ENABLE), .A(Q[14]), .B(D[14]));
    flipflopbase FF14 (.Q(Q[14]), .D(DADOSFF[14]), .CLOCK(CLOCK), .RESET(RESET));
    
    // Bit 15
    multiplexador2x1 Mux15 (.S(DADOSFF[15]), .Sel(ENABLE), .A(Q[15]), .B(D[15]));
    flipflopbase FF15 (.Q(Q[15]), .D(DADOSFF[15]), .CLOCK(CLOCK), .RESET(RESET));

endmodule
