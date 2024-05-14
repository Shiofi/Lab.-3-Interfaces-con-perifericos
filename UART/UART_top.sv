`timescale 1ns / 1ps

module UART_top(
    input   logic             clk_i,
    input   logic             reset_i,
    input   logic   [31:0]    entrada_perif_UART_i,
    input   logic             rx,
    input   logic             reg_sel_i,
    input   logic             wr_i,
    input   logic             addr_i,
    
    output  logic             tx,
    output  logic   [31:0]    salida_o
    );
    
    logic    [31:0]    instruccion_UART;
    logic              bit_send;
    logic              bit_new;
    logic              wr2_test;
    logic              tx_rdy;
    logic              rx_data_rdy;
    logic    [31:0]    control;
    logic              wr1;
    logic              wr1_datos;
    logic    [7:0]     data_out;
    logic    [7:0]     data_test;
    logic              reg_seg_o;
    logic              out;
    
    ControlReg reg_control (
        .clk(clk_i),
        .rst(reset_i),
        .IN1(entrada_perif_UART_i),
        .IN2(instruccion_UART),
        .WR1(wr1),
        .WR2(wr2_test),
        .out(out)
    );
    
   DataReg reg_datos(
        .clk(clk_i),
        .rst(reset_i),
        .IN1(entrada_perif_UART_i),
        .IN2(data_out),
        .WR1(wr1_datos),
        .WR2(rx_data_rdy),
        .OUT(data_test),
        .addr1(addr_i),
        .addr2(reg_seg_o)
    );
    
   mux control_salida(
        .reg_sel_i(reg_sel_i),
        .in_1(out),
        .in_2(data_test),
        .out(salida_o)
    );
    
    demux demux_wr(
        .wr_i(wr_i),
        .reg_sel_i(reg_sel_i),
        .out1_WR1(wr1),
        .out2_WR1(wr1_datos)
    );
    
    
    always_ff @(posedge clk_i) begin
        if (tx_rdy == 1) begin
            instruccion_UART = 32'b0;
        end
        
        if (rx_data_rdy == 1) begin
            instruccion_UART = {30'b0, 1'b1, 1'b0};
        end
    end
    
    assign wr2_test = {bit_new || bit_send};
    
endmodule
