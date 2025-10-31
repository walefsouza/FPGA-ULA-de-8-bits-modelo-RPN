// ===================================================================
// Saturador de 8 bits para o multiplicador
// Se Overflow = 1, a saída será 255 (11111111). Se não, saída é Valor.
// O sinal de controle do multiplexador será o carry in (overflow).

module saturador8bits (
    Saida,     // Saída saturada de 8 bits
    Valor,     // Entrada de 8 bits (antes da saturação)
    Overflow   // Sinal de controle (Select do MUX)
);
    input [7:0] Valor;
    input       Overflow;
    output [7:0] Saida;

    wire GND, VCC;
    or OrGND(GND, 1'b0, 1'b0); // GND = 0
    not NotVCC(VCC, GND);      // VCC = 1
	 
    multiplexador2x1 Mux0 (.S(Saida[0]), .Sel(Overflow), .A(Valor[0]), .B(VCC));
    multiplexador2x1 Mux1 (.S(Saida[1]), .Sel(Overflow), .A(Valor[1]), .B(VCC));
    multiplexador2x1 Mux2 (.S(Saida[2]), .Sel(Overflow), .A(Valor[2]), .B(VCC));
    multiplexador2x1 Mux3 (.S(Saida[3]), .Sel(Overflow), .A(Valor[3]), .B(VCC));
    multiplexador2x1 Mux4 (.S(Saida[4]), .Sel(Overflow), .A(Valor[4]), .B(VCC));
    multiplexador2x1 Mux5 (.S(Saida[5]), .Sel(Overflow), .A(Valor[5]), .B(VCC));
    multiplexador2x1 Mux6 (.S(Saida[6]), .Sel(Overflow), .A(Valor[6]), .B(VCC));
    multiplexador2x1 Mux7 (.S(Saida[7]), .Sel(Overflow), .A(Valor[7]), .B(VCC));

endmodule