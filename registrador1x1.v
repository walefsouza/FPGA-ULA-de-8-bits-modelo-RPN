module registrador1x1 (
    input CLOCK, RESET, ENABLE,
    input D,
    output Q
);
    wire D_mux;
    
    // MUX 2x1 para selecionar entrada do flip-flop
    // Se ENABLE=1: carrega novo valor (D)
    // Se ENABLE=0: realimenta valor anterior (Q)
    
    multiplexador2x1 MuxFF1 (
        .S(D_mux),
        .Sel(ENABLE),
        .A(Q),      // Se ENABLE=0: mantém Q
        .B(D)       // Se ENABLE=1: carrega D
    );
    
    flipflopbase FF1 (
        .Q(Q),
        .D(D_mux),
        .CLOCK(CLOCK),
        .RESET(RESET)
    );
endmodule