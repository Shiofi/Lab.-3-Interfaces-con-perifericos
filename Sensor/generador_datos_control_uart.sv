`timescale 1ns / 1ps

module generador_datos_control_uart(
    input logic               clk_i,
    input logic               reset_i,
    input logic     [31:0]    salida_i,
    output logic              wr_i,
    output logic              reg_sel_i,
    output logic    [31:0]    entrada_i,
    output logic    [31:0]    addr_i
    );
    
    localparam [2:0]
        IDLE = 3'b000,
        ESCRIBIR_DATOS = 3'b001,
        ESCRIBIR_INSTRUCCION = 3'b010,
        LEER_INSTRUCCION = 3'b011,
        LEER_DATOS = 3'b100;
        
    logic   [2:0]   state;
    logic   [7:0]   cuenta_dato_dir;
    logic   [24:0]  cuenta_clk;
    
    always @(posedge clk_i) begin
        if (reset_i) begin
            state <= IDLE;
            wr_i <= 0;
            reg_sel_i <= 0;
            entrada_i <= 0;
            cuenta_dato_dir <= 0;
            cuenta_clk <= 0;
            addr_i <= 0;
        end
        
        else begin
            case (state)
                IDLE: begin
                    if (entrada_i) begin
                        state <= ESCRIBIR_DATOS;    
                    end
                    
                    else begin
                        state <= IDLE;
                        wr_i <= 0;
                        reg_sel_i <= 0;
                        entrada_i <= 0;
                        cuenta_dato_dir <= 0;
                        cuenta_clk <= 0;
                        addr_i <= 0;
                    end
                end
                
                ESCRIBIR_DATOS: begin
                    wr_i <= 1;
                    reg_sel_i <= 1;
                                
                    if (clk_i == 1'b1) begin
                        if (cuenta_clk == 1'b0) begin //aumentar las cuentas si hay errores
                            entrada_i <= cuenta_dato_dir;
                            addr_i <= cuenta_dato_dir;
                        end
                        
                        cuenta_clk <= cuenta_clk + 1;
                                    
                        if (cuenta_clk == 10) begin                   
                            cuenta_clk <= 0;
                            
                            if (cuenta_dato_dir == 8'hFF) begin
                                state <= ESCRIBIR_INSTRUCCION;
                                cuenta_dato_dir <= 0;
                                entrada_i <= 0;
                                addr_i <= 0;
                            end
                            
                            else begin
                                cuenta_dato_dir <= cuenta_dato_dir + 1;
                            end
                        end
                    end
                                
                end
                
                ESCRIBIR_INSTRUCCION: begin
                    wr_i <= 1;
                    reg_sel_i <= 0;
                    
                    if (clk_i == 1'b1) begin
                        if (cuenta_clk == 5) begin //aumentar las cuentas si hay errores
                            entrada_i <= 32'b00000000000000000000111111010001;
                        end
                        
                        if (cuenta_clk == 12) begin //aumentar las cuentas si hay errores
                            state <= LEER_INSTRUCCION;
                        end
                        
                        cuenta_clk <= cuenta_clk + 1;
                        
                    end
                end
                
                LEER_INSTRUCCION: begin
                    wr_i <= 0;
                    reg_sel_i <= 0;
                    
                    if (salida_i[0] == 0) begin
                        cuenta_clk <= 0;
                        cuenta_dato_dir = 0;
                        state <= LEER_DATOS;
                    end
                    
                    else begin
                        state <= LEER_INSTRUCCION;
                    end
                end
                
                LEER_DATOS: begin
                    wr_i <= 0;
                    reg_sel_i <= 1;
                    entrada_i <= addr_i;
                    
                    if (clk_i == 1'b1) begin
                        if (cuenta_clk == 1'b0) begin //aumentar las cuentas si hay errores
                            addr_i <= cuenta_dato_dir;
                        end
                        
                        cuenta_clk <= cuenta_clk + 1;
                                    
                        if (cuenta_clk == 10000000) begin                   
                            cuenta_clk <= 0;
                            
                            if (cuenta_dato_dir == 8'hFF) begin
                                state <= IDLE;
                                cuenta_dato_dir <= 0;
                                addr_i <= 0;
                            end
                            
                            else begin
                                cuenta_dato_dir <= cuenta_dato_dir + 1;
                            end
                        end
                    end
                end
            endcase
        end
    end
endmodule