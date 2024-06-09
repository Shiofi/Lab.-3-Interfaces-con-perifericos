`timescale 1ns / 1ps

module top_UART_tb();
    logic clk_i;
    logic reset_i;
   // logic wr1_test;
    logic [7:0] instuart;
    logic rx;   
    logic reg_sel_i;
    logic [7:0] data_out;
    logic tx;
    logic [7:0] instruccion_test;
    //logic we1_i_test;
    logic wr_i;
    logic [7:0] data_test;
    logic [3:0] inst_uart;
    
    always #10 clk_i = !clk_i;
    
    top_UART dut(
        .clk_i(clk_i),
        .reset_i(reset_i),
       // .wr1_test(wr1_test),
        .data_in(instuart),
        .rx(rx),
        .reg_sel_i(reg_sel_i),
        .wr_i(wr_i),
        .data_out(data_out),
        .tx(tx),
        .instruccion_test(instruccion_test),
        .ins_uart(inst_uart)
       // .we1_i_test(we1_i_test),
    );
    
    initial begin
    clk_i = 1;
    reg_sel_i = 0;
   // we1_i_test = 0;
    reset_i = 0;
    //wr1_test = 0;
    wr_i = 0;
    #20;
    reset_i = 1;
    //data_in = 8'h55;
    #30;
    reset_i = 0;
   // wr1_test = 0;
   // we1_i_test = 0;
    reg_sel_i = 1;
   // wr1_test = 1;
    wr_i = 1;
    #90;
    wr_i = 1;
    reset_i = 0;
   // we1_i_test = 1;
    reg_sel_i = 0;
   // wr1_test = 0;
    #90
    reg_sel_i = 1;
    wr_i = 0;
    //wr1_test = 0;
    #900
    reg_sel_i = 0;
    //while (reset_i != 1) begin
       // rx = !tx;
       // #10;
   // end
    #10;
    wr_i = 0;
    reg_sel_i = 1;
    //wr1_test = 0;
    end
endmodule

//PRIMERO CARGAR DATOS, LUEGO ENVIAR INSTRUCCION


