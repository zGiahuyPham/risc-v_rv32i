`timescale 1ns / 1ps

module ctrlunit_tb();
  
  logic [31:0] instr;
  logic        breq, brlt;
  logic [4:0]  immsel;
  logic [3:0]  op;
  logic        pcsel, regwen, brun, bsel, asel, wren;
  logic [1:0]  wbsel;
  logic [2:0]  rwsel;

  ctrlunit uut(
    .instr(instr),
    .breq(breq),
    .brlt(brlt),
    .immsel(immsel),
    .op(op),
    .pcsel(pcsel),
    .regwen(regwen),
    .brun(brun),
    .bsel(bsel),
    .asel(asel),
    .wren(wren),
    .wbsel(wbsel),
    .rwsel(rwsel)
);

  logic [19:0] output_data;
  logic [19:0] expected;
  assign output_data = {pcsel, immsel, brun, asel, bsel, op, wren, regwen, wbsel, rwsel};

  logic [10:0] test_arr;
  assign instr = {1'bx, test_arr[8], 15'b???????????????, test_arr[7:5], 5'b?????, test_arr[4:0], 2'b??};
  assign brlt = test_arr[10];
  assign breq = test_arr[9];

  always @(test_arr) begin
    casez(test_arr)
      11'b??000001100 : begin expected = 20'b0??????0000000101???; end
      11'b??100001100 : begin expected = 20'b0??????0010000101???; end
      11'b??010001100 : begin expected = 20'b0??????0001000101???; end
      11'b??011001100 : begin expected = 20'b0??????0001100101???; end
      11'b??011101100 : begin expected = 20'b0??????0001110101???; end
      11'b??000101100 : begin expected = 20'b0??????0000010101???; end
      11'b??010101100 : begin expected = 20'b0??????0001010101???; end
      11'b??110101100 : begin expected = 20'b0??????0011010101???; end
      11'b??001001100 : begin expected = 20'b0??????0000100101???; end
      11'b??001101100 : begin expected = 20'b0??????0000110101???; end

      11'b???00000100 : begin expected = 20'b000001?0100000101???; end
      11'b???10000100 : begin expected = 20'b000001?0101000101???; end
      11'b???11000100 : begin expected = 20'b000001?0101100101???; end
      11'b???11100100 : begin expected = 20'b000001?0101110101???; end
      11'b??000100100 : begin expected = 20'b000001?0100010101???; end
      11'b??010100100 : begin expected = 20'b000001?0101010101???; end
      11'b??110100100 : begin expected = 20'b000001?0111010101???; end
      11'b???01000100 : begin expected = 20'b000001?0100100101???; end
      11'b???01100100 : begin expected = 20'b000001?0100110101???; end

      11'b???00000000 : begin expected = 20'b000001?0100000100000; end
      11'b???00100000 : begin expected = 20'b000001?0100000100001; end
      11'b???01000000 : begin expected = 20'b000001?0100000100010; end
      11'b???10000000 : begin expected = 20'b000001?0100000100100; end
      11'b???10100000 : begin expected = 20'b000001?0100000100101; end

      11'b???00001000 : begin expected = 20'b000010?01000010??000; end
      11'b???00101000 : begin expected = 20'b000010?01000010??001; end
      11'b???01001000 : begin expected = 20'b000010?01000010??010; end

      11'b?0?00011000 : begin expected = 20'b000100?11000000?????; end
      11'b?1?00011000 : begin expected = 20'b100100?11000000?????; end
      11'b?0?00111000 : begin expected = 20'b100100?11000000?????; end
      11'b?1?00111000 : begin expected = 20'b000100?11000000?????; end
      11'b1??10011000 : begin expected = 20'b100100011000000?????; end
      11'b0??10011000 : begin expected = 20'b000100011000000?????; end
      11'b1??11011000 : begin expected = 20'b100100111000000?????; end
      11'b0??11011000 : begin expected = 20'b000100111000000?????; end
      11'b01?10111000 : begin expected = 20'b100100011000000?????; end
      11'b00?10111000 : begin expected = 20'b100100011000000?????; end
      11'b10?10111000 : begin expected = 20'b000100011000000?????; end
      11'b01?11111000 : begin expected = 20'b100100111000000?????; end
      11'b00?11111000 : begin expected = 20'b100100111000000?????; end
      11'b10?11111000 : begin expected = 20'b000100111000000?????; end

      11'b??????11011 : begin expected = 20'b110000?1100000110???; end
      11'b??????11001 : begin expected = 20'b100001?0100000110???; end
      11'b??????01101 : begin expected = 20'b001000??110010101???; end
      11'b??????00101 : begin expected = 20'b001000?1100000101???; end
      default         : begin expected = 20'b?????????????????;    end
    endcase
  end

  initial begin
    $display("===================================== In queue =====================================");

    for(int i = 0; i < 2048; i++) begin
      $display("Running on test %0d", i);
      test_arr = i;
      #10;
      assert (output_data ==? expected) else begin
        $display("Wrong answer on test %0d: ouput is %b, expected %b", i, output_data, expected);
      end
    end

    $display("===================================== Accepted =====================================");
    $finish;
  end

endmodule
