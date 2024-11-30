`timescale 1ns / 1ps

module brcmp_tb;

  int seed = 25;
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
    
    for (int i = 0; i < 1001; i++) begin
      a = $random(seed);  // Random value
      b = $random(seed);  // Random value
      brun = $random % 2;
      #50; 
      lt = brun ? (a < b) : ($signed(a) < $signed(b));
      eq = (a == b);
      assert((lt == brlt) & (eq == breq)) else begin
        $display("Wrong answer on test %0d : a = %d, b = %d, brun = %b, ", i, a, b, brun,
                 "brlt = %b, breq = %b, expected brlt = %b, breq = %b", brlt, breq, lt, eq);
        $stop;
      end
      $display("Running on test %0d", i);
    end

    $display("===================================== Accepted =====================================");
    $finish;
  end

endmodule
