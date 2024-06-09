`timescale 1ns / 1ps

module ControlReg (
    input logic clk, rst,
    input logic [31:0] IN1,
    input logic [31:0] IN2,
    input logic WR1,
    input logic WR2,
    output logic [31:0] out
);

always_ff @(posedge clk)begin 
    if (rst) out <= 'b0 ;
    else if (WR1) out <= IN1;
    else if (WR2) out <= IN2;
end
endmodule