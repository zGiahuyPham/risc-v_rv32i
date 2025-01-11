module IF (
  input  logic        clk, rst, en,
  input  logic        pcsel,
  input  logic [31:0] res,
  output logic [31:0] pc_o, instr_o
);

  logic [31:0] pc;

  imem instr_memory (
    .addr (pc[12:0]),
    .instr(instr_o)
  );

  assign pc_o = pc;

  always_ff @(posedge clk or negedge rst) begin
    if (~rst) pc <= 32'd0; else if (~en) pc <= pc; else pc <= pcsel ? res : pc + 32'd4;
  end

endmodule
