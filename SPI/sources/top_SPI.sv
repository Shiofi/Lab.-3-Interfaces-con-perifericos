`timescale 1ns / 1ps

module top_interfaz_periferico_SPI(
    input logic clk_in1, 
    input logic reset_pi, 
    input logic inicio_pi, 
    input logic MISO,
    
    output logic MOSI, 
    output logic sclk_o, 
    output logic cs_ctrl_o, 
    output logic done_o, 
    
    output logic [7:0] memtest,
    output logic [6:0] seg_o, 
    output logic [3:0] an_o 
   
    );
    
    logic clk_i;
    logic [31:0] salida;
    logic wr_1;
    logic reg_sel;
    logic [31:0] addr;
    logic [31:0] entrada;
    logic [7:0] testmemo;
    logic clk_1kHz;
    
    clk_wiz_0 instance_name(
    .clk_out1(clk_i),     // output clk_out1
    .clk_in1(clk_in1)
    );      // input clk_in1
    
    generador_datos_control generador_dat_cont (
        .clk(clk_i),
        .rst(reset_pi),
        .inicio_i(inicio_pi),
        .salida_i(salida),
        .wr_o(wr_1),
        .reg_sel_o(reg_sel),
        .entrada_o(entrada),
        .addr_o(addr)
        //.salida_test(salida_test)
    );
   
    top control_interfaz_spi(
        .clk(clk_i),   
        .rst(reset_pi),  
        .miso(MISO),    
        .reg_sel(reg_sel),
        .wr(wr_1),
        .in_i(entrada),
        .addr_i(entrada), //aver
        .cs_control(cs_ctrl_o),  
        .mosi(MOSI),      
        .sclk(sclk_o),       
        .tx_done_o(done_o),  
        .out_o(salida),
        .testmemo(testmemo),
        .memdir(memtest)
    );
    
    display_7seg disp_7segmentos (
        .dato(testmemo),
        .clk(clk_1kHz),
        .seg(seg_o),
        .an(an_o)
    );
    
    clk_7_segmentos reloj_display(
        .clk(clk_i),
        .rst(reset_pi),
        .clk_1kHz_o(clk_1kHz)
    );
   
endmodule
/*
module top_interfaz_periferico_SPI(
    input logic clk_in1,
    input logic reset_pi,
    input logic inicio_pi,

    output logic MOSI,
    output logic sclk_o,
    output logic cs_ctrl_o,
    output logic done_o,
    output logic [6:0] seg_o,
    output logic [3:0] an_o
);
    logic slave_miso;
    reg [7:0] salida_slave;
    reg [7:0] salida_slave_reg;
    logic clk_i;
    logic [31:0] salida;
    logic wr_1;
    logic reg_sel;
    logic [31:0] addr;
    logic [31:0] entrada;
    logic clk_1kHz;

    clk_wiz_0 instance_name(
        .clk_out1(clk_i),
        .clk_in1(clk_in1)
    );

    pmod_als_spi_slave pmod_slave (
        .clk(clk_i),
        .rst_n(reset_pi),
        .cs_n(cs_ctrl_o),
        .sclk(sclk_o),
        .miso(slave_miso),
        .data_out_reg(salida_slave)
    );

    always @(posedge clk_i) begin
        salida_slave_reg <= salida_slave;
    end

    top control_interfaz_spi(
        .clk(clk_i),
        .rst(reset_pi),
        .miso(slave_miso),
        .reg_sel(reg_sel),
        .wr(wr_1),
        .in_i(entrada),
        .addr_i(entrada),
        .cs_control(cs_ctrl_o),
        .mosi(MOSI),
        .sclk(sclk_o),
        .tx_done_o(done_o),
        .out_o(salida)
    );

    display_7seg disp_7segmentos (
        .dato(salida_slave_reg),
        .clk(clk_1kHz),
        .seg(seg_o),
        .an(an_o)
    );

    clk_7_segmentos reloj_display(
        .clk(clk_i),
        .rst(reset_pi),
        .clk_1kHz_o(clk_1kHz)
    );

endmodule


