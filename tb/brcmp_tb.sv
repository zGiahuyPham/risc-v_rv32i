`timescale 1ns / 1ps

module brcmp_tb;

  logic [31:0] a, b;
  logic brun, brlt, breq, lt, eq;

  brcmp uut (
    .a(a),
    .b(b),
    .brun(brun),
    .brlt(brlt),
    .breq(breq)
  );

  initial begin
    $display("===================================== In queue =====================================");
    
    for (int i = 1; i <= 100; i++) begin
      $display("Running on test %0d", i);
      a = $random;
      b = $random;
      brun = $random % 2;
      #50; 
      lt = brun ? (a < b) : ($signed(a) < $signed(b));
      eq = (a == b);
      assert((lt == brlt) & (eq == breq)) else begin
        $display("Wrong answer on test %0d : a = %d, b = %d, brun = %b, ", i, a, b, brun,
                 "brlt = %b, breq = %b, expected brlt = %b, breq = %b", brlt, breq, lt, eq);
        $stop;
      end
    end

    $display("===================================== Accepted =====================================");
    $finish;
  end

endmodule
