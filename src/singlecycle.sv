module singlecycle (
  input  logic  clk, rst,
  input  logic [31:0] sw, btn,
  output logic [31:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, ledr, ledg, lcd,
  output logic [31:0] pcdebug
);

  logic [31:0] instr;
  logic        pcsel, asel, bsel, brun, brlt, breq, regwen, wren;
  logic [4:0]  immsel;
  logic [3:0]  op;
  logic [2:0]  rwsel;
  logic [1:0]  wbsel;
  
  logic [31:0] pc, reg1, reg2, imm, a, b, res, ldata, wdata;
  assign wdata = (wbsel == 2'b01) ? res : (wbsel == 2'b10) ? pc + 32'd4 : ldata;
  assign a = asel ? pc : reg1;
  assign b = bsel ? imm : reg2;
  
  assign pcdebug = pc;

  imem instr_memory (
    .addr (pc[12:0]),
    .instr(instr)
  );

  regfile reg_file (
    .clk   (clk),
    .rst   (rst),
    .addr1 (instr[19:15]),
    .addr2 (instr[24:20]),
    .waddr (instr[11:7]),
    .wdata (wdata),
    .regwen(regwen),
    .reg1  (reg1),
    .reg2  (reg2)
  );

  brcmp branch_comp (
    .a   (reg1),
    .b   (reg2),
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
    .sdata(reg2),
    .wren (wren),
    .sw   (sw),
    .btn  (btn),
    .rwsel(rwsel),
    .ldata(ldata),
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
