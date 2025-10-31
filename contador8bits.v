// Módulo: Contador síncrono de 8 bits com enable e reset (Estrutural)
module contador8bits (
    Q,       // Saída de 8 bits da contagem
    CLOCK,
    RESET,
    ENABLE   // Se 1, conta. Se 0, para.
);
    output [7:0] Q;
    input        CLOCK;
    input        RESET;
    input        ENABLE;

    wire [7:0] DADOSFF; // Entradas D para os flip-flops
    wire [7:0] T;       // Sinais de Toggle (habilitação de inversão) para cada bit

    // --- Lógica de Toggle (T) ---
    // T[i] é 1 se ENABLE=1 e todos os bits Q[0] a Q[i-1] forem 1.
    // Usamos uma cadeia de ANDs para calcular isso eficientemente.

    or OrT0(T[0], ENABLE, 1'b0); // T[0] = ENABLE (usando OR como buffer)

    and AndT1(T[1], T[0], Q[0]);
    and AndT2(T[2], T[1], Q[1]);
    and AndT3(T[3], T[2], Q[2]);
    and AndT4(T[4], T[3], Q[3]);
    and AndT5(T[5], T[4], Q[4]);
    and AndT6(T[6], T[5], Q[5]);
    and AndT7(T[7], T[6], Q[6]);

    // --- Lógica da Entrada D (D = Q ^ T) ---
    // Calcula o próximo estado para cada bit.
    xor Xor0(DADOSFF[0], Q[0], T[0]);
    xor Xor1(DADOSFF[1], Q[1], T[1]);
    xor Xor2(DADOSFF[2], Q[2], T[2]);
    xor Xor3(DADOSFF[3], Q[3], T[3]);
    xor Xor4(DADOSFF[4], Q[4], T[4]);
    xor Xor5(DADOSFF[5], Q[5], T[5]);
    xor Xor6(DADOSFF[6], Q[6], T[6]);
    xor Xor7(DADOSFF[7], Q[7], T[7]);

    // --- Banco de Flip-Flops ---
    // Instancia os 8 flip-flops que armazenam o estado do contador.
    flipflopbase FF0 (.Q(Q[0]), .D(DADOSFF[0]), .CLOCK(CLOCK), .RESET(RESET));
    flipflopbase FF1 (.Q(Q[1]), .D(DADOSFF[1]), .CLOCK(CLOCK), .RESET(RESET));
    flipflopbase FF2 (.Q(Q[2]), .D(DADOSFF[2]), .CLOCK(CLOCK), .RESET(RESET));
    flipflopbase FF3 (.Q(Q[3]), .D(DADOSFF[3]), .CLOCK(CLOCK), .RESET(RESET));
    flipflopbase FF4 (.Q(Q[4]), .D(DADOSFF[4]), .CLOCK(CLOCK), .RESET(RESET));
    flipflopbase FF5 (.Q(Q[5]), .D(DADOSFF[5]), .CLOCK(CLOCK), .RESET(RESET));
    flipflopbase FF6 (.Q(Q[6]), .D(DADOSFF[6]), .CLOCK(CLOCK), .RESET(RESET));
    flipflopbase FF7 (.Q(Q[7]), .D(DADOSFF[7]), .CLOCK(CLOCK), .RESET(RESET));

endmodule