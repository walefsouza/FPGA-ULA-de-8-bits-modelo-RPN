// Registrador de 8 bits com controle de carga (LOAD_ENABLE)
module registrador8x8 (Q, D, CLOCK, RESET, ENABLE);

	output [7:0] Q;
	input [7:0] D;
	input CLOCK;
	input RESET;
	input ENABLE;

	wire [7:0] DADOSFF; // O que realmente vai para a entrada D dos flip-flops

	// Para cada bit, um MUX decide:
	// Se LOAD_ENABLE=0, a entrada do flip-flop é sua própria saída (MANTER).
	// Se LOAD_ENABLE=1, a entrada do flip-flop é o novo dado (CARREGAR).

	multiplexador2x1 Mux0 (.S(DADOSFF[0]), .Sel(ENABLE), .A(Q[0]), .B(D[0]));
	flipflopbase FF0  (.Q(Q[0]), .D(DADOSFF[0]), .CLOCK(CLOCK), .RESET(RESET));

	multiplexador2x1 Mux1 (.S(DADOSFF[1]), .Sel(ENABLE), .A(Q[1]), .B(D[1]));
	flipflopbase FF1  (.Q(Q[1]), .D(DADOSFF[1]), .CLOCK(CLOCK), .RESET(RESET));

	multiplexador2x1 Mux2 (.S(DADOSFF[2]), .Sel(ENABLE), .A(Q[2]), .B(D[2]));
	flipflopbase FF2  (.Q(Q[2]), .D(DADOSFF[2]), .CLOCK(CLOCK), .RESET(RESET));

	multiplexador2x1 Mux3 (.S(DADOSFF[3]), .Sel(ENABLE), .A(Q[3]), .B(D[3]));
	flipflopbase FF3  (.Q(Q[3]), .D(DADOSFF[3]), .CLOCK(CLOCK), .RESET(RESET));

	multiplexador2x1 Mux4 (.S(DADOSFF[4]), .Sel(ENABLE), .A(Q[4]), .B(D[4]));
	flipflopbase FF4  (.Q(Q[4]), .D(DADOSFF[4]), .CLOCK(CLOCK), .RESET(RESET));

	multiplexador2x1 Mux5 (.S(DADOSFF[5]), .Sel(ENABLE), .A(Q[5]), .B(D[5]));
	flipflopbase FF5  (.Q(Q[5]), .D(DADOSFF[5]), .CLOCK(CLOCK), .RESET(RESET));

	multiplexador2x1 Mux6 (.S(DADOSFF[6]), .Sel(ENABLE), .A(Q[6]), .B(D[6]));
	flipflopbase FF6  (.Q(Q[6]), .D(DADOSFF[6]), .CLOCK(CLOCK), .RESET(RESET));

	multiplexador2x1 Mux7 (.S(DADOSFF[7]), .Sel(ENABLE), .A(Q[7]), .B(D[7]));
	flipflopbase FF7  (.Q(Q[7]), .D(DADOSFF[7]), .CLOCK(CLOCK), .RESET(RESET));

	endmodule