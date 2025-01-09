module lsu (
  input  logic        clk,
  input  logic        rst,
  input  logic [11:0] addr,
  input  logic [31:0] sdata,
  input  logic        wren,
  input  logic [31:0] sw, btn,
  input  logic [2:0]  rwsel,
  output logic [31:0] rdata,
  output logic [31:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, ledr, ledg, lcd
);

  logic mwren, periphen;
  logic [31:0] idata, odata, newdata, mrdata, periphrdata;
  assign mwren = ~addr[11] & wren;
  assign periphen = (addr[11:8] == 4'b1000) & wren;
  assign idata = (addr[7:0] == 8'h00) ? sw : (addr[7:0] == 8'h10) ? btn : 32'd0;
  
  always_comb begin
    casez(rwsel)
      3'b000  : newdata = {odata[31:8], sdata[7:0]};    // sb
      3'b001  : newdata = {odata[31:16], sdata[15:0]};  // sh
      3'b010  : newdata = sdata;                        // sw 
      default : newdata = 32'dx;
    endcase
  end
  
  dmem data_memory (
    .clk  (clk),
    .addr (addr[10:0]),
    .sdata(newdata),
    .wren (mwren),
    .rdata(mrdata)
  );

  outperiph output_peripherals (
    .clk  (clk),
    .rst  (rst),
    .addr (addr[7:0]),
    .sdata(newdata),
    .wren (periphen),
    .rdata(periphrdata),
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
  
  assign odata = (~addr[11]) ? mrdata :
                 (addr[10:8] == 3'b000) ? periphrdata :
                 (addr[10:8] == 3'b001) ? idata : 32'd0;
  
  always_comb begin
    casez(rwsel)
      3'b000 : rdata = {{24{odata[7]}}, odata[7:0]};    // lb
      3'b001 : rdata = {{16{odata[15]}}, odata[15:0]};  // lh
      3'b010 : rdata = odata;                           // lw
      3'b100 : rdata = {24'd0, odata[7:0]};             // lbu
      3'b101 : rdata = {16'd0, odata[15:0]};            // lhu
      default: rdata = 32'dx;
    endcase
  end
  
endmodule
