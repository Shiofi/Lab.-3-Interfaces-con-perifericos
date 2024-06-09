`timescale 1ns / 1ps

module mux1(
    input logic [31:0] in_1,
    input logic [31:0] in_2,
    input logic reg_sel_i,
    output logic [31:0] out
    );
    
always_comb begin
    if (reg_sel_i)
        out = in_2;
    else
        out = in_1;
end
endmodule