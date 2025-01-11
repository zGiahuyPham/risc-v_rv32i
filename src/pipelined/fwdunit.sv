module fwdunit (
  input  logic [31:0] instr_ex, instr_mem, instr_wb,
  input  logic        regwen_mem, regwen_wb,
  output logic [1:0]  fwdselA, fwdselB,
  output logic        pcselA, pcselB
);

  logic [4:0] rs1_ex, rs2_ex, rd_mem, rd_wb;
  assign rs1_ex = instr_ex[19:15];
  assign rs2_ex = instr_ex[24:20];
  assign rd_mem = instr_mem[11:7];
  assign rd_wb  = instr_wb [11:7];

  logic [4:0] opcode_mem, opcode_wb;
  assign opcode_mem = instr_mem[6:2];
  assign opcode_wb  = instr_wb [6:2];

  logic is_jmp_mem, is_jmp_wb;
  assign is_jmp_mem = (opcode_mem == 5'b11011) | (opcode_mem == 5'b11001); // jal, jalr
  assign is_jmp_wb  = (opcode_wb  == 5'b11011) | (opcode_wb  == 5'b11001); // jal, jalr


  always_comb begin
    // A
    pcselA  = 1'b0;
    fwdselA = 2'b00;
    if (regwen_mem & (rd_mem != 5'd0) & (rd_mem == rs1_ex)) begin
      if (is_jmp_mem) begin
        pcselA  = 1'b0;
        fwdselA = 2'b11;
      end else begin
        fwdselA = 2'b10;
      end
    end else if (regwen_wb & (rd_wb != 5'd0) & (rd_wb == rs1_ex)) begin
      if (is_jmp_wb) begin
        pcselA  = 1'b1;
        fwdselA = 2'b11;
      end else begin
        fwdselA = 2'b01;
      end
    end

    // B
    pcselB  = 1'b0;
    fwdselB = 2'b00;
    if (regwen_mem & (rd_mem != 5'd0) & (rd_mem == rs2_ex)) begin
      if (is_jmp_mem) begin
        pcselB  = 1'b0;
        fwdselB = 2'b11;
      end else begin
        fwdselB = 2'b10;
      end
    end else if (regwen_wb & (rd_wb != 5'd0) & (rd_wb == rs2_ex)) begin
      if (is_jmp_wb) begin
        pcselB  = 1'b1;
        fwdselB = 2'b11;
      end else begin
        fwdselB = 2'b01;
      end
    end
  end

endmodule
