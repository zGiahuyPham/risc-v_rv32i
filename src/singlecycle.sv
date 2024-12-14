module singlecycle (
  input         clk, rst,
  input  [31:0] sw, btn,
  output [31:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, ledr, ledg, lcd,
  output [31:0] pcdebug
);

  logic [31:0] instr;
  logic        pcsel, asel, bsel, brun, brlt, breq, regwen, wren;
  logic [4:0]  immsel;
  logic [3:0]  op;
  logic [2:0]  rwsel;
  logic [1:0]  wbsel;
  
  logic [31:0] pc, res1, res2, imm, a, b, res, rdata, wdata;
  assign wdata = (wbsel == 2'b01) ? res : (wbsel == 2'b10) ? pc + 32'd4 : rdata;
  assign a = asel ? pc : res1;
  assign b = bsel ? imm : res2;
  
  assign pcdebug = pc;

  imem instr_memory (
    .addr (pc[12:0]),
    .instr(instr)
  );

  regfile reg_file (
    .clk(clk),
    .rst(rst),
    .addr1(instr[19:15]),
    .addr2(instr[24:20]),
    .waddr(instr[11:7]),
    .wdata(wdata),
    .regwen(regwen),
    .res1(res1),
    .res2(res2)
  );

  brcmp branch_comp (
    .a   (res1),
    .b   (res2),
    .brun(brun),
    .brlt(brlt),
    .breq(breq)
  );

  ctrlunit control_unit (
    .instr (instr),
    .brlt  (brlt),
    .breq  (breq),
    .immsel(immsel),
    .op    (op),
    .pcsel (pcsel),
    .regwen(regwen),
    .brun  (brun),
    .asel  (asel),
    .bsel  (bsel),
    .wren  (wren),
    .wbsel (wbsel),
    .rwsel (rwsel)
  );

  immgen imm_gen (
    .instr (instr[31:7]),
    .immsel(immsel),
    .imm   (imm)
  );

  alu alu (
    .a  (a),
    .b  (b),
    .op (op),
    .res(res)
  );

  lsu lsu (
    .clk  (clk),
    .rst  (rst),
    .addr (res[11:0]),
    .wdata(res2),
    .wren (wren),
    .sw   (sw),
    .btn  (btn),
    .rwsel(rwsel),
    .rdata(rdata),
    .hex0 (hex0),
    .hex1 (hex1),
    .hex2 (hex2),
    .hex3 (hex3),
    .hex4 (hex4),
    .hex5 (hex5),
    .hex6 (hex6),
    .hex7 (hex7),
    .ledr (ledr),
    .ledg (ledg),
    .lcd  (lcd)
  );

  always_ff @(posedge clk or negedge rst) begin
    if(~rst) pc <= 32'd0; else pc <= pcsel ? res : pc + 32'd4;
  end
  
endmodule
