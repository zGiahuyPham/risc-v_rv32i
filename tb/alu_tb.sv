`timescale 1ns / 1ps

module alu_tb;

  int seed = 18;
  logic [31:0] a, b, c, res;
  logic [3:0] op;

  alu uut (
    .a(a),
    .b(b),
    .op(op),
    .res(res)
  );

  initial begin
    $display("===================================== In queue =====================================");
    
    for (int i = 0; i < 1001; i++) begin
      a = $random(seed);  // Random value
      b = $random(seed);  // Random value
      op = $random % 16;
      #50; 
      case (op)
        4'b0000: c = a + b;
        4'b1000: c = a - b;
        4'b0010: c = ($signed(a) < $signed(b)) ? 1 : 0;
        4'b0011: c = (a < b) ? 1 : 0;
        4'b0100: c = a ^ b;
        4'b0110: c = a | b;	
        4'b0111: c = a & b;
        4'b0001: c = a << b[4:0];
        4'b0101: c = a >> b[4:0];
        4'b1101: c = $signed(a) >>> b[4:0];
        4'b1001: c = b;
        default: c = '0;
      endcase
      assert(res == c) else begin
        $display("Wrong answer on test %0d : ", i,
                 "a = %d, b = %d, op = %b, res = %d, expected res = %d", a, b, op, res, c);
        $stop;
      end
      $display("Running on test %0d", i);
    end

    $display("===================================== Accepted =====================================");
    $finish;
  end

endmodule
