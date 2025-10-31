// ====================================================================
// Multiplexador RPN para organizar os dados conforme os passos do contador
// ====================================================================

module multiplexadorRPN (
    entrada_sw, contador,
    saida_a, saida_b, saida_sel, saida_carry_in
);
    input [7:0] entrada_sw;
    input [1:0] contador;
    output [7:0] saida_a, saida_b;
    output [2:0] saida_sel;
    output saida_carry_in;
    
    // ===== PARA RegA (passo 00) =====
    
    wire mux_l1_a0_0, mux_l1_a0_1;
    multiplexador2x1 MuxL1A0_Part0 (.S(mux_l1_a0_0), .Sel(contador[0]), .A(entrada_sw[0]), .B(1'b0));
    multiplexador2x1 MuxL1A0_Part1 (.S(mux_l1_a0_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2A0 (.S(saida_a[0]), .Sel(contador[1]), .A(mux_l1_a0_0), .B(mux_l1_a0_1));
    
    wire mux_l1_a1_0, mux_l1_a1_1;
    multiplexador2x1 MuxL1A1_Part0 (.S(mux_l1_a1_0), .Sel(contador[0]), .A(entrada_sw[1]), .B(1'b0));
    multiplexador2x1 MuxL1A1_Part1 (.S(mux_l1_a1_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2A1 (.S(saida_a[1]), .Sel(contador[1]), .A(mux_l1_a1_0), .B(mux_l1_a1_1));
    
    wire mux_l1_a2_0, mux_l1_a2_1;
    multiplexador2x1 MuxL1A2_Part0 (.S(mux_l1_a2_0), .Sel(contador[0]), .A(entrada_sw[2]), .B(1'b0));
    multiplexador2x1 MuxL1A2_Part1 (.S(mux_l1_a2_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2A2 (.S(saida_a[2]), .Sel(contador[1]), .A(mux_l1_a2_0), .B(mux_l1_a2_1));
    
    wire mux_l1_a3_0, mux_l1_a3_1;
    multiplexador2x1 MuxL1A3_Part0 (.S(mux_l1_a3_0), .Sel(contador[0]), .A(entrada_sw[3]), .B(1'b0));
    multiplexador2x1 MuxL1A3_Part1 (.S(mux_l1_a3_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2A3 (.S(saida_a[3]), .Sel(contador[1]), .A(mux_l1_a3_0), .B(mux_l1_a3_1));
    
    wire mux_l1_a4_0, mux_l1_a4_1;
    multiplexador2x1 MuxL1A4_Part0 (.S(mux_l1_a4_0), .Sel(contador[0]), .A(entrada_sw[4]), .B(1'b0));
    multiplexador2x1 MuxL1A4_Part1 (.S(mux_l1_a4_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2A4 (.S(saida_a[4]), .Sel(contador[1]), .A(mux_l1_a4_0), .B(mux_l1_a4_1));
    
    wire mux_l1_a5_0, mux_l1_a5_1;
    multiplexador2x1 MuxL1A5_Part0 (.S(mux_l1_a5_0), .Sel(contador[0]), .A(entrada_sw[5]), .B(1'b0));
    multiplexador2x1 MuxL1A5_Part1 (.S(mux_l1_a5_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2A5 (.S(saida_a[5]), .Sel(contador[1]), .A(mux_l1_a5_0), .B(mux_l1_a5_1));
    
    wire mux_l1_a6_0, mux_l1_a6_1;
    multiplexador2x1 MuxL1A6_Part0 (.S(mux_l1_a6_0), .Sel(contador[0]), .A(entrada_sw[6]), .B(1'b0));
    multiplexador2x1 MuxL1A6_Part1 (.S(mux_l1_a6_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2A6 (.S(saida_a[6]), .Sel(contador[1]), .A(mux_l1_a6_0), .B(mux_l1_a6_1));
    
    wire mux_l1_a7_0, mux_l1_a7_1;
    multiplexador2x1 MuxL1A7_Part0 (.S(mux_l1_a7_0), .Sel(contador[0]), .A(entrada_sw[7]), .B(1'b0));
    multiplexador2x1 MuxL1A7_Part1 (.S(mux_l1_a7_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2A7 (.S(saida_a[7]), .Sel(contador[1]), .A(mux_l1_a7_0), .B(mux_l1_a7_1));
    
    // ===== PARA RegB (passo 01) =====
    
    wire mux_l1_b0_0, mux_l1_b0_1;
    multiplexador2x1 MuxL1B0_Part0 (.S(mux_l1_b0_0), .Sel(contador[0]), .A(1'b0), .B(entrada_sw[0]));
    multiplexador2x1 MuxL1B0_Part1 (.S(mux_l1_b0_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2B0 (.S(saida_b[0]), .Sel(contador[1]), .A(mux_l1_b0_0), .B(mux_l1_b0_1));
    
    wire mux_l1_b1_0, mux_l1_b1_1;
    multiplexador2x1 MuxL1B1_Part0 (.S(mux_l1_b1_0), .Sel(contador[0]), .A(1'b0), .B(entrada_sw[1]));
    multiplexador2x1 MuxL1B1_Part1 (.S(mux_l1_b1_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2B1 (.S(saida_b[1]), .Sel(contador[1]), .A(mux_l1_b1_0), .B(mux_l1_b1_1));
    
    wire mux_l1_b2_0, mux_l1_b2_1;
    multiplexador2x1 MuxL1B2_Part0 (.S(mux_l1_b2_0), .Sel(contador[0]), .A(1'b0), .B(entrada_sw[2]));
    multiplexador2x1 MuxL1B2_Part1 (.S(mux_l1_b2_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2B2 (.S(saida_b[2]), .Sel(contador[1]), .A(mux_l1_b2_0), .B(mux_l1_b2_1));
    
    wire mux_l1_b3_0, mux_l1_b3_1;
    multiplexador2x1 MuxL1B3_Part0 (.S(mux_l1_b3_0), .Sel(contador[0]), .A(1'b0), .B(entrada_sw[3]));
    multiplexador2x1 MuxL1B3_Part1 (.S(mux_l1_b3_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2B3 (.S(saida_b[3]), .Sel(contador[1]), .A(mux_l1_b3_0), .B(mux_l1_b3_1));
    
    wire mux_l1_b4_0, mux_l1_b4_1;
    multiplexador2x1 MuxL1B4_Part0 (.S(mux_l1_b4_0), .Sel(contador[0]), .A(1'b0), .B(entrada_sw[4]));
    multiplexador2x1 MuxL1B4_Part1 (.S(mux_l1_b4_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2B4 (.S(saida_b[4]), .Sel(contador[1]), .A(mux_l1_b4_0), .B(mux_l1_b4_1));
    
    wire mux_l1_b5_0, mux_l1_b5_1;
    multiplexador2x1 MuxL1B5_Part0 (.S(mux_l1_b5_0), .Sel(contador[0]), .A(1'b0), .B(entrada_sw[5]));
    multiplexador2x1 MuxL1B5_Part1 (.S(mux_l1_b5_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2B5 (.S(saida_b[5]), .Sel(contador[1]), .A(mux_l1_b5_0), .B(mux_l1_b5_1));
    
    wire mux_l1_b6_0, mux_l1_b6_1;
    multiplexador2x1 MuxL1B6_Part0 (.S(mux_l1_b6_0), .Sel(contador[0]), .A(1'b0), .B(entrada_sw[6]));
    multiplexador2x1 MuxL1B6_Part1 (.S(mux_l1_b6_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2B6 (.S(saida_b[6]), .Sel(contador[1]), .A(mux_l1_b6_0), .B(mux_l1_b6_1));
    
    wire mux_l1_b7_0, mux_l1_b7_1;
    multiplexador2x1 MuxL1B7_Part0 (.S(mux_l1_b7_0), .Sel(contador[0]), .A(1'b0), .B(entrada_sw[7]));
    multiplexador2x1 MuxL1B7_Part1 (.S(mux_l1_b7_1), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL2B7 (.S(saida_b[7]), .Sel(contador[1]), .A(mux_l1_b7_0), .B(mux_l1_b7_1));
    
    // ===== PARA Sel (passo 10) =====
    
    wire mux_l1_sel0_0, mux_l1_sel0_1;
    multiplexador2x1 MuxL1Sel0_Part0 (.S(mux_l1_sel0_0), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL1Sel0_Part1 (.S(mux_l1_sel0_1), .Sel(contador[0]), .A(entrada_sw[0]), .B(1'b0));
    multiplexador2x1 MuxL2Sel0 (.S(saida_sel[0]), .Sel(contador[1]), .A(mux_l1_sel0_0), .B(mux_l1_sel0_1));
    
    wire mux_l1_sel1_0, mux_l1_sel1_1;
    multiplexador2x1 MuxL1Sel1_Part0 (.S(mux_l1_sel1_0), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL1Sel1_Part1 (.S(mux_l1_sel1_1), .Sel(contador[0]), .A(entrada_sw[1]), .B(1'b0));
    multiplexador2x1 MuxL2Sel1 (.S(saida_sel[1]), .Sel(contador[1]), .A(mux_l1_sel1_0), .B(mux_l1_sel1_1));
    
    wire mux_l1_sel2_0, mux_l1_sel2_1;
    multiplexador2x1 MuxL1Sel2_Part0 (.S(mux_l1_sel2_0), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL1Sel2_Part1 (.S(mux_l1_sel2_1), .Sel(contador[0]), .A(entrada_sw[2]), .B(1'b0));
    multiplexador2x1 MuxL2Sel2 (.S(saida_sel[2]), .Sel(contador[1]), .A(mux_l1_sel2_0), .B(mux_l1_sel2_1));
    
    // ===== PARA Carry In (passo 10) =====
    
    wire mux_l1_carry_0, mux_l1_carry_1;
    multiplexador2x1 MuxL1Carry_Part0 (.S(mux_l1_carry_0), .Sel(contador[0]), .A(1'b0), .B(1'b0));
    multiplexador2x1 MuxL1Carry_Part1 (.S(mux_l1_carry_1), .Sel(contador[0]), .A(entrada_sw[3]), .B(1'b0));
    multiplexador2x1 MuxL2Carry (.S(saida_carry_in), .Sel(contador[1]), .A(mux_l1_carry_0), .B(mux_l1_carry_1));
    
endmodule