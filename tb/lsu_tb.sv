`timescale 1ns / 1ps

module lsu_tb();

  logic clk;
  always begin
    #5 clk = ~clk;  // 10ns clk
  end
  
  logic [11:0] addr;
  logic [2:0]  rwsel;
  logic [31:0] wdata;
  logic        wren;
  logic [31:0] sw, btn;
  logic [31:0] rdata;
  logic [31:0] lcd, ledg, ledr;
  logic [31:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7;

  lsu dut(
    .clk(clk),
    .rst(1'b1),
    .addr(addr),
    .wdata(wdata),
    .wren(wren),
    .sw(sw),
    .btn(btn),
    .rwsel(rwsel),
    .rdata(rdata),
    .hex0(hex0),
    .hex1(hex1),
    .hex2(hex2),
    .hex3(hex3),
    .hex4(hex4),
    .hex5(hex5),
    .hex6(hex6),
    .hex7(hex7),
    .ledr(ledr),
    .ledg(ledg),
    .lcd(lcd)
);

  int rand_addr, rand_data;
  
  task write_random_data(input [11:0] t_addr);
    rand_data = $random;
    wdata = rand_data;
    addr = t_addr;
    wren = 1'b1;
    #10; // wait 1 clk
    wren = 1'b0;
    t_addr = 12'd0;
  endtask
 
  task read_random_data(input [11:0] t_addr, input [31:0] data);
    addr = t_addr;
    @(posedge clk);
    #1;
    assert(rdata === data) else begin
      $display("Wrong answer: at 0x%x read %x, expected %x", t_addr, rdata, data);
      $stop;
    end
    t_addr = 12'd0;
  endtask

  task read_data(input [31:0] data, input [31:0] data1);
    @(posedge clk);
    #1;
    assert(data === data1) else begin
      $display("Wrong answer: read %x, expected %x", data1, data);
      $stop;
    end
  endtask

  logic [31:0] memory_data;
  assign memory_data = dut.data_memory.mem[addr/4];

  // Test input values
  initial begin
    $display("===================================== In queue =====================================");
    
    clk = 0;
    rwsel = 3'b010;

    // DMEM TEST
    $display("================ DMEM test ================");
    for(int i = 0; i < 2048; i++) begin
      rand_addr = $random() % 12'h800;
      write_random_data(rand_addr);
      read_random_data(rand_addr, rand_data);
      #10;
    end

    $display("=============== INPUT test  ===============");
    for(int i = 1; i <= 100; i++) begin
      $display("Running on test %0d", i);
      sw = $random;
      read_random_data('h900, sw);
      btn = $random;
      read_random_data('h910, btn);
    end
    
    $display("=============== OUTPUT test ===============");
    for(int i = 1; i <= 100; i++) begin
      $display("Running on test %0d", i);
      write_random_data('h800);
      read_data(rand_data, hex0);
      write_random_data('h810);
      read_data(rand_data, hex1);
      write_random_data('h820);
      read_data(rand_data, hex2);
      write_random_data('h830);
      read_data(rand_data, hex3);
      write_random_data('h840);
      read_data(rand_data, hex4);
      write_random_data('h850);
      read_data(rand_data, hex5);
      write_random_data('h860);
      read_data(rand_data, hex6);
      write_random_data('h870);
      read_data(rand_data, hex7);
      write_random_data('h880);
      read_data(rand_data, ledr);
      write_random_data('h890);
      read_data(rand_data, ledg);
      write_random_data('h8A0);
      read_data(rand_data, lcd);
    end
    
    $display("===================================== Accepted =====================================");
    $finish;
  end

endmodule
