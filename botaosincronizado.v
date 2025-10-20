// ====================================================================
// MÓDULO: Sincronizador de Botão (Ativo-Low)
// ====================================================================

module botaosincronizado (
    entrada_raw, saida_borda, CLOCK, RESET
);
    input entrada_raw, CLOCK, RESET;
    output saida_borda;
    
    wire entrada_inv, entrada_sync1, entrada_sync2, entrada_anterior;
    
    not NotEntrada (entrada_inv, entrada_raw);
    
    flipflopbase FF1 (.Q(entrada_sync1), .D(entrada_inv), .CLOCK(CLOCK), .RESET(RESET));
    flipflopbase FF2 (.Q(entrada_sync2), .D(entrada_sync1), .CLOCK(CLOCK), .RESET(RESET));
    flipflopbase FF_delay (.Q(entrada_anterior), .D(entrada_sync2), .CLOCK(CLOCK), .RESET(RESET));
    
    wire not_anterior;
    not NotAnterior (not_anterior, entrada_anterior);
    and BordaDetector (saida_borda, entrada_sync2, not_anterior);

endmodule