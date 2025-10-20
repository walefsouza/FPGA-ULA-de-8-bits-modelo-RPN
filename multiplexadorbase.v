module multiplexadorbase (Z, S2, S1, S0, E0, E1, E2, E3, E4, E5, E6, E7);


	// O módulo base seleciona apenas um bit da operação a ser representada na saída
	
	input S2, S1, S0; // entrada do seletor
	input E0, E1, E2, E3, E4, E5, E6, E7; // entradas as operações
	output Z; // saida do bit selecionado
	
	// =========================================================
	// FIOS DE APOIO
	
	
	wire nots2, nots1, nots0;
	wire and0, and1, and2, and3, and4, and5, and6, and7;
	
	// =========================================================
	// INVERSÃO DOS SELETORES
	
	
	not NotS0 (nots0, S0);
	not NotS1 (nots1, S1);
	not NotS2 (nots2, S2);

	// =========================================================
	// SELECIONANDO BIT A SER REPRESENTADO
	
	
	and And0 (and0, nots2, nots1, nots0, E0); // Sel = 000
	and And1 (and1, nots2, nots1, S0, E1); // Sel = 001
	and And2 (and2, nots2, S1, nots0, E2); // Sel = 010
	and And3 (and3, nots2, S1,S0,E3); // Sel = 011
	and And4 (and4, S2, nots1, nots0,E4); // Sel = 100 and
	and And5 (and5, S2, nots1, S0, E5); // Sel = 101 or
	and And6 (and6, S2,S1,nots0,E6); // Sel = 110 xor
	and And7 (and7, S2,S1,S0,E7); // Sel = 111 not
	
	or OrFinal (Z, and0, and1, and2, and3, and4, and5, and6, and7);
	
endmodule