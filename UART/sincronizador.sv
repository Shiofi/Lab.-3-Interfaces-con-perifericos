`timescale 1ns / 1ps

module sincronizador(
    input   logic   clk_i, 
    input   logic   button_i, 
    output  logic   button_o 
);

   
    logic button_prev; 

    // sincronizar el botón con el reloj
    always_ff @(posedge clk_i) begin
        button_prev <= button_i;
    end

    // detectar la presión del botón y generar un pulso de un ciclo de reloj
    always_comb begin
        if (button_prev == 1'b0 && button_i == 1'b1) begin
            button_o <= 1'b1;
        end else begin
            button_o <= 1'b0;
        end
    end

endmodule
