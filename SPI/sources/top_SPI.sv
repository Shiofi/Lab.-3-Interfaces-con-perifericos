`timescale 1ns / 1ps

module top_interfaz_periferico_SPI(
    input logic clk_pi, 
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
    
   clk_wiz_0 inst (
  // Clock out ports  
  .clk_out1(clk_i),
  // Status and control signals               
  .reset(reset_pi), 
 // .locked(locked),
 // Clock in ports
  .clk_in1(clk_pi)
  );
    
    generador_datos_control generador_dat_cont (
        .clk_i(clk_pi),
        .reset_i(reset_pi),
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
        .addr_i(entrada),
        .cs_control(cs_ctrl_o),  
        .mosi(MOSI),      
        .sclk(sclk_o),       
        .tx_done_o(done_o),  
        .out_o(salida),
        .testmemo(testmemo),
        .memdir(memtest)
    );
    
    display_7seg disp_7segmentos (
        .dato_i(testmemo),
        .clk_i(clk_1kHz),
        .seg_o(seg_o),
        .an_o(an_o)
    );
    
    clk_7_segmentos reloj_display(
        .clk_i(clk_i),
        .reset_i(reset_pi),
        .clk_1kHz_o(clk_1kHz)
    );
   
endmodule
