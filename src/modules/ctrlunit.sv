module ctrlunit (
  input  logic [31:0] instr,
  input  logic        brlt, breq,
  output logic        pcsel, asel, bsel, brun, regwen, wren,
  output logic [4:0]  immsel,
  output logic [3:0]  op,
  output logic [2:0]  rwsel,
  output logic [1:0]  wbsel
);

  logic [4:0] opcode;
  logic [2:0] funct3;
  logic       funct7, brTrue;
  assign opcode = instr[6:2];
  assign funct3 = instr[14:12];
  assign funct7 = instr[30];
  assign brTrue = (funct3 == 3'b000 & breq) |                         // beq
                  (funct3 == 3'b001 & ~breq) |                        // bne
                  ({funct3[2], funct3[0]} == 2'b10 & brlt) |          // blt
                  ({funct3[2], funct3[0]} == 2'b11 & (breq + ~brlt)); // bge
  
  logic Rtype, Itype, Stype, Btype, Jtype, JItype, Utype, Ltype;
  assign Rtype  = (opcode == 5'b01100);
  assign Itype  = ({opcode[4:3], opcode[1:0]} == 4'b0000);
  assign Stype  = (opcode == 5'b01000);
  assign Btype  = (opcode == 5'b11000);
  assign Jtype  = (opcode == 5'b11011);                     // jal
  assign Utype  = ({opcode[4], opcode[2:0]} == 4'b0101);    // lui, auipc
  assign JItype = (opcode == 5'b11001);                     // jalr
  assign Ltype  = ~(|opcode);                               // opcode = 00000 loads (self defined)

  assign pcsel  = Jtype | JItype | (Btype & brTrue);
  assign immsel = {Jtype, Utype, Btype, Stype, Itype | JItype};
  assign brun   = funct3[1];
  assign asel   = Btype | Jtype | Utype;
  assign bsel   = ~Rtype;
  assign wren   = Stype;
  assign regwen = ~Btype & ~Stype;
  assign wbsel  = Ltype ? 2'b00 : (Jtype | JItype) ? 2'b10 : 2'b01;
  assign rwsel  = funct3;
  assign op     = (Rtype) ? {funct7, funct3} :
                  ((Itype & ~Ltype) ? ((funct3 == 3'b101) ? {funct7, funct3} : {1'b0, funct3}) :
                  ((opcode == 5'b01101) ? 4'b1001 : 4'b0000));

endmodule
