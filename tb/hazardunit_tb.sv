`timescale 1ns / 1ps

module hazardunit_tb;

  logic clk;
  always #5 clk = ~clk; // 10ns clk

  logic [31:0] instr_if, instr_id, instr_ex, instr_mem, instr_wb;
  logic        flush, en;

  hazardunit dut (
    .instr_id(instr_id),
    .instr_ex(instr_ex),
    .flush  (flush),
    .en     (en)
  );

  always @(posedge clk) begin
    instr_id  <= instr_if;
    instr_ex  <= instr_id;
    instr_mem <= instr_ex;
    instr_wb  <= instr_mem;
  end

  task send_instr(input [31:0] instr);
    instr_if = instr;
    #10; // wait 1 clk
  endtask

  task check(input [31:0] instr);
    fork
      send_instr(instr);
      #21 $display("instr_id = %h, instr_ex = %h, flush = %b, en = %b", instr_id, instr_ex, flush, en);
    join_any
  endtask

  task test1;
    check(32'h00218233); // add x4, x3, x2    #
    check(32'h0400A283); // lw  x5, 0x40(x1)  #
    check(32'h401284B3); // sub x9, x5, x1    # stall
    check(32'h0053E133); // or  x2, x7, x5    #
    check(32'h00129233); // sll x4, x5, x1    #
  endtask

  task test2;
    check(32'h00002083); // lw x1, 0(x0)    #
    check(32'h00402103); // lw x2, 4(x0)    #
    check(32'h002081B3); // add x3, x1, x2  # stall
    check(32'h00302623); // sw x3, 12(x0)   #
    check(32'h00802203); // lw x4, 8(x0)    #
    check(32'h004082B3); // add x5, x1, x4  # stall
    check(32'h00502823); // sw x5, 16(x0)   #
  endtask

  task test3;
    check(32'h00002083); // lw x1, 0(x0)    #
    check(32'h00402103); // lw x2, 4(x0)    #
    check(32'h00802203); // lw x4, 8(x0)    #
    check(32'h002081B3); // add x3, x1, x2  #
    check(32'h00302623); // sw x3, 12(x0)   #
    check(32'h004082B3); // add x5, x1, x4  #
    check(32'h00502823); // sw x5, 16(x0)   #
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
