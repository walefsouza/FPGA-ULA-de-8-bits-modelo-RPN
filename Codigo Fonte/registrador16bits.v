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
