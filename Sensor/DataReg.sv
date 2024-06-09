`timescale 1ns / 1ps

parameter N = 8;
module DataReg( input logic clk,
                       input logic rst,
                       input logic [31:0] IN1,
                       input logic [31:0] IN2,
                       input logic WR1,
                       input logic WR2,
                       input logic addr1,
                       input logic [N-1:0] addr2,
                       input logic hold_ctrl,
                       output logic [31:0] OUT
                       );

logic [31:0] registro1;
logic [31:0] registro2;            

always_ff @(*) begin
    if (rst)
        OUT <= 'b0;
    else if (addr1) 
        if (WR1)
            registro1 <= IN1;
        else if (-hold_ctrl)
            OUT <= registro1;
    else 
        if (WR2)
            registro2 <= IN2;
        else if (-hold_ctrl)
            OUT <= registro2;
end
endmodule