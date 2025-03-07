module regfile (
  input  logic        clk, rst,
  input  logic [4:0]  addr1, addr2, waddr,
  input  logic [31:0] wdata,
  input  logic        regwen,
  output logic [31:0] reg1, reg2
);

  logic [31:0] rs [31:0];
	
  initial begin
    for (int i = 0; i < 32; i++) rs[i] = '0;
  end
	
  always_ff @(posedge clk or negedge rst) begin
    if (~rst) for (int i = 0; i < 32; i++) rs[i] = '0;
    else if (regwen & (|waddr)) rs[waddr] <= wdata;
  end

  always_comb begin
    reg1 = |addr1 ? rs[addr1] : '0;
    reg2 = |addr2 ? rs[addr2] : '0;
  end
	
endmodule
