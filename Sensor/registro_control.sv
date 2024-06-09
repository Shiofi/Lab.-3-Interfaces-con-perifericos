`timescale 1ns / 1ps

module registro_control( input logic clk,
                         input logic rst,
                         input logic [31:0] IN1,
                         input logic [31:0] IN2,
                         input logic WR1,
                         input logic WR2,
                         output logic [31:0] OUT
                         );
                         
always_ff @(posedge clk) begin
    if (rst)
        OUT <= 'b0;
    else if (WR1)
        OUT <= IN1;
    else if (WR2)
        OUT <= IN2;
    else 
        OUT <= OUT;
end                    
                         
endmodule