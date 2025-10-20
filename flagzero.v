module flagzero (Z, R); // resultado do multiplexador

	input [7:0] R;
	output Z;

   // Instancia uma única porta NOR de 8 entradas;
   // A saida (Z) só será 1 se todas as 8 entradas forem 0.
	 
   nor GeradorFlagZ (Z, R[7], R[6], R[5], R[4], R[3], R[2], R[1], R[0]);

endmodule