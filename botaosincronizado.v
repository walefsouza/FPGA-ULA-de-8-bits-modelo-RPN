// ====================================================================
// Sincronizador de Botão (Ativo-Low com Detecção de Borda)
// Função: Remove metaestabilidade e detecta borda de subida
// ====================================================================

module botaosincronizado (
    entrada_raw,    // Entrada do botão (ativo-low)
    saida_borda,    // Pulso de 1 ciclo na borda de subida
    CLOCK,          // Clock do sistema
    RESET           // Reset síncrono
);
    
    input  entrada_raw;
    input  CLOCK;
    input  RESET;
    output saida_borda;
    
    // =================================================================
    // WIRES INTERNOS
    // =================================================================
    wire entrada_invertida;     // Botão invertido 
    wire sinal_sync1;            // Primeiro estágio de sincronização
    wire sinal_sync2;            // Segundo estágio de sincronização
    wire sinal_atrasado;         // Sinal atrasado em 1 ciclo
    wire not_sinal_atrasado;  // Negação do sinal atrasado
    
	 // Invertendo sinal do botão
    not NotEntrada(entrada_invertida, entrada_raw);
    
   
    /* - - - Dois flip-flops em cascata para sincronizar com o clock - - - */

    // Primeiro estágio de sincronização
    flipflopbase FF_Sync1 (
        .Q(sinal_sync1),
        .D(entrada_invertida),
        .CLOCK(CLOCK),
        .RESET(RESET)
    );
    
    // Segundo estágio de sincronização (sinal estável)
    flipflopbase FF_Sync2 (
        .Q(sinal_sync2),
        .D(sinal_sync1),
        .CLOCK(CLOCK),
        .RESET(RESET)
    );
    
	 
	 /* - - - Criando versão atrasada em 1 ciclo para comparar a borda - - - */
    
    flipflopbase FF_Atraso (
        .Q(sinal_atrasado),
        .D(sinal_sync2),
        .CLOCK(CLOCK),
        .RESET(RESET)
    );
    
    /* - - - Detectando borda de subida do botão - - -
	 
    Borda detectada quando: sinal_sync2=1 E sinal_atrasado=0
    Isso ocorre por apenas 1 ciclo de clock
    */
	 
    not NotAtrasado(not_sinal_atrasado, sinal_atrasado);
    
    and DetectorBorda(saida_borda, sinal_sync2, not_sinal_atrasado);

endmodule