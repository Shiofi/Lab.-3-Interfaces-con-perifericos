`timescale 1ns / 1ps

module demux1(
    input logic wr_i,
    input logic reg_sel_i,
    output logic [31:0] out1_WR1,
    output logic [31:0] out2_WR1
    );
    
always_comb begin
    if (reg_sel_i)
        out2_WR1 = wr_i;
    else
        out2_WR1 = 1'b0;
end

always_comb begin 
    if (reg_sel_i)
        out1_WR1 = 1'b0;
    else 
        out1_WR1 = wr_i;
end
endmodule