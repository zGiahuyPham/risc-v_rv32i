`timescale 1ns / 1ps

module fwdunit_tb;

  logic clk;
  always #5 clk = ~clk;
  
  logic [31:0] instr_if, instr_id, instr_ex, instr_mem, instr_wb;
  logic        regwen_mem, regwen_wb;
  logic [1:0]  fwdselA, fwdselB;
  logic        pcselA, pcselB;

  assign regwen_mem = ~(instr_mem[6:2] == 5'b11000) & ~(instr_mem[6:2] == 5'b01000);
  assign regwen_wb  = ~(instr_wb [6:2] == 5'b11000) & ~(instr_wb [6:2] == 5'b01000);

  fwdunit dut (
    .instr_ex  (instr_ex),
    .instr_mem (instr_mem),
    .instr_wb  (instr_wb),
    .regwen_mem(regwen_mem),
    .regwen_wb (regwen_wb),
    .fwdselA   (fwdselA),
    .fwdselB   (fwdselB),
    .pcselA    (pcselA),
    .pcselB    (pcselB)
);

  always @(posedge clk) begin
    instr_id  <= instr_if;
    instr_ex  <= instr_id;
    instr_mem <= instr_ex;
    instr_wb  <= instr_mem;
  end

  task send_instr(input [31:0] instr);
    instr_if = instr;
    #10;
  endtask

  task check(input [31:0] instr);
    fork
      send_instr(instr);
      #20 $display("instr_ex = %h, instr_mem = %h, instr_wb = %h, ", instr_ex, instr_mem, instr_wb,
                   "regwen_mem = %b, regwen_wb = %b, ", regwen_mem, regwen_wb,
                   "fwdA: %b, fwdB: %b, pcselA: %b, pcselB: %b", fwdselA, fwdselB, pcselA, pcselB);
    join_any
  endtask

  task test1;
    check(32'h002182B3); // add x5, x3, x2  #
    check(32'h0012C333); // xor x6, x5, x1  # res_mem_i -> A
    check(32'h405184B3); // sub x9, x3, x5  # res_wb_i  -> B
    check(32'h0053E133); // or  x2, x7, x5  #
    check(32'h00529233); // sll x4, x5, x5  #
  endtask

  task test2;
    check(32'h002000B3); // add x1, x0, x2  #
    check(32'h00300133); // add x2, x0, x3  #
    check(32'h402081B3); // sub x3, x1, x2  # res_wb_i -> A, res_mem_i -> B
  endtask

  task test3;
    check(32'h004000EF); // jal x1, 4       #
    check(32'h00008133); // add x2, x1, x0  # pc+4_mem_i -> A
    check(32'h001001B3); // add x3, x0, x1  # pc+4_wb_i -> B
    check(32'h0040026F); // jal x4, 4       #
    check(32'h008002EF); // jal x5, 8       #
    check(32'h00520333); // add x6, x4, x5  # pc+4_wb_i -> A, pc+4_mem_i -> B
  endtask
  
  initial begin
    $display("===================================== In queue =====================================");
    
    clk = 0;
    
    $display("===================== Running on test 1 =====================");
    test1;
    #50;
    
    $display("===================== Running on test 2 =====================");
    test2;
    #50;
    
    $display("===================== Running on test 3 =====================");
    test3;
    #50;
    
    $display("===================================== Accepted =====================================");
    $finish;
  end

endmodule
