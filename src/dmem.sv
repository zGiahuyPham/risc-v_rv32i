module dmem #(parameter DEPTH = 2048) (
	input  logic                     clk,
	input  logic [$clog2(DEPTH)-1:0] addr,
	input  logic [31:0]              sdata,
	input  logic                     wren,
	output logic [31:0]              ldata
);

	logic [3:0][7:0] mem[DEPTH/4];
	logic [$clog2(DEPTH)-3:0] maddr;
	assign maddr = addr[$clog2(DEPTH)-1:2];

	always @(posedge clk) begin
		if(wren) begin
			mem[maddr][0] <= sdata[7:0];
			mem[maddr][1] <= sdata[15:8];
			mem[maddr][2] <= sdata[23:16];
			mem[maddr][3] <= sdata[31:24];
    end
	end

	always_comb begin
		ldata = mem[maddr];
	end

endmodule

