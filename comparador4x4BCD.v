module comparador4x4BCD(S, A);

  input [3:0] A;
  output S;

  wire and0, and1;
  //S = A2 A0 + A2 A1 + A3

  and And0(and0, A[2], A[0]);
  and And1(and1, A[2], A[1]);

  or OrFinalS(S, and0, and1, A[3]);

endmodule
