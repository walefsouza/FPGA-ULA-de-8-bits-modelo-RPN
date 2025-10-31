// ====================================================================
// Unidade Lógica Aritmética com sistema Reverse Polish Notation (RPN)
// ====================================================================

module ULARPN (
    // ----- Displays -----
    output [6:0] DisplayUnidade,
    output [6:0] DisplayDezena,
    output [6:0] DisplayCentena,
    output [6:0] DisplayRESTOU,
    output [6:0] DisplayRESTOD,
    output [6:0] DisplayRESTOC,
    
    // ----- LEDs -----
    output [4:0] LEDRPasso,
	 output [4:0] Flags, // Flags: Cout, Overflow, Zero, Erro, Resto
    
    // ----- Entradas -----
    input CLOCK,
    input RESET,
    input ENTER,
    input [9:0] SW
);

    // ====================================================================
    // WIRES GLOBAIS
    // ====================================================================
    wire LoadA, LoadB, LoadCarry, LoadOp, LoadResultado;
    wire Reset_borda, Enter_borda;
    wire GND;
    wire EnableContador;

    // ====================================================================
    // WIRES DE CONTROLE DE ETAPAS
    // ====================================================================
    wire [7:0] Etapa;           // Contador de etapas
    wire notetapa0, notetapa1;  // Inversores das etapas
	 wire AguardandoMult;

    // ====================================================================
    // WIRES DE REGISTRADORES DE DADOS
    // ====================================================================
    wire [7:0] RegA, RegB, RegResultado;
    wire [7:0] DadosA_mux, DadosB_mux;
    wire [2:0] DadosSel_mux;
	 wire [2:0] RegOp;
    wire DadosCarryIn_mux;
    wire [7:0] DadosA_final;
    wire CarryIn_reg;
    wire MuxSelA;

    // ====================================================================
    // WIRES DO RESULTADO FINAL
    // ====================================================================
    wire [7:0] SUla;
    wire [2:0] FlagsUla;
    wire FlagZero;
    
    // ----- RESTO DIVISÃO -----
    wire [7:0] RestoDiv;
    wire [7:0] MuxRestoDiv;
    wire [7:0] RegRestoDiv;
    wire temresto;

    // ====================================================================
    // WIRES DO MULTIPLICADOR
    // ====================================================================
    wire [7:0] ResultadoMult;
    wire OverflowMult;
    wire ProntoMult;
    wire StartMult;
    wire SelResultado;
    wire [7:0] ResultadoFinal;

    // ====================================================================
    // GND
    // ====================================================================
    or ORGND(GND, 1'b0, 1'b0);

    // ====================================================================
    // SINCRONIZAÇÃO DE BOTÕES
    // ====================================================================
    botaosincronizado BotaoReset (
        .entrada_raw(RESET),
        .saida_borda(Reset_borda),
        .CLOCK(CLOCK),
        .RESET(1'b0)
    );

    botaosincronizado BotaoEnter (
        .entrada_raw(ENTER),
        .saida_borda(Enter_borda),
        .CLOCK(CLOCK),
        .RESET(Reset_borda)
    );

    // ====================================================================
    // MULTIPLEXADOR DE ENTRADA
    // ====================================================================
    multiplexadorRPN Multiplexador_Entrada (
        .entrada_sw(SW),
        .contador(Etapa[1:0]),       // Usa apenas bits [1:0] para mux
        .saida_a(DadosA_mux),
        .saida_b(DadosB_mux),
        .saida_sel(DadosSel_mux),
        .saida_carry_in(DadosCarryIn_mux)
    );

    // ====================================================================
    // CONTADOR DE ETAPAS 8 BITS
    // ====================================================================
    wire reset_automatico;
    or OrResetAuto(reset_automatico, Reset_borda, LoadResultado);

    contador8bits ContadorRPN (
        .Q(Etapa),
        .CLOCK(CLOCK),
        .RESET(reset_automatico),
        .ENABLE(EnableContador)
    );

    // ====================================================================
    // DECODIFICADOR DE CONTROLE
    // ====================================================================

    decodificadorRPN DecodificadorRPN (
        .Contagem(Etapa),
        .Enter(Enter_borda),
        .Reset_borda(Reset_borda),
        .RegOp(RegOp),
        .ProntoMult(ProntoMult),
        .LoadA(LoadA),
        .LoadB(LoadB),
        .LoadCarry(LoadCarry),
        .LoadOp(LoadOp),
        .Resultado(LoadResultado),
        .Enable(EnableContador),
        .StartMult(StartMult),
        .SelResultado(SelResultado),
		  .AguardandoMult(AguardandoMult)
    );

    // ====================================================================
    // PILHA RPN
    // ====================================================================
    pilhaRPN Pilha (
        .MuxSelA(MuxSelA),
        .Etapa(Etapa[1:0]),
        .Reset_borda(Reset_borda),
        .LoadResultado(LoadResultado),
        .CLOCK(CLOCK)
    );

    // ====================================================================
    // MUX FINAL DE ENTRADA A
    // ====================================================================
    multiplexador2x1 MuxA0 (.S(DadosA_final[0]), .Sel(MuxSelA), .A(RegResultado[0]), .B(DadosA_mux[0]));
    multiplexador2x1 MuxA1 (.S(DadosA_final[1]), .Sel(MuxSelA), .A(RegResultado[1]), .B(DadosA_mux[1]));
    multiplexador2x1 MuxA2 (.S(DadosA_final[2]), .Sel(MuxSelA), .A(RegResultado[2]), .B(DadosA_mux[2]));
    multiplexador2x1 MuxA3 (.S(DadosA_final[3]), .Sel(MuxSelA), .A(RegResultado[3]), .B(DadosA_mux[3]));
    multiplexador2x1 MuxA4 (.S(DadosA_final[4]), .Sel(MuxSelA), .A(RegResultado[4]), .B(DadosA_mux[4]));
    multiplexador2x1 MuxA5 (.S(DadosA_final[5]), .Sel(MuxSelA), .A(RegResultado[5]), .B(DadosA_mux[5]));
    multiplexador2x1 MuxA6 (.S(DadosA_final[6]), .Sel(MuxSelA), .A(RegResultado[6]), .B(DadosA_mux[6]));
    multiplexador2x1 MuxA7 (.S(DadosA_final[7]), .Sel(MuxSelA), .A(RegResultado[7]), .B(DadosA_mux[7]));

    // ====================================================================
    // REGISTRADORES DE DADOS
    // ====================================================================
    registrador8x8 RegistradorA (
        .Q(RegA),
        .D(DadosA_final),
        .CLOCK(CLOCK),
        .RESET(Reset_borda),
        .ENABLE(LoadA)
    );

    registrador8x8 RegistradorB (
        .Q(RegB),
        .D(DadosB_mux),
        .CLOCK(CLOCK),
        .RESET(Reset_borda),
        .ENABLE(LoadB)
    );

    registrador8x8 RegistradorResultado (
        .Q(RegResultado),
        .D(ResultadoFinal),
        .CLOCK(CLOCK),
        .RESET(Reset_borda),
        .ENABLE(LoadResultado)
    );

    registrador1x1 RegistradorCarry (
        .Q(CarryIn_reg),
        .D(DadosCarryIn_mux),
        .CLOCK(CLOCK),
        .RESET(Reset_borda),
        .ENABLE(LoadCarry)
    );

    registrador1x1 RegistradorOp0 (
        .Q(RegOp[0]),
        .D(DadosSel_mux[0]),
        .CLOCK(CLOCK),
        .RESET(Reset_borda),
        .ENABLE(LoadOp)
    );

    registrador1x1 RegistradorOp1 (
        .Q(RegOp[1]),
        .D(DadosSel_mux[1]),
        .CLOCK(CLOCK),
        .RESET(Reset_borda),
        .ENABLE(LoadOp)
    );

    registrador1x1 RegistradorOp2 (
        .Q(RegOp[2]),
        .D(DadosSel_mux[2]),
        .CLOCK(CLOCK),
        .RESET(Reset_borda),
        .ENABLE(LoadOp)
    );

    // ====================================================================
    // ULA COMBINACIONAL
    // ====================================================================
    ula8bits Calculadora (
        .S(SUla),
        .Flags(FlagsUla),
        .Resto(RestoDiv),
        .A(RegA),
        .B(RegB),
        .Sel(RegOp),
        .Cin(CarryIn_reg)
    );

    // ====================================================================
    // MULTIPLICADOR SEQUENCIAL
    // ====================================================================
    multiplicador8x8 Multiplicador (
        .Resultado(ResultadoMult),
        .Overflow(OverflowMult),
        .Pronto(ProntoMult),
        .A(RegA),
        .B(RegB),
        .CLOCK(CLOCK),
        .RESET(Reset_borda),
        .START(StartMult)
    );

    // ====================================================================
    // MUX DE RESULTADO (ULA ou MULT)
    // ====================================================================
    multiplexador2x1 MuxRes0 (.S(ResultadoFinal[0]), .Sel(SelResultado), .A(SUla[0]), .B(ResultadoMult[0]));
    multiplexador2x1 MuxRes1 (.S(ResultadoFinal[1]), .Sel(SelResultado), .A(SUla[1]), .B(ResultadoMult[1]));
    multiplexador2x1 MuxRes2 (.S(ResultadoFinal[2]), .Sel(SelResultado), .A(SUla[2]), .B(ResultadoMult[2]));
    multiplexador2x1 MuxRes3 (.S(ResultadoFinal[3]), .Sel(SelResultado), .A(SUla[3]), .B(ResultadoMult[3]));
    multiplexador2x1 MuxRes4 (.S(ResultadoFinal[4]), .Sel(SelResultado), .A(SUla[4]), .B(ResultadoMult[4]));
    multiplexador2x1 MuxRes5 (.S(ResultadoFinal[5]), .Sel(SelResultado), .A(SUla[5]), .B(ResultadoMult[5]));
    multiplexador2x1 MuxRes6 (.S(ResultadoFinal[6]), .Sel(SelResultado), .A(SUla[6]), .B(ResultadoMult[6]));
    multiplexador2x1 MuxRes7 (.S(ResultadoFinal[7]), .Sel(SelResultado), .A(SUla[7]), .B(ResultadoMult[7]));

    // ====================================================================
    // FLAGS
    // ====================================================================
    flagzero FlagZeroResultado (.Z(FlagZero), .R(ResultadoFinal));

    registrador1x1 FlagCout (
        .Q(Flags[0]), 
        .D(FlagsUla[0]), 
        .CLOCK(CLOCK), 
        .RESET(Reset_borda), 
        .ENABLE(LoadResultado)
    );

    registrador1x1 FlagOverflow (
        .Q(Flags[1]), 
        .D(OverflowMult), 
        .CLOCK(CLOCK), 
        .RESET(Reset_borda), 
        .ENABLE(LoadResultado)
    );

    registrador1x1 FlagZeroReg (
        .Q(Flags[2]), 
        .D(FlagZero), 
        .CLOCK(CLOCK), 
        .RESET(Reset_borda), 
        .ENABLE(LoadResultado)
    );

    registrador1x1 FlagErro (
        .Q(Flags[3]), 
        .D(FlagsUla[1]), 
        .CLOCK(CLOCK), 
        .RESET(Reset_borda), 
        .ENABLE(LoadResultado)
    );

    registrador1x1 FlagResto (
        .Q(Flags[4]), 
        .D(FlagsUla[2]), 
        .CLOCK(CLOCK), 
        .RESET(Reset_borda), 
        .ENABLE(LoadResultado)
    );

    // ====================================================================
    // INDICADORES DE ESTADO (LEDs)
    // ====================================================================
    wire LEDA_temp, LEDResultado_temp;
    wire not_aguardando_mult;

    not NotEtapa0(notetapa0, Etapa[0]);
    not NotEtapa1(notetapa1, Etapa[1]);

    and LEDA_temp_and(LEDA_temp, notetapa0, notetapa1);
    and LEDA(LEDRPasso[0], LEDA_temp, MuxSelA);

    and LEDB(LEDRPasso[1], Etapa[0], notetapa1);
    and LEDOp(LEDRPasso[2], notetapa0, Etapa[1]);

    and LEDResultado_temp_and(LEDResultado_temp, Etapa[0], Etapa[1]);
    not NotAguardandoMult(not_aguardando_mult, aguardandoMult);
    and LEDResultado(LEDRPasso[3], LEDResultado_temp, not_aguardando_mult);

    or LEDAguardandoMult(LEDRPasso[4], aguardandoMult, 1'b0);

    // ====================================================================
    // MUX DO RESTO (RestoDiv ou 0)
    // ====================================================================
    displayRESTO SeTEmREsto (
        .S(temresto),
        .SEL2(RegOp[2]),
        .SEL1(RegOp[1]),
        .SEL0(RegOp[0]),
        .RESTO(FlagsUla[2])
    );
	 
    multiplexador2x1 MuxResto0 (.S(MuxRestoDiv[0]), .Sel(temresto), .A(1'b0), .B(RestoDiv[0]));
    multiplexador2x1 MuxResto1 (.S(MuxRestoDiv[1]), .Sel(temresto), .A(1'b0), .B(RestoDiv[1]));
    multiplexador2x1 MuxResto2 (.S(MuxRestoDiv[2]), .Sel(temresto), .A(1'b0), .B(RestoDiv[2]));
    multiplexador2x1 MuxResto3 (.S(MuxRestoDiv[3]), .Sel(temresto), .A(1'b0), .B(RestoDiv[3]));
    multiplexador2x1 MuxResto4 (.S(MuxRestoDiv[4]), .Sel(temresto), .A(1'b0), .B(RestoDiv[4]));
    multiplexador2x1 MuxResto5 (.S(MuxRestoDiv[5]), .Sel(temresto), .A(1'b0), .B(RestoDiv[5]));
    multiplexador2x1 MuxResto6 (.S(MuxRestoDiv[6]), .Sel(temresto), .A(1'b0), .B(RestoDiv[6]));
    multiplexador2x1 MuxResto7 (.S(MuxRestoDiv[7]), .Sel(temresto), .A(1'b0), .B(RestoDiv[7]));

    registrador8x8 RegistradorResto (
        .Q(RegRestoDiv),
        .D(MuxRestoDiv),
        .CLOCK(CLOCK),
        .RESET(Reset_borda),
        .ENABLE(LoadResultado)
    );

    // ====================================================================
    // DISPLAYS
    // ====================================================================
    displayRPN Display (
        .Resultado(RegResultado),
        .Base(SW[9:8]),
        .DisplayUnidade(DisplayUnidade),
        .DisplayDezena(DisplayDezena),
        .DisplayCentena(DisplayCentena)
    );

    displayRPN DisplayREsto (
        .Resultado(RegRestoDiv),
        .Base(SW[9:8]),
        .DisplayUnidade(DisplayRESTOU),
        .DisplayDezena(DisplayRESTOD),
        .DisplayCentena(DisplayRESTOC)
    );

endmodule
