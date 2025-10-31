
module estagiodivisao8x8 (Resto_novo, Q_bit, Resto_anterior, D_bit, B);

    input [7:0] Resto_anterior; // RESTO DO ESTAGIO ANTERIOR
    input D_bit;                // BIT ATUAL DO DIVIDENDO
    input [7:0] B;              // DIVISOR
    output [7:0] Resto_novo;    // NOVO RESTO PARA PROXIMO ESTAGIO
    output Q_bit;               // BIT DO QUOCIENTE GERADO
    
    wire [7:0] dividendo_parcial, diferenca;
    wire borrow;
    
    // =========================================================
    // FORMAR NOVO DIVIDENDO: 
    
    or (dividendo_parcial[7], Resto_anterior[6], 1'b0);
    or (dividendo_parcial[6], Resto_anterior[5], 1'b0);
    or (dividendo_parcial[5], Resto_anterior[4], 1'b0);
    or (dividendo_parcial[4], Resto_anterior[3], 1'b0);
    or (dividendo_parcial[3], Resto_anterior[2], 1'b0);
    or (dividendo_parcial[2], Resto_anterior[1], 1'b0);
    or (dividendo_parcial[1], Resto_anterior[0], 1'b0);
    or (dividendo_parcial[0], D_bit, 1'b0);
    
    // =========================================================
  
    subtrator8x8 U_SUB (diferenca, borrow, dividendo_parcial, B, 1'b0);
    
    // =========================================================
    // BIT QUOCIENTE: 1 SE NAO HÁ BORROW (SUBTRACAO POSSIVEL)
    
    not (Q_bit, borrow);
    
    // =========================================================
    // ESCOLHER RESTO: SE BORROW=1 (NAO DEU), USA DIVIDENDO ORIGINAL
    //                 SE BORROW=0 (DEU CERTO), USA DIFERENCA
    
    //muxdivisor8x8 U_MUX (Resto_novo, diferenca, dividendo_parcial, borrow);
	 // Correção: Trocar 'diferenca' e 'dividendo_parcial'
	 muxdivisor8x8 U_MUX (
		.Z(Resto_novo),
		.A(diferenca),         // Selecionado quando S (borrow) = 0
		.B(dividendo_parcial), // Selecionado quando S (borrow) = 1
		.S(borrow)
);
	 
endmodule
