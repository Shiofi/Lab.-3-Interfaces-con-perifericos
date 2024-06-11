`timescale 1ns / 1ps

module tb_top_interfaz_periferico_SPI;

    // Definir las señales del testbench
    logic clk_pi;
    logic reset_pi;
    logic inicio_pi;
    logic MISO;
    logic MOSI;
    logic sclk_o;
    logic cs_ctrl_o;
    logic done_o;
    logic [7:0] memtest;
    logic [6:0] seg_o;
    logic [3:0] an_o;
    
    // Instanciar el módulo top_interfaz_periferico_SPI
    top_interfaz_periferico_SPI uut (
        .clk_pi(clk_pi),
        .reset_pi(reset_pi),
        .inicio_pi(inicio_pi),
        .MISO(MISO),
        .MOSI(MOSI),
        .sclk_o(sclk_o),
        .cs_ctrl_o(cs_ctrl_o),
        .done_o(done_o),
        .memtest(memtest),
        .seg_o(seg_o),
        .an_o(an_o)
    );

    // Generar el reloj
    initial begin
        clk_pi = 0;
        forever #5 clk_pi = ~clk_pi; // Periodo de 10 ns
    end

    // Proceso de prueba
    initial begin
        // Inicialización de señales
        reset_pi = 1;
        inicio_pi = 0;
        MISO = 0;

        // Liberar reset después de un tiempo
        #20 reset_pi = 0;

        // Escenario de prueba 1
        #30 inicio_pi = 1;
        #10 inicio_pi = 0;

        // Simular datos en MISO y observar memtest, seg_o, an_o
        #50 MISO = 1;
        #10 MISO = 0;
        #10 inicio_pi = 1;
        #10 inicio_pi = 0;

        // Escenario de prueba 2
        #70 inicio_pi = 1;
        #10 inicio_pi = 0;
        #10 MISO = 1;
        #10 MISO = 0;

        // Escenario de prueba 3
        #100 inicio_pi = 1;
        #10 inicio_pi = 0;
        #20 MISO = 1;
        #10 MISO = 0;

        // Escenario de prueba 4 - Cambiar memtest, seg_o y an_o
        #130 inicio_pi = 1;
        #10 inicio_pi = 0;
        #10 MISO = 1;
        #10 MISO = 0;
        #20 MISO = 1;
        #10 MISO = 0;

        // Escenario de prueba 5
        #160 inicio_pi = 1;
        #10 inicio_pi = 0;
        #20 MISO = 1;
        #10 MISO = 0;
        #20 MISO = 1;
        #10 MISO = 0;

        // Finalizar la simulación
        #200 $finish;
    end
endmodule
