`timescale 1ns / 1ps
module registro_datos_tb;

  // Inputs
  logic clk;
  logic [31:0] data_in1;
  logic [31:0] data_in2;
  logic we1;
  logic we2;
  logic reset;
  
  // Output
  logic [31:0] data_out;
  
  // Instantiate the module to be tested
  registro_datos dut (
    .clk_i(clk),
    .data_in1(data_in1),
    .data_in2(data_in2),
    .we1(we1),
    .we2(we2),
    .reset_i(reset),
    .data_out(data_out)
  );
  
  // Clock generator
  always #5 clk = ~clk;
  
  // Test case 1: write to data_in1 and read data_out
  initial begin
    //$monitor("Time=%0t data_out=%h", $time, data_out);
    clk = 0;
    reset = 1;
    we1 = 0;
    we2 = 0;
    data_in1 = 32'habcdef12;
    data_in2 = 32'h12345678;
    #10
    reset = 0;
    #20
    we1 = 1;
    #10
    we1 = 0;
    #50;
    we2 = 1;
    #10;
    we2 = 0;
  end
  
endmodule