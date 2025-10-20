module ula8bits (S, Flags, Sel, A, B, Cin);

   input [7:0] A;
	input [7:0] B;
   input [2:0] Sel;
   input Cin; 
	
	output [4:0] Flags; //cout, overflow, zero, erro, resto, 
	output [7:0] S; 
	
	/* Flag Cout = Flags[0], 
	Overflow = Flags[1],
	Zero = Flags[2], 
	Erro = Flags[3], 
	Resto = Flags[4] */
	// =========================================================
	// FIOS AUXILIARES 
	
	
   wire Cout, Bout;
   wire [7:0] Soma, Sub, Div, Resto; //Multi, Div(com resto)
	wire [7:0] AndOp, OrOp, XorOp, NotOp;
	
	// Wires para as flags
	wire FlagZero, FlagCout, FlagErro;
	
	// =========================================================
	// OPEAÇÕES LÓGICAS E ARITMÉTICAS
	
	
   somador8x8       U_SOMA  (Soma, Cout, A, B, Cin);
   subtrator8x8     U_SUB   (Sub, Bout, A, B, Cin);
   //multiplicador4x4 U_MULTI (Multi, A, B); vai sair a flag de overflow
	divisor8x8		  U_DIV   (Erro, Div, Resto, A, B); //pensar no resto
   xor8bits         U_XOR   (XorOp, A, B);
   and8bits         U_AND   (AndOp, A, B);
   or8bits          U_OR    (OrOp, A, B);
	not8bits			  U_NOT   (NotOp, A, B);
	// =========================================================
	// MULTIPLEXADOR SELETOR DA OPERAÇÃO REPRESENTADA
	
   multiplexador8x8 U_MUX (S, Sel, Soma, Sub, 8'b0, Div, AndOp, OrOp, XorOp, NotOp);
	
	// RESUMO OPERAÇÕES:
	// 000 - soma;
	// 001 - subtração;
	// 010 - multiplicação;
	// 011 - divisão;
	// 100 - and;
	// 101 - or;
	// 110 - xor;
	// 111 - not.
	
	
	// =========================================================
	// FLAGS DO CIRCUITO: OVERFLOW, COUT/BOUT, ERRO, ZERO, RESTO
	
	// Flag Zero - verifica se resultado S é zero
	flagzero U_FLAGZ (FlagZero, S);
	
	// Flag Cout/Bout - verifica carry out (soma) ou borrow out (subtração)
	flagcout U_FLAGCOUT (FlagCout, Sel, Cout, Bout);
	
	// Flag Erro - verifica divisão por zero
	flagerro U_FLAGERRO (FlagErro, Sel, Erro);
	
	// =========================================================
	// SAÍDA DAS FLAGS (temporariamente, overflow e resto virão depois)
	
	or OrFlags0 (Flags[0], FlagCout, 1'b0);
	or OrFlags1 (Flags[1], 1'b0, 1'b0);      // Overflow (será preenchido depois)
	or OrFlags2 (Flags[2], FlagZero, 1'b0);
	or OrFlags3 (Flags[3], FlagErro, 1'b0);
	or OrFlags4 (Flags[4], 1'b0, 1'b0);      // Resto (será preenchido depois)
    
endmodule