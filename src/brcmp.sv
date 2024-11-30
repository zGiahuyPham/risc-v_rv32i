module brcmp (
  input [31:0] a, b,
  input        brun,
  output       brlt,
  output       breq
);

  logic signed [31:0] tmp;
		
  assign {brlt, tmp} = brun ? {1'b0, a} + (~{1'b0, b} + 1) : {a[31], a} + (~{b[31], b} + 1);
  assign breq = ~(|tmp);

endmodule
