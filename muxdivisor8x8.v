module muxdivisor8x8 (Z, A, B, S);
    input [7:0] A, B;
    input S;
    output [7:0] Z;
    
    multiplexador2x1 U0 (.S(Z[0]), .Sel(S), .A(A[0]), .B(B[0]));
    multiplexador2x1 U1 (.S(Z[1]), .Sel(S), .A(A[1]), .B(B[1]));
    multiplexador2x1 U2 (.S(Z[2]), .Sel(S), .A(A[2]), .B(B[2]));
    multiplexador2x1 U3 (.S(Z[3]), .Sel(S), .A(A[3]), .B(B[3]));
    multiplexador2x1 U4 (.S(Z[4]), .Sel(S), .A(A[4]), .B(B[4]));
    multiplexador2x1 U5 (.S(Z[5]), .Sel(S), .A(A[5]), .B(B[5]));
    multiplexador2x1 U6 (.S(Z[6]), .Sel(S), .A(A[6]), .B(B[6]));
    multiplexador2x1 U7 (.S(Z[7]), .Sel(S), .A(A[7]), .B(B[7]));
endmodule