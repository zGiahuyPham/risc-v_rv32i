module IF_ID (
  input  logic        clk, rst, en, flush,
  input  logic [31:0] pc_i, inst_i,
  output logic [31:0] pc_o, inst_o
);

  always_ff @(posedge clk or negedge rst) begin
    if (~rst) begin
      pc_o   <= 32'd0;
      inst_o <= 32'd0;
    end else if (en & flush) begin
      pc_o   <= 32'd0;
      inst_o <= 32'd0;
    end else if (en) begin
      pc_o   <= pc_i;
      inst_o <= inst_i;
    end
  end

endmodule
