module immgen (
  input  [31:7] instr,
  input  [4:0]	immsel,
  output [31:0] imm
);

  logic [31:11] sign;

  always_comb begin
    if (instr[31]) sign = '1; else sign = '0;
         if (immsel[0])	imm = {sign[31:11], instr[30:20]};                                // I-type
    else if (immsel[1])	imm = {sign[31:11], instr[30:25], instr[11:7]};                   // S-type
    else if (immsel[2])	imm = {sign[31:12], instr[7], instr[30:25], instr[11:8], 1'b0};   // B-type
    else if (immsel[3])	imm = {instr[31:12], 12'b0};                                      // U-type
    else if (immsel[4])	imm = {sign[31:20], instr[19:12], instr[20], instr[30:21], 1'b0}; // J-type
    else								imm = '0;
  end
  
endmodule
