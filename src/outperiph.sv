module outperiph (
  input  logic        clk,
  input  logic        rst,
  input  logic [7:0]  addr,
  input  logic [31:0] sdata,
  input  logic        wren,
  output logic [31:0] ldata,
  output logic [31:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, ledr, ledg, lcd
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
      lcd  <= 32'b0;
    end else if (wren) begin
      case (addr)
        8'h00: hex0 <= sdata;
        8'h10: hex1 <= sdata;
        8'h20: hex2 <= sdata;
        8'h30: hex3 <= sdata;
        8'h40: hex4 <= sdata;
        8'h50: hex5 <= sdata;
        8'h60: hex6 <= sdata;
        8'h70: hex7 <= sdata;
        8'h80: ledr <= sdata;
        8'h90: ledg <= sdata;
        8'hA0: lcd  <= sdata;
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
          lcd  <= lcd;
        end
      endcase
    end
  end

  always_comb begin
    case (addr)
      8'h00: ldata = hex0;
      8'h10: ldata = hex1;
      8'h20: ldata = hex2;
      8'h30: ldata = hex3;
      8'h40: ldata = hex4;
      8'h50: ldata = hex5;
      8'h60: ldata = hex6;
      8'h70: ldata = hex7;
      8'h80: ldata = ledr;
      8'h90: ldata = ledg;
      8'hA0: ldata = lcd;
      default: ldata = 32'd0;
    endcase
  end

endmodule
