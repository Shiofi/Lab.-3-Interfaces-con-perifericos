`timescale 1ns / 1ps
module mux_2_to_1#(parameter N=32) (
    input logic clk,
    input logic reset,
    input logic sel,
    input logic [N-1:0] in1,
    input logic [N-1:0] in2,
output logic [N-1:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 32'b0;
    end else begin
        if (sel) begin
            out <= in2;
        end else begin
            out <= in1;
        end
    end
end

endmodule
