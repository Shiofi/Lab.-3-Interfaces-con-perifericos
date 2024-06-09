`timescale 1ns / 1ps

module control_UART_FSM_tb();
    logic clk_i;
    logic reset_i;
    logic [31:0] salida_perif_UART_i;
    logic [7:0] sw_i;
    logic inicio_i;
    logic enviar_dato;
   
    logic wr_o;
    logic reg_sel_o;
    logic [31:0] entrada_perif_UART_o;
    logic [7:0] dato_recibido_o;
    
    always #10 clk_i = !clk_i;
    
    control_UART_FSM dut(
        .clk_i(clk_i),
        .reset_i(reset_i),
        .salida_perif_UART_i(salida_perif_UART_i),
        .sw_i(sw_i),
        .inicio_i(inicio_i),
        .enviar_dato(enviar_dato),
        .wr_o(wr_o),
        .reg_sel_o(reg_sel_o),
        .entrada_perif_UART_o(entrada_perif_UART_o),
        .dato_recibido_o(dato_recibido_o)
    );
    
    initial begin
        clk_i = 1;
        enviar_dato = 0;
        inicio_i = 0;
        sw_i = 0;
        salida_perif_UART_i = 0;
        reset_i = 1;
        #30;
        reset_i = 0;
        #10;
        inicio_i = 1;
        #10;
        sw_i = 8'hAF;
        #30;
        enviar_dato = 1;
        #10;
        enviar_dato = 0;
        #50;
        salida_perif_UART_i = 32'b10;
        #10
        salida_perif_UART_i = 8'h5A;
    end
endmodule
