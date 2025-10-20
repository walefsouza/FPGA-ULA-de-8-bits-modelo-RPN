module flagerro (E, Sel, Erro);

	// =========================================================
	// Em sintese, a flag é ativada quando o divisor é igual a 0.
	// PAra isso, verificamos com base no seletor da operação e 
	// o resultado de uma operação or com todos os elementos do divisor.
	
	
	input [2:0] Sel;
	input Erro; // or com todos os numeros do divisor
	output E;
	
	wire nots2, and0, and1;
	
	not Not0 (nots2, Sel[2]);
	
	and And0 (and0, nots2, Sel[1]);
	and And1 (and1, and0, Sel[0]);
	
	and And2 (E, and1, Erro);
	
endmodule