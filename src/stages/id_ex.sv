module ID_EX (
  input  logic        clk, rst, flush,
  input  logic [31:0] pc_i, instr_i,
  input  logic [31:0] reg1_i, reg2_i, imm_i,
  input  logic        asel_i, bsel_i, brun_i,     
  input  logic [3:0]  op_i,  
  input  logic        regwen_i, wren_i,    
  input  logic [1:0]  wbsel_i,   
  input  logic [2:0]  rwsel_i,
  output logic [31:0] pc_o, instr_o,
  output logic [31:0] reg1_o, reg2_o, imm_o,
  output logic        asel_o, bsel_o, brun_o,     
  output logic [3:0]  op_o,  
  output logic        regwen_o, wren_o,    
  output logic [1:0]  wbsel_o,   
  output logic [2:0]  rwsel_o
);

  always_ff @(posedge clk or negedge rst) begin
    if (~rst) begin
      pc_o     <= 32'd0;
      instr_o   <= 32'd0;
      reg1_o   <= 32'd0;
      reg2_o   <= 32'd0;
      imm_o    <= 32'd0;
      asel_o   <= 1'd0;
      bsel_o   <= 1'd0;
      brun_o   <= 1'd0;
      op_o     <= 4'd0;
      regwen_o <= 1'd0;
      wren_o   <= 1'd0;
      wbsel_o  <= 2'd0;
      rwsel_o  <= 3'd0;
    end else if (flush) begin
      pc_o     <= 32'd0;
      instr_o   <= 32'd0;
      reg1_o   <= 32'd0;
      reg2_o   <= 32'd0;
      imm_o    <= 32'd0;
      asel_o   <= 1'd0;
      bsel_o   <= 1'd0;
      brun_o   <= 1'd0;
      op_o     <= 4'd0;
      regwen_o <= 1'd0;
      wren_o   <= 1'd0;
      wbsel_o  <= 2'd0;
      rwsel_o  <= 3'd0;
    end else begin
      pc_o     <= pc_i;
      instr_o   <= instr_i;
      reg1_o   <= reg1_i;
      reg2_o   <= reg2_i;
      imm_o    <= imm_i;
      asel_o   <= asel_i;
      bsel_o   <= bsel_i;
      brun_o   <= brun_i;
      op_o     <= op_i;
      regwen_o <= regwen_i;
      wren_o   <= wren_i;
      wbsel_o  <= wbsel_i;
      rwsel_o  <= rwsel_i;
    end
  end

endmodule
