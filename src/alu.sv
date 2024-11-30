module alu (
  input  [31:0] a, b,
  input  [3:0]  op,
  output [31:0] res
);

  always_comb begin
    logic [31:0] tmp;
    res = '0;
    case (op)
      4'b0000: res = a + b;
      4'b1000: res = a + (~b + 1);
      4'b0010: {res[0], tmp} = {a[31], a} + (~{b[31], b} + 1);
      4'b0011: {res[0], tmp} = {1'b0, a} + (~{1'b0, b} + 1);
      4'b0100: res = a ^ b;
      4'b0110: res = a | b;	
      4'b0111: res = a & b;
      4'b0001: begin
        res = a;
        res = b[0] ? {res[30:0], 1'b0} : res;
        res = b[1] ? {res[29:0], 2'b0} : res;
        res = b[2] ? {res[27:0], 4'b0} : res;
        res = b[3] ? {res[23:0], 8'b0} : res;
        res = b[4] ? {res[15:0], 16'b0} : res;
      end
      4'b0101,
      4'b1101: begin
        res = a;
        if (op[3] && a[31]) tmp = '1;
        else tmp = '0;
        res = b[0] ? {tmp[0:0], res[31:1]} : res;
        res = b[1] ? {tmp[1:0], res[31:2]} : res;
        res = b[2] ? {tmp[3:0], res[31:4]} : res;
        res = b[3] ? {tmp[7:0], res[31:8]} : res;
        res = b[4] ? {tmp[15:0], res[31:16]} : res;
      end
      4'b1001: res = b;
      default: res = '0;
    endcase
  end

endmodule
