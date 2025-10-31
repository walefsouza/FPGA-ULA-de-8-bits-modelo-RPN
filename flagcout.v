module flagcout (F, Sel, Cout, Bout);

	input [2:0] Sel;
	input Cout, Bout;
	output F;
	
	// Em resumo, a flag recebe cout, bout e os seletores de operação
	// para verificar se a flag deve acender ou não naquele momento
	
	// ~Sel2 ~Sel1 ~Sel0 Cout + ~Sel2 ~Sel1 Sel0 Bout
	
	wire nsel2, nsel1, nsel0;
	wire and0, and1, and2, and3, and4;
	
	not Not0 (nsel2, Sel[2]);
   not Not1 (nsel1, Sel[1]);  
   not Not2 (nsel0, Sel[0]);
	
	and And0 (and0, nsel2, nsel1);
	and And1 (and1, and0, nsel0);
	and And2 (and2, and0, Sel[0]);
	and And3 (and3, and1, Cout);
	and And4 (and4, and2, Bout);
	
	or OrFlag (F, and3, and4); // Or final para verificar se a flag será ativada ou não
	
endmodule