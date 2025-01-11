module pipelined (
  input  logic        clk, rst,
  input  logic [31:0] sw, btn,
  output logic [31:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, ledr, ledg, lcd,
  output logic [31:0] pcdebug
);

  // IF_ID
  logic [31:0] pc_if_o, instr_if_o;
  
  logic [31:0] pc_id_i, instr_id_i;

  // ID_EX
  logic [31:0] reg1_id_o, reg2_id_o, imm_id_o;
  logic        asel_id_o, bsel_id_o, brun_id_o;
  logic [3:0]  op_id_o;
  logic        regwen_id_o, wren_id_o;
  logic [1:0]  wbsel_id_o;
  logic [2:0]  rwsel_id_o;

  logic [31:0] pc_ex_i, instr_ex_i;
  logic [31:0] reg1_ex_i, reg2_ex_i, imm_ex_i;
  logic        asel_ex_i, bsel_ex_i, brun_ex_i;
  logic [3:0]  op_ex_i;
  logic        regwen_ex_i, wren_ex_i;
  logic [1:0]  wbsel_ex_i;
  logic [2:0]  rwsel_ex_i;

  // EX_MEM
  logic [31:0] pc_ex_o;
  logic [31:0] res_ex_o;
  logic [31:0] fwdB_ex_o;

  logic [31:0] pc_mem_i, instr_mem_i;
  logic [31:0] res_mem_i;
  logic [31:0] reg2_mem_i;
  logic        regwen_mem_i, wren_mem_i;
  logic [1:0]  wbsel_mem_i;
  logic [2:0]  rwsel_mem_i;

  // MEM_WB
  logic [31:0] ldata_mem_o;

  logic [31:0] pc_wb_i, instr_wb_i;
  logic [31:0] res_wb_i;
  logic        regwen_wb_i;
  logic [31:0] MEM_WB_i;
  logic [1:0]  wbsel_wb_i;

  // ID
  logic        pcsel, brlt, breq;
  
  // WB
  logic [31:0] wdata;
  
  // hazard
  logic        en, flush;

  // forward
  logic [1:0]  fwdselA, fwdselB;
  logic        pcselA, pcselB;

  assign pcdebug = pc_id_i;

  IF IF (
    .clk    (clk),
    .rst    (rst),
    .en     (en),
    .pcsel  (pcsel),
    .res    (res_ex_o),
    .pc_o   (pc_if_o),
    .instr_o(instr_if_o)
  );

  IF_ID IF_ID (
    .clk    (clk),
    .rst    (rst),
    .en     (en),
    .flush  (flush),
    .pc_i   (pc_if_o),
    .instr_i(instr_if_o),
    .pc_o   (pc_id_i),
    .instr_o(instr_id_i)
  );

  ID ID (
    .clk     (clk),
    .rst     (rst),
    .instr   (instr_id_i),
    .waddr   (instr_wb_i[11:7]),
    .wdata   (wdata),
    .regwen_i(regwen_wb_i),
    .brlt    (brlt),
    .breq    (breq),
    .pcsel   (pcsel),
    .reg1    (reg1_id_o),
    .reg2    (reg2_id_o),
    .imm     (imm_id_o),
    .asel    (asel_id_o),
    .bsel    (bsel_id_o),
    .brun    (brun_id_o),
    .op_o    (op_id_o),
    .regwen_o(regwen_id_o),
    .wren    (wren_id_o),
    .wbsel   (wbsel_id_o),
    .rwsel   (rwsel_id_o)
  );

  ID_EX ID_EX (
    .clk     (clk),
    .rst     (rst),
    .flush   (flush),
    .pc_i    (pc_id_i),
    .instr_i (instr_id_i),
    .reg1_i  (reg1_id_o),
    .reg2_i  (reg2_id_o),
    .imm_i   (imm_id_o),
    .asel_i  (asel_id_o),
    .bsel_i  (bsel_id_o),
    .brun_i  (brun_id_o),
    .op_i    (op_id_o),
    .regwen_i(regwen_id_o),
    .wren_i  (wren_id_o),
    .wbsel_i (wbsel_id_o),
    .rwsel_i (rwsel_id_o),
    .pc_o    (pc_ex_i),
    .instr_o (instr_ex_i),
    .reg1    (reg1_ex_i),
    .reg2    (reg2_ex_i),
    .imm_o   (imm_ex_i),
    .asel_o  (asel_ex_i),
    .bsel_o  (bsel_ex_i),
    .brun_o  (brun_ex_i),
    .op_o    (op_ex_i),
    .regwen_o(regwen_ex_i),
    .wren_o  (wren_ex_i),
    .wbsel_o (wbsel_ex_i),
    .rwsel_o (rwsel_ex_i)
  );

  EX EX(
    .pc_i   (pc_ex_i),
    .reg1   (reg1_ex_i),
    .reg2   (reg2_ex_i),
    .imm    (imm_ex_i),
    .asel   (asel_ex_i),
    .bsel   (bsel_ex_i),
    .brun   (brun_ex_i),
    .op     (op_ex_i),
    .fwdselA(fwdselA),
    .fwdselB(fwdselB),
    .pcselA (pcselA),
    .pcselB (pcselB),
    .pc_mem (pc_mem_i),
    .pc_wb  (pc_wb_i),
    .res_mem(res_mem_i),
    .wdata  (wdata),
    .pc_o   (pc_ex_o),
    .res    (res_ex_o),
    .sdata  (fwdB_ex_o),
    .brlt   (brlt),
    .breq   (breq)
  );

  EX_MEM EX_MEM (
    .clk     (clk),
    .rst     (rst),
    .pc_i    (pc_ex_o),
    .instr_i (instr_ex_i),
    .res_i   (res_ex_o),
    .sdata_i (fwdB_ex_o),
    .regwen_i(regwen_ex_i),
    .wren_i  (wren_ex_i),
    .wbsel_i (wbsel_ex_i),
    .rwsel_i (rwsel_ex_i),
    .pc_o    (pc_mem_i),
    .instr_o (instr_mem_i),
    .res_o   (res_mem_i),
    .sdata_o (reg2_mem_i),
    .regwen_o(regwen_mem_i),
    .wren_o  (wren_mem_i),
    .wbsel_o (wbsel_mem_i),
    .rwsel_o (rwsel_mem_i)
  );

  MEM MEM (
    .clk  (clk),
    .rst  (rst),
    .addr (res_mem_i),
    .sdata(reg2_mem_i),
    .wren (wren_mem_i),
    .sw   (sw),
    .btn  (btn),
    .rwsel(rwsel_mem_i),
    .ldata(ldata_mem_o),
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

  MEM_WB MEM_WB (
    .clk     (clk),
    .rst     (rst),
    .pc_i    (pc_mem_i),
    .instr_i (instr_mem_i),
    .ldata_i (ldata_mem_o),
    .res_i   (res_mem_i),
    .wbsel_i (wbsel_mem_i),
    .regwen_i(regwen_mem_i),
    .pc_o    (pc_wb_i),
    .instr_o (instr_wb_i),
    .ldata_o (MEM_WB_i),
    .res_o   (res_wb_i),
    .wbsel_o (wbsel_wb_i),
    .regwen_o(regwen_wb_i)
  );

  WB WB (
    .pc   (pc_wb_i),
    .res  (res_wb_i),
    .ldata(MEM_WB_i),
    .wbsel(wbsel_wb_i),
    .wdata(wdata)
  );

  hazardunit hazard_detection_unit (
    .instr_id(instr_id_i),
    .instr_ex(instr_ex_i),
    .flush   (flush),
    .en      (en)
  );

  fwdunit forwarding_unit (
    .instr_ex  (instr_ex_i),
    .instr_mem (instr_mem_i),
    .instr_wb  (instr_wb_i),
    .regwen_mem(regwen_mem_i),
    .regwen_wb (regwen_wb_i),
    .fwdselA   (fwdselA),
    .fwdselB   (fwdselB),
    .pcselA    (pcselA),
    .pcselB    (pcselB)
  );

endmodule
