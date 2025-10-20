// Módulo: Decodificador de Controle RPN (O Cérebro) - Correção Prioridade Reset
module decodificadorRPN(
    LoadA, LoadB, LoadCarry, LoadOp, Resultado, Enable,
    Contagem, Enter, Reset_borda // <-- Precisa desta entrada
);
    input [1:0] Contagem;
    input       Enter;
    input       Reset_borda; // <-- Entrada necessária

    output      LoadA;
    output      LoadB;
    output      LoadCarry;
    output      LoadOp;
    output      Resultado;
    output      Enable;

    wire not0, not1;
    wire passo00, passo01, passo10, passo11;
    wire not_reset; // <-- Fio para o reset invertido

    // ===== INVERTORES =====
    not Not0 (not0, Contagem[0]);
    not Not1 (not1, Contagem[1]);
    not NotReset(not_reset, Reset_borda); // <-- INVERTE O RESET

    // ===== DETECTORES DE PASSO =====
    and AndPasso00(passo00, not1, not0);
    and AndPasso01(passo01, not1, Contagem[0]);
    and AndPasso10(passo10, Contagem[1], not0);
    and AndPasso11(passo11, Contagem[1], Contagem[0]);

    // ===== LÓGICA DAS SAÍDAS (COM CHECAGEM DE RESET) =====
    // Load só pode acontecer se Enter for pressionado E Reset NÃO estiver ativo
    and AndLoadA(LoadA, passo00, Enter, not_reset); // <-- Adicionado not_reset
    and AndLoadB(LoadB, passo01, Enter, not_reset); // <-- Adicionado not_reset
    and AndLoadCarry(LoadCarry, passo10, Enter, not_reset); // <-- Adicionado not_reset
    and AndLoadOp(LoadOp, passo10, Enter, not_reset); // <-- Adicionado not_reset
    and AndLoadResultado(Resultado, passo11, Enter, not_reset); // <-- Adicionado not_reset

    // ===== LÓGICA PARA Enable =====
    // O contador pode avançar mesmo durante o reset (para ir para 00) ou com Enter
    or OrEnable (Enable, Enter, Reset_borda); // <-- Enable ativo com Enter OU Reset

endmodule