`timescale 1ns / 1ps

parameter N = 8;
module registro_datos( input logic clk,
                       input logic rst,
                       input logic [31:0] IN1,
                       input logic [31:0] IN2,
                       input logic WR1,
                       input logic WR2,
                       input logic [N-1:0] addr1,
                       input logic [N-1:0] addr2,
                       input logic hold_ctrl,
                       output logic [31:0] OUT
                       );

logic [N-1:0] [2**N-1:0] registro;            

always_ff @(posedge clk) begin
    if (rst)
        OUT <= 'b0;
    else if (WR1) begin
        registro [addr1] <= IN1;
        if (~hold_ctrl)
            OUT <= registro [addr1];
        end
    else if (WR2) begin
        registro [addr2] <= IN2;
        if (~hold_ctrl)
            OUT <= registro [addr2];
        end
end
endmodule
