module comparador4x4BCD(S, A3, A2, A1, A0);

  input A3, A2, A1, A0;
  output S;

  wire and0, and1;
  //S = A2 A0 + A2 A1 + A3

  and And0(and0, A2, A0);
  and And1(and1, A2, A1);

  or OrFinalS(S, and0, and1, A3);

endmodule
