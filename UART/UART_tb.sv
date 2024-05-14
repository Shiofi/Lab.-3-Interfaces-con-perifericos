`timescale 100us / 1ns


module testbench;
////INPUT/////////////////
    parameter N = 7;
    logic clk;
    logic reset;
    logic tx_start;
    logic [N:0] data_in;
    logic rx;
////OUTPUT///////////////
    logic tx_rdy;
    logic rx_data_rdy;
    logic [N:0] data_out;
    logic tx;
    
    
    UART dut(
        .clk(clk),
        //.locked(locked)
        .reset(reset),
        .tx_start(tx_start),
        .tx_rdy(tx_rdy),
        .rx_data_rdy(rx_data_rdy),
        .data_in(data_in),
        .data_out(data_out),
        .rx(rx),
        .tx(tx)
        
    );


    initial begin
        clk = 0;
        //forever #1 clk = ~clk; // Genera un ciclo de clock de 100Mhz si se usa el timescale de 10us / 100ns
        forever #0.00005 clk = ~clk; //100Mhz tienen 10ns de periodo
    end
    
    initial begin
     reset=1;
     tx_start=0;
     data_in=0;
     rx=0;
     #0.0003;
        reset = 0;
     
     #1;
        tx_start=1;
        rx=1;
        data_in=8'h9D;
     #1;
        rx=1;
        tx_start=0;
        data_in=8'h9D;
        
     #1;
     
     $finish; 
    end
endmodule
