module MEM_WB (
  input  logic        clk, rst,
  input  logic [31:0] pc_i, instr_i, // pc added 4
  input  logic [31:0] ldata_i,
  input  logic [31:0] res_i,
  input  logic [1:0]  wbsel_i,
  input  logic        regwen_i,
  output logic [31:0] pc_o, instr_o,
  output logic [31:0] ldata_o,
  output logic [31:0] res_o,
  output logic [1:0]  wbsel_o,
  output logic        regwen_o
);

  always_ff @(posedge clk or negedge rst) begin
    if (~rst) begin
      pc_o     <= 32'd0;
      instr_o  <= 32'd0;
      ldata_o  <= 32'd0;
      res_o    <= 32'd0;
      wbsel_o  <= 2'd0;
      regwen_o <= 1'd0;
    end else begin
      pc_o     <= pc_i;
      instr_o  <= instr_i;
      ldata_o  <= ldata_i;
      res_o    <= res_i;
      wbsel_o  <= wbsel_i;
      regwen_o <= regwen_i;
    end
  end

endmodule
