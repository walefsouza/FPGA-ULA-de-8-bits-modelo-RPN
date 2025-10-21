module corretor4x4BCD(Saida, Entrada);
	
	input [3:0] Entrada;
	output [3:0] Saida;
	
	wire sinal, carry;
	wire [3:0] vsomado;
	wire [3:0] tres;

	// --- Gerar Constantes 0 (GND) e 1 (VCC) Estruturalmente ---
	wire GND, VCC;
	or OrGND(GND, 1'b0, 1'b0); // GND = 0
	not NotVCC(VCC, GND);      // VCC = 1
	
	// --- Definir Constante 3 (0011) ---
	// Conecta tres[0] e tres[1] a VCC, tres[2] e tres[3] a GND
	or OrTres0(tres[0], VCC, GND); // tres[0] = 1 | 0 = 1
	or OrTres1(tres[1], VCC, GND); // tres[1] = 1 | 0 = 1
	or OrTres2(tres[2], GND, GND); // tres[2] = 0 | 0 = 0
	or OrTres3(tres[3], GND, GND); // tres[3] = 0 | 0 = 0

	comparador4x4BCD Comparador (.S(Sinal), .A(Entrada);
	somador4x4 Somando3 (.S(vsomado), .Co(carry), .A(Entrada), .B(tres), .Cin(1'b0).
	
	// --- Selecionar Saida com MUXes ---
	// Se sinal=0 (Entrada<5), seleciona A (Entrada).
	// Se sinal=1 (Entrada>=5), seleciona B (vsomado = Entrada+3).
	
	multiplexador2x1 Mux0 (.S(Saida[0]), .Sel(Sinal), .A(Entrada[0]), .B(vsomado[0]));
	multiplexador2x1 Mux1 (.S(Saida[1]), .Sel(Sinal), .A(Entrada[1]), .B(vsomado[1]));
	multiplexador2x1 Mux2 (.S(Saida[2]), .Sel(Sinal), .A(Entrada[2]), .B(vsomado[2]));
	multiplexador2x1 Mux3 (.S(Saida[3]), .Sel(Sinal), .A(Entrada[3]), .B(vsomado[3]));

endmodule
