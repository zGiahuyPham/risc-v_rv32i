module EX_MEM (
  input  logic        clk, rst,
  input  logic [31:0] pc_i, instr_i, // pc added 4
  input  logic [31:0] res_i, sdata_i,
  input  logic        regwen_i,
  input  logic        wren_i,
  input  logic [1:0]  wbsel_i,
  input  logic [2:0]  rwsel_i,
  output logic [31:0] pc_o, instr_o,
  output logic [31:0] res_o, sdata_o,
  output logic        regwen_o,
  output logic        wren_o,
  output logic [1:0]  wbsel_o,
  output logic [2:0]  rwsel_o
);

  always_ff @(posedge clk or negedge rst) begin
    if (~rst) begin
      pc_o     <= 32'd0;
      instr_o  <= 32'd0;
      res_o    <= 32'd0;
      regwen_o <= 1'd0;
      wren_o   <= 1'd0;
      wbsel_o  <= 2'd0;
      rwsel_o  <= 3'd0;
      sdata_o  <= 32'd0;
    end else begin
      pc_o     <= pc_i;
      instr_o  <= instr_i;
      res_o    <= res_i;
      regwen_o <= regwen_i;
      wren_o   <= wren_i;
      wbsel_o  <= wbsel_i;
      rwsel_o  <= rwsel_i;
      sdata_o  <= sdata_i;
    end
  end

endmodule
