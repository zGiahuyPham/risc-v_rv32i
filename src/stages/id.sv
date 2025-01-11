module ID (
  input  logic        clk, rst,
  input  logic [31:0] instr,
  input  logic [4:0]  waddr,
  input  logic [31:0] wdata,
  input  logic        regwen_i,
  input  logic        brlt, breq,
  output logic        pcsel,
  output logic [31:0] reg1, reg2, imm,
  output logic        asel, bsel, brun, 
  output logic [3:0]  op,
  output logic        regwen_o, wren,
  output logic [1:0]  wbsel,
  output logic [2:0]  rwsel
);

  logic [4:0] immsel;
  
  regfile reg_file (
    .clk   (clk),
    .rst   (rst),
    .waddr (waddr),
    .addr1 (instr[19:15]),
    .addr2 (instr[24:20]),
    .wdata (wdata),
    .regwen(regwen_i),
    .reg1  (reg1),
    .reg2  (reg2)
  );  

  immgen imm_gen (
    .instr (instr[31:7]),
    .immsel(immsel),
    .imm   (imm)
  );

  ctrlunit control_unit (
    .instr (instr),
    .brlt  (brlt),
    .breq  (breq),
    .immsel(immsel),
    .op    (op),
    .pcsel (pcsel),
    .regwen(regwen_o),
    .brun  (brun),
    .asel  (asel),
    .bsel  (bsel),
    .wren  (wren),
    .wbsel (wbsel),
    .rwsel (rwsel)
  );
  
endmodule
