module WB (
  input  logic [31:0] pc,
  input  logic [31:0] res,
  input  logic [31:0] ldata,
  input  logic [1:0]  wbsel,
  output logic [31:0] wdata
);

  assign wdata = (wbsel == 2'b01) ? res : (wbsel == 2'b10) ? pc : ldata;

endmodule
