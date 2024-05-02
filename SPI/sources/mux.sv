module mux_2_to_1 (
    input wire clk,
    input wire reset,
    input wire sel,
    input wire [31:0] in1,
    input wire [31:0] in2,
output reg [31:0] out
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