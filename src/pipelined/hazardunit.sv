module hazardunit (
  input  logic [31:0] instr_id, instr_ex,
  output logic        flush,
  output logic        en
);

  logic [4:0] opcode_ex, rs1_id, rs2_id, rd_ex;
  logic       isload_ex;

  assign opcode_ex = instr_ex[6:2];
  assign isload_ex = ~(|opcode_ex);   // opcode = 00000 loads (self defined)
  assign rs1_id    = instr_id[19:15];
  assign rs2_id    = instr_id[24:20];
  assign rd_ex     = instr_ex[11:7];

  always_comb begin
    if(isload_ex & (rd_ex != 5'd0) & (rd_ex == rs1_id | rd_ex == rs2_id)) begin
      flush = 1'b1;
      en    = 1'b0;
    end else begin
      flush = 1'b0;
      en    = 1'b1;
    end
  end

endmodule

