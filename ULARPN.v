module ULARPN (
    DisplayUnidade, DisplayDezena, DisplayCentena,
    /*LoadA, LoadB, LoadCarry, LoadOp, LoadResultado,*/
    RegResultado, RegA,
    CLOCK, Reset_raw, Enter_raw,
    SW
);
    input        CLOCK;
    input        Reset_raw;
    input        Enter_raw;
    input [9:0]  SW;

    wire [4:0] Flags;
    output [6:0] DisplayUnidade;
    output [6:0] DisplayDezena;
    output [6:0] DisplayCentena;
	 

    // Saídas de controle (registradas, após atraso)
    wire LoadA, LoadB, LoadCarry, LoadOp, LoadResultado;

    /* --- Wires de Sinais Sincronizados --- */
    wire Reset_borda;
    wire Enter_borda;

    /* --- Wires de Dados e Controle --- */
    wire GND;
    wire EnableContador;
    wire [1:0] Etapa;
    output [7:0] RegA;
    wire [7:0] RegB;
    output  [7:0] RegResultado;
    wire [7:0] SUla;
    wire [4:0] FlagsUla;

    wire [7:0] DadosA_mux, DadosB_mux;
    wire [2:0] DadosSel_mux;
    wire [2:0] RegOp;                // operação registrada
    wire DadosCarryIn_mux;           // Carry In do mux (passo 10)

    wire MuxSelA;
    wire [7:0] S;
    wire [7:0] DadosA_final;

    wire CarryIn_reg;                // Carry In registrado

    or ORGND (GND, 1'b0, 1'b0);

    /* - - - SINCRONIZAR BOTÕES (Gerar PULSOS na borda) - - - */
    botaosincronizado Botao_Reset (
        .entrada_raw(Reset_raw),
        .saida_borda(Reset_borda),
        .CLOCK(CLOCK),
        .RESET(1'b0)
    );

    botaosincronizado Botao_Enter (
        .entrada_raw(Enter_raw),
        .saida_borda(Enter_borda),
        .CLOCK(CLOCK),
        .RESET(Reset_borda)
    );

    /* - - - MULTIPLEXADOR DE ENTRADA (dados multiplexados no tempo) - - - */
    multiplexadorRPN Multiplexador_Entrada (
        .entrada_sw(SW),
        .contador(Etapa),
        .saida_a(DadosA_mux),
        .saida_b(DadosB_mux),
        .saida_sel(DadosSel_mux),
        .saida_carry_in(DadosCarryIn_mux)
    );

    /* - - - CONTADOR RPN - - - */
    contadorRPN ContadorRPN (
        .Q(Etapa),
        .CLOCK(CLOCK),
        .RESET(Reset_borda),
        .ENABLE(EnableContador)
    );
/* -----------------------------
   Decodificador RPN (combinacional)
   gera sinais _raw_ imediatos
   ----------------------------- */
	wire LoadA_raw, LoadB_raw, LoadCarry_raw, LoadOp_raw, LoadResultado_raw;
	wire Enable_raw;

	decodificadorRPN DecodificadorRPN (
    .Contagem(Etapa),
    .Enter(Enter_borda),
    .Reset_borda(Reset_borda), // <-- ADICIONAR ESTA LINHA/CONEXÃO
    .LoadA(LoadA),
    .LoadB(LoadB),
    // Se você decidiu registrar a Base/Carry/Op:
    .LoadCarry(LoadCarry),
    .LoadOp(LoadOp),
    // .LoadBase(LoadBase), // Se registrando a Base
    .Resultado(LoadResultado),
    .Enable(EnableContador)
);

	/* - - - Conexão estrutural (sem assign) - - - */
//	or OrEnableContador (EnableContador, Enable_raw, 1'b0);

	/* ---------------------------------------------------
	Pipeline simples: atrasar 1 ciclo os sinais de Load
	usando seu flipflopbase (um por sinal)
	--------------------------------------------------- */
	/*flipflopbase FF_LoadA       (.Q(LoadA),       .D(LoadA_raw),       .CLOCK(CLOCK), .RESET(Reset_borda));
	flipflopbase FF_LoadB       (.Q(LoadB),       .D(LoadB_raw),       .CLOCK(CLOCK), .RESET(Reset_borda));
	flipflopbase FF_LoadCarry   (.Q(LoadCarry),   .D(LoadCarry_raw),   .CLOCK(CLOCK), .RESET(Reset_borda));
	flipflopbase FF_LoadOp      (.Q(LoadOp),      .D(LoadOp_raw),      .CLOCK(CLOCK), .RESET(Reset_borda));
	flipflopbase FF_LoadResultado(.Q(LoadResultado), .D(LoadResultado_raw), .CLOCK(CLOCK), .RESET(Reset_borda));*/


    /* - - - LÓGICA DE PILHA RPN (MUX para escolher entrada A) - - - */
	pilhaRPN Pilha (
    .MuxSelA(MuxSelA),
    .Etapa(Etapa),
    .Reset_borda(Reset_borda),
    .Enter_borda(Enter_borda), // <-- ADICIONAR ESTA CONEXÃO
    .CLOCK(CLOCK)              // <-- ADICIONAR ESTA CONEXÃO
);

    /* - - - MUX FINAL DE ENTRADA A - - - */
    multiplexador2x1 MuxA0 (.S(DadosA_final[0]), .Sel(MuxSelA), .A(RegResultado[0]), .B(DadosA_mux[0]));
    multiplexador2x1 MuxA1 (.S(DadosA_final[1]), .Sel(MuxSelA), .A(RegResultado[1]), .B(DadosA_mux[1]));
    multiplexador2x1 MuxA2 (.S(DadosA_final[2]), .Sel(MuxSelA), .A(RegResultado[2]), .B(DadosA_mux[2]));
    multiplexador2x1 MuxA3 (.S(DadosA_final[3]), .Sel(MuxSelA), .A(RegResultado[3]), .B(DadosA_mux[3]));
    multiplexador2x1 MuxA4 (.S(DadosA_final[4]), .Sel(MuxSelA), .A(RegResultado[4]), .B(DadosA_mux[4]));
    multiplexador2x1 MuxA5 (.S(DadosA_final[5]), .Sel(MuxSelA), .A(RegResultado[5]), .B(DadosA_mux[5]));
    multiplexador2x1 MuxA6 (.S(DadosA_final[6]), .Sel(MuxSelA), .A(RegResultado[6]), .B(DadosA_mux[6]));
    multiplexador2x1 MuxA7 (.S(DadosA_final[7]), .Sel(MuxSelA), .A(RegResultado[7]), .B(DadosA_mux[7]));

    /* - - - BLOCO COM REGISTRADORES DE DADOS (A, B, RESULTADO) - - - */
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
        .D(SUla),
        .CLOCK(CLOCK),
        .RESET(Reset_borda),
        .ENABLE(LoadResultado)
    );

    /* - - - REGISTRADORES DE CONTROLE (CARRY + OPERAÇÃO) - - - */
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

    /* - - - ULA QUE CALCULA OS RESULTADOS - - - */
    ula8bits Calculadora (
        .S(SUla),
        .Flags(FlagsUla),
        .A(RegA),
        .B(RegB),
        .Sel(RegOp),
        .Cin(CarryIn_reg)
    );

    /* - - - CONEXÃO DAS SAÍDAS FINAIS - - - */
    or OrFlag0 (Flags[0], FlagsUla[0], GND);
    or OrFlag1 (Flags[1], FlagsUla[1], GND);
    or OrFlag2 (Flags[2], FlagsUla[2], GND);
    or OrFlag3 (Flags[3], FlagsUla[3], GND);
    or OrFlag4 (Flags[4], FlagsUla[4], GND);

    /* - - - BCD, DOUBBLE DABBLE, MUX DISPLAY - - - */
    displayRPN Display (
        .Resultado(RegResultado),
        .Base(SW[9:8]),
        .DisplayUnidade(DisplayUnidade),
        .DisplayDezena(DisplayDezena),
        .DisplayCentena(DisplayCentena)
    );

endmodule
