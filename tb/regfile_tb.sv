`timescale 1ns / 1ps

module regfile_tb;
  logic clk;
  always begin
    #5 clk = ~clk; // 10ns clk
  end

  logic [4:0]  waddr;
  logic [4:0]  addr1;
  logic [4:0]  addr2;
  logic [31:0] wdata;
  logic        regwen;
  logic [31:0] res1;
  logic [31:0] res2;

  regfile dut (
    .clk(clk),
    .rst(1'b1),
    .waddr(waddr),
    .addr1(addr1),
    .addr2(addr2),
    .wdata(wdata),
    .regwen(regwen),
    .res1(res1),
    .res2(res2)
  );
  
  task write_data(input [4:0] t_addr, input [31:0] data);
    begin
      waddr = t_addr;
      wdata = data;
      regwen = 1;
      #10; // wait 1 clk
      regwen = 0;
      assert(dut.rs[t_addr] == data) else begin
        $display("Wrong answer: rs[%d] = %h, ", waddr, dut.rs[t_addr],
                 "expected rs[%d] = %h", t_addr, data);
        $stop;
      end
    end
  endtask

  int rand_data;
  logic [4:0] rand_addr, rand_addr1;
  
  task write_random_data(input int i);
    begin
      rand_addr = $random;
      rand_data = $random;
      waddr = rand_addr;
      wdata = rand_data;
      @(negedge clk);
      regwen = 1;
      #10; // wait 1 clk
      regwen = 0;
      assert((!rand_addr && !dut.rs[rand_addr]) || 
             (rand_addr && dut.rs[rand_addr] == rand_data)) else begin
        $display("Wrong answer on test %0d: rs[%0d] = %h, ", i, waddr, dut.rs[rand_addr],
                 "expected rs[%0d] = %h", rand_addr, rand_data);
        $stop;
      end
    end
  endtask

  task read_random_data(input int i);
    begin
      rand_addr  = $random;
      rand_addr1 = $random;
      addr1 = rand_addr;
      addr2 = rand_addr1;
      #10; // wait 1 clk
      assert((!rand_addr ? 0 : dut.rs[rand_addr]) == res1) else begin
        $display("Wrong answer on test %0d: addr1 = %d, output = %h, ", i, addr1, res1,
                 "expected addr1 = %d, output = %h", rand_addr, dut.rs[rand_addr]);
        $stop;
      end
      assert((!rand_addr1 ? 0 : dut.rs[rand_addr1]) == res2) else begin
        $display("Wrong answer on test %0d: addr2 = %d, output = %h, ", i, addr2, res2,
                 "expected addr2 = %d, output = %h", rand_addr1, dut.rs[rand_addr1]);
        $stop;
      end
    end
  endtask

  initial begin
    $display("===================================== In queue =====================================");
    
    clk = 0;
    regwen = 0;

    $display("============== Write test  ==============");
    write_data(4'd15, 32'habcdefaa);
    
    $display("=========== Write random test ===========");
    for(int i = 1;   i <= 100; ++i) begin
      $display("Running on test %0d", i);
      write_random_data(i);
    end
    $display("=========== Read random test  ===========");
    for(int i = 1; i <= 100; ++i) begin
      $display("Running on test %0d", i);
      read_random_data(i);
    end
    $display("===================================== Accepted =====================================");
    $finish;
  end

endmodule
