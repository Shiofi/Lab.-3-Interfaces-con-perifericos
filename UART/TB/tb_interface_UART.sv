`timescale 1ns / 1ps

module interfaz_UART_tb();
    logic clk_i; 
    logic reset_pi;
    logic [7:0] sw_pi;
    logic inicio_pi;
    logic enviar_dato_pi;
    logic rx;
   
    logic tx;
    logic [7:0] dato_pc; 
    
    always #1 clk_i = !clk_i;
    
    top_interfaz_periferico_UART dut(
        .clk_in1(clk_i),
        .reset_pi(reset_pi),
        .sw_pi(sw_pi),
        .inicio_pi(inicio_pi),
        .enviar_dato_pi(enviar_dato_pi),
        .rx(rx),
        .tx(tx),
        .dato_pc(dato_pc)
    );
    
    initial begin
        clk_i = 1;
        sw_pi = 0;
        inicio_pi = 0;
        enviar_dato_pi = 0;
        rx = 0;
        reset_pi = 1;
        #20;
        reset_pi = 0;
        #20;
        inicio_pi = 1;
        sw_pi = 8'hAF;
        #20;
        enviar_dato_pi = 1;
        #150
        enviar_dato_pi = 0;
        #250000
        rx = 1;
        #12000;
        rx = 0;
        #12000;
        rx = 1;
        #50000;
        rx = 0;
        #22000;
        rx = 1;
        #12000;
        rx = 0;
        #22000;
        rx = 1;
    end
endmodule
