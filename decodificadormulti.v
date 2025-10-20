// Módulo: Decodificador de Controle do Multiplicador (100% Estrutural)
module decodificadormulti (contagem, load_signal, calc_signal, done_signal);

    input  [3:0] contagem;    // A saída de 4 bits do nosso contador
    output       load_signal;   // Fica '1' quando a contagem for 0
    output       calc_signal;   // Fica '1' quando a contagem for de 1 a 8
    output       done_signal;   // Fica '1' quando a contagem for 9
    
    wire n0, n1, n2, n3; // Fios para os bits invertidos da contagem
    wire w_or_calc;

    // --- Inversores para a lógica de decodificação ---
    not Not0(n0, contagem[0]);
    not Not1(n1, contagem[1]);
    not Not2(n2, contagem[2]);
    not Not3(n3, contagem[3]);

    // --- Lógica para o sinal 'load_signal' ---
    // Ativo em '1' apenas quando a contagem é 0 (0000) -> n3 & n2 & n1 & n0
    and AndLoad(load_signal, n3, n2, n1, n0);
    
    // --- Lógica para o sinal 'done_signal' ---
    // Ativo em '1' apenas quando a contagem é 9 (1001) -> contagem[3] & n2 & n1 & contagem[0]
    and AndDone(done_signal, contagem[3], n2, n1, contagem[0]);

    // --- Lógica para o sinal 'calc_signal' ---
    // Ativo em '1' se NÃO for 'load' e NÃO for 'done' -> NOT (load_signal OR done_signal)
    or  OrCalc(w_or_calc, load_signal, done_signal);
    not NotCalc(calc_signal, w_or_calc);

endmodule