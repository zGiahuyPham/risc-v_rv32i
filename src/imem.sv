module imem #(parameter DEPTH = 8192) (
  input  [$clog2(DEPTH)-1:0] addr,
  output [31:0]              instr
);

  logic [$clog2(DEPTH)-3:0] maddr;
  logic [3:0][7:0] imem[DEPTH / 4];
  assign maddr = addr[$clog2(DEPTH)-1:2];

  initial begin
    $readmemh("imem.hex", imem);
  end

  always_comb begin
    instr = {imem[maddr][3], imem[maddr][2], imem[maddr][1], imem[maddr][0]};
  end

endmodule
