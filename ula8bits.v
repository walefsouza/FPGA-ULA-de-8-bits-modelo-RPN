module ula8bits (S, Flags, Resto, Sel, A, B, Cin);

	input [7:0] A;
	input [7:0] B;
	input [2:0] Sel;
	input Cin; 
	
	output [2:0] Flags; //cout, erro, resto, 
	output [7:0] S; 
	output [7:0] Resto;
	
	// =========================================================
	// FIOS AUXILIARES 
	
	
   wire Cout, Bout, Erro, TemResto;
   wire [7:0] Soma, Sub, Div; 
	wire [7:0] AndOp, OrOp, XorOp, NotOp;
	wire FlagZero, FlagCout, FlagErro, FlagResto;
	
	// =========================================================
	// OPEAÇÕES LÓGICAS E ARITMÉTICAS
	
	
   somador8x8       U_SOMA  (Soma, Cout, A, B, Cin);
   subtrator8x8     U_SUB   (Sub, Bout, A, B, Cin);
	divisor8x8		  U_DIV   (Erro, Div, Resto, A, B);
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
	// 010 - multiplicação, que recebe 8'b0 pois é realizada no módulo ularpn;
	// 011 - divisão;
	// 100 - and;
	// 101 - or;
	// 110 - xor;
	// 111 - not.
	
	
	// =========================================================
	// FLAGS DO CIRCUITO: COUT/BOUT, ERRO, RESTO
	
	// Flag Resto - verifica se resultado da divisão tem resto
	flagresto U_FLAGRES (TemResto, Resto);

	displayRESTO AcenderResto (FlagResto, Sel[2], Sel[1], Sel[0], Resto);
	
	// Flag Cout/Bout - verifica carry out (soma) ou borrow out (subtração)
	flagcout U_FLAGCOUT (FlagCout, Sel, Cout, Bout);
	
	// Flag Erro - verifica divisão por zero
	flagerro U_FLAGERRO (FlagErro, Sel, Erro);
	
	// =========================================================
	// SAÍDA DAS FLAGS 
	
	or OrFlags0 (Flags[0], FlagCout, 1'b0);
	or OrFlags3 (Flags[1], FlagErro, 1'b0);
	or OrFlags4 (Flags[2], FlagResto, 1'b0);
    
endmodule