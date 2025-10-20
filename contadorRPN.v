module contadorRPN (Q, CLOCK, RESET, ENABLE);

	output [1:0] Q;      // Saída de 2 bits da contagem (Passo 00, 01, 10, 11)
	input CLOCK;
	input RESET;
	input ENABLE; // Se 1, avança para o próximo passo

    wire [1:0] DADOSFF;
    wire T0, T1;

    // Lógica de Toggle (inversão)
    or Or0 (T0, ENABLE, 1'b0);                  // O bit 0 sempre tenta inverter quando habilitado
    and And0 (T1, T0, Q[0]);                // O bit 1 só tenta inverter se o bit 0 for '1'

    // Lógica da entrada de cada Flip-Flop
    xor Xor0 (DADOSFF[0], Q[0], T0);
    xor Xor1 (DADOSFF[1], Q[1], T1);

    // Instanciamos os 2 flip-flops
    flipflopbase flipflop0 (.Q(Q[0]), .D(DADOSFF[0]), .CLOCK(CLOCK), .RESET(RESET));
    flipflopbase flipflop1 (.Q(Q[1]), .D(DADOSFF[1]), .CLOCK(CLOCK), .RESET(RESET));

endmodule