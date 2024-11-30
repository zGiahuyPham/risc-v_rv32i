module outperiph (
  input         clk,
  input         rst,
  input  [7:0]  addr,
  input  [31:0] wdata,
  input         wren,
  output [31:0] rdata,
  output [31:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, ledr, ledg
);

  always_ff @(posedge clk or negedge rst) begin
    if (~rst) begin
      hex0 <= 32'b0;
      hex1 <= 32'b0;
      hex2 <= 32'b0;
      hex3 <= 32'b0;
      hex4 <= 32'b0;
      hex5 <= 32'b0;
      hex6 <= 32'b0;
      hex7 <= 32'b0;
      ledr <= 32'b0;
      ledg <= 32'b0;
    end else if (wren) begin
      case (addr)
        8'h00: hex0 <= wdata;
        8'h10: hex1 <= wdata;
        8'h20: hex2 <= wdata;
        8'h30: hex3 <= wdata;
        8'h40: hex4 <= wdata;
        8'h50: hex5 <= wdata;
        8'h60: hex6 <= wdata;
        8'h70: hex7 <= wdata;
        8'h80: ledr <= wdata;
        8'h90: ledg <= wdata;
        default: begin
          hex0 <= hex0;
          hex1 <= hex1;
          hex2 <= hex2;
          hex3 <= hex3;
          hex4 <= hex4;
          hex5 <= hex5;
          hex6 <= hex6;
          hex7 <= hex7;
          ledr <= ledr;
          ledg <= ledg;
        end
      endcase
    end
  end

  always_comb begin
    case (addr)
      8'h00: rdata = hex0;
      8'h10: rdata = hex1;
      8'h20: rdata = hex2;
      8'h30: rdata = hex3;
      8'h40: rdata = hex4;
      8'h50: rdata = hex5;
      8'h60: rdata = hex6;
      8'h70: rdata = hex7;
      8'h80: rdata = ledr;
      8'h90: rdata = ledg;
      default: rdata = 32'd0;
    endcase
  end

endmodule
