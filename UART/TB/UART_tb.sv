`timescale 1ns / 1ps

module UART_tb();
    //inputs
    logic clk;
    logic reset;
    logic tx_start;
    logic [7:0] data_in;
    logic rx;
    
    //outputs
    logic tx_rdy;
    logic rx_data_rdy;    
    logic [7:0] data_out;
    logic tx;
    logic bit_send;
    logic bit_new;
    
    always #10 clk = !clk;
    
    UART dut(
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_rdy(tx_rdy),
        .rx_data_rdy(rx_data_rdy),
        .data_in(data_in),
        .data_out(data_out),
        .rx(rx),
        .tx(tx),
        .bit_send(bit_send),
        .bit_new(bit_new) 
    );
    
    initial begin
    clk = 1;
    reset = 1;
    tx_start = 0;
    data_in = 0;
    rx = 0;
    #20;
    reset = 0;
    #30;
    data_in = 'h55;
    #10;
    tx_start = 1;
    #100;
    //tx_start = 0;
    #75;
    //rx = 1;
    //while (reset != 1) begin
    //rx = !tx;
    //#10;
    //end
    end
endmodule
