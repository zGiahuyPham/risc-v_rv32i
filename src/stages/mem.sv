module MEM (
  input         clk, rst,
  input  [31:0] addr,
  input  [31:0] sdata,
  input         wren,
  input  [31:0] sw, btn,
  input  [2:0]  rwsel,
  output [31:0] ldata,
  output [31:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, ledr, ledg, lcd
);

  lsu lsu (
    .clk  (clk),
    .rst  (rst),
    .addr (addr[11:0]),
    .sdata(sdata),
    .wren (wren),
    .sw   (sw),
    .btn  (btn),
    .rwsel(rwsel),
    .ldata(ldata),
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

endmodule
