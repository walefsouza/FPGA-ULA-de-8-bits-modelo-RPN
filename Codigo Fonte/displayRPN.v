module displayRPN (
	DisplayUnidade, DisplayDezena, DisplayCentena,
	Resultado, Base
	);
	input [7:0] Resultado;      // Resultado da ULA
	input [1:0] Base;           // Seleção de base (00=Dec, 01=Hex, 10=Oct)

	output [6:0] DisplayUnidade;    // Display das unidades (7 segmentos)
	output [6:0] DisplayDezena;     // Display das dezenas (7 segmentos)
	output [6:0] DisplayCentena;    // Display das centenas (7 segmentos)

	/* --- Wires de Saídas dos Conversores --- */

	/* Hexadecimal */
	wire [6:0] DisplayHexUnidade, DisplayHexDezena, DisplayHexCentena;

	/* Octal */
	wire [6:0] DisplayOctUnidade, DisplayOctDezena, DisplayOctCentena;

	/* Decimal (via BCD) - ZERADO POR ENQUANTO */
	wire [6:0] DisplayDecUnidade, DisplayDecDezena, DisplayDecCentena;
	wire [3:0] BCDUnidade, BCDDezena, BCDCentena;

	/* ===== CONVERSORES ===== */

	/* - - - CONVERSOR HEXADECIMAL - - - */

	/* Hexadecimal: nibble baixo (unidade) e nibble alto (dezena) */
	
	displayHEX DecoderHexUnidade (DisplayHexUnidade, Resultado[3], Resultado[2], Resultado[1], Resultado[0]);
	displayHEX DecoderHexDezena(DisplayHexDezena, Resultado[7], Resultado[6], Resultado[5], Resultado[4]);

	/* Centena Hex zerado */
	or OrHexCentena0 (DisplayHexCentena[0], 1'b0, 1'b0);
	or OrHexCentena1 (DisplayHexCentena[1], 1'b0, 1'b0);
	or OrHexCentena2 (DisplayHexCentena[2], 1'b0, 1'b0);
	or OrHexCentena3 (DisplayHexCentena[3], 1'b0, 1'b0);
	or OrHexCentena4 (DisplayHexCentena[4], 1'b0, 1'b0);
	or OrHexCentena5 (DisplayHexCentena[5], 1'b0, 1'b0);
	or OrHexCentena6 (DisplayHexCentena[6], 1'b1, 1'b1);
	

	/* - - - CONVERSOR OCTAL - - - */

	/* Octal: agrupa bits em grupos de 3 */
	
	displayOCT DecoderOctUnidade (DisplayOctUnidade, Resultado[2], Resultado[1], Resultado[0]);
	displayOCT DecoderOctDezena (DisplayOctDezena, Resultado[5], Resultado[4], Resultado[3]);
	displayOCT DecoderOctCentena (DisplayOctCentena, 1'b0, Resultado[7], Resultado[6]);

	/* - - - CONVERSOR DECIMAL (BCD) - ZERADO POR ENQUANTO - - - */
	
	doubleDabble8bits DoubleDabble (
		.Centenas(BCDCentena), 
		.Dezenas(BCDDezena), 
		.Unidades(BCDUnidade), 
		.Binario(Resultado)
	);
	
	displayDEC DecoderDecUnidade (DisplayDecUnidade, BCDUnidade[3], BCDUnidade[2], BCDUnidade[1], BCDUnidade[0]);
	displayDEC DecoderDecDezena (DisplayDecDezena, BCDDezena[3], BCDDezena[2], BCDDezena[1], BCDDezena[0]);
	displayDEC DecoderDecCentena (DisplayDecCentena, BCDCentena[3], BCDCentena[2], BCDCentena[1], BCDCentena[0]);

	/* ===== MULTIPLEXADORES 3:1 (Escolher qual base exibir) ===== */

	/* - - - MUX 3:1 PARA UNIDADE - - - */

	multiplexadordisplayRPN MuxUnidade (
		.Segmentos(DisplayUnidade),
		.Decimal(DisplayDecUnidade),
		.Octal(DisplayOctUnidade),
		.Hex(DisplayHexUnidade),
		.Base(Base)
	);

	/* - - - MUX 3:1 PARA DEZENA - - - */

	multiplexadordisplayRPN MuxDezena (
		.Segmentos(DisplayDezena),
		.Decimal(DisplayDecDezena),
		.Octal(DisplayOctDezena),
		.Hex(DisplayHexDezena),
		.Base(Base)
	);

	/* - - - MUX 3:1 PARA CENTENA - - - */

	multiplexadordisplayRPN MuxCentena (
		.Segmentos(DisplayCentena),
		.Decimal(DisplayDecCentena),
		.Octal(DisplayOctCentena),
		.Hex(DisplayHexCentena),
		.Base(Base)
	);
 
endmodule
