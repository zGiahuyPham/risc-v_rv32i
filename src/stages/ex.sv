module EX (
  input  logic [31:0] pc_i,
  input  logic [31:0] reg1, reg2, imm,
  input  logic        asel, bsel, brun,
  input  logic [3:0]  op,
  input  logic [1:0]  fwdselA, fwdselB,
  input  logic        pcselA, pcselB,
  input  logic [31:0] pc_mem, pc_wb,    // added 4
  input  logic [31:0] res_mem, wdata,
  output logic [31:0] pc_o,             // added 4
  output logic [31:0] res,
  output logic [31:0] sdata,
  output logic        breq, brlt
);

  assign pc_o = pc_i + 32'd4;

  logic [31:0] pcA, pcB;
  assign pcA = pcselA ? pc_wb : pc_mem;
  assign pcB = pcselB ? pc_wb : pc_mem;

  logic [31:0] fwdA, fwdB;
  logic [31:0] a, b;

  assign fwdA = (fwdselA == 2'b11) ? pcA : (fwdselA == 2'b10) ? res_mem : (fwdselA == 2'b01) ? wdata : reg1;
  assign fwdB = (fwdselB == 2'b11) ? pcB : (fwdselB == 2'b10) ? res_mem : (fwdselB == 2'b01) ? wdata : reg2;
  
  assign a = asel ? pc_i : fwdA;
  assign b = bsel ? imm : fwdB;

  alu alu (
    .a  (a),
    .b  (b),
    .op (op),
    .res(res)
  );

  brcmp branch_comp (
    .a   (fwdA),
    .b   (fwdB),
    .brun(brun),
    .brlt(brlt),
    .breq(breq)
  );

  assign sdata = fwdB;
  
endmodule
