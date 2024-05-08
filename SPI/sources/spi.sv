`timescale 1ns / 1ps

module controlador_SPI (
  input logic           clk_i,    
  input logic           rst_i,  
  input logic           MISO_i,   
  input logic   [7:0]   tx_data_i,  
  input logic           send_i,  
  input logic   [8:0]   n_tx_end_i, 
  input logic           all_1s_i, 
  input logic           all_0s_i, 
  
  output logic          cs_ctrl_o,      
  output logic          MOSI_o,           
  output logic          sclk_o,           
  output logic          tx_done_o,  
  output logic  [7:0]   rx_data_o,  
  output logic  [9:0]   n_rx_end_o,  
  output logic          we_2_o,
  output logic  [31:0]  instruccion_o
);

  localparam [1:0]
    IDLE          =     2'b00,
    TRANSMIT      =     2'b01,
    REESCRIBIR    =     2'b10;

  logic [1:0]   state;
  logic [4:0]   bit_count;
  logic         control_transmision;
  logic [1:0]   last_state = IDLE;
  logic [4:0]   trans_count;

  always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) 
    begin
         state                <=    IDLE;
         last_state           <=    IDLE;
         bit_count            <=    5'b0;
         tx_done_o            <=    1'b0;
         cs_ctrl_o            <=    1'b1;
         MOSI_o                 <=    1'b0;
         sclk_o                 <=    1'b0;
         n_rx_end_o           <=    10'b0; //check # bits
         rx_data_o            <=    8'b0;
         we_2_o                 <=    0;
         control_transmision  <=    0;
         trans_count          <=    0;
    end
    else 
    begin
      case (state)
        IDLE: 
        begin
          if (send_i) 
          begin
            // Iniciar transmisiÃ³n
            cs_ctrl_o <= 1'b0;
            
            if (all_1s_i) 
               begin
                  MOSI_o <= 1'b1;
               end 
               else if (all_0s_i) 
               begin
                  MOSI_o <= 1'b0;
               end 
               else 
                  begin
                     MOSI_o <= tx_data_i[7];
                  end

            // Iniciar contador de bits
               bit_count <=   5'b0;

            // Primer flanco de reloj
               sclk_o     <=    1'b1;
               state    <=    TRANSMIT;
             end else 
             begin
               sclk_o <= 1'b0;
             end
        end

       TRANSMIT: 
         begin               
            sclk_o <= ~sclk_o;
            if (sclk_o == 1'b1) 
               begin
                  if (all_1s_i) 
                     begin
                        MOSI_o <= 1'b1;
                     end 
                     else if (all_0s_i) 
                        begin
                           MOSI_o <= 1'b0;
                        end else 
                           begin
                              MOSI_o <= tx_data_i[7-bit_count];
                           end

                     bit_count <= bit_count + 1;

                     if (bit_count == 8) 
                        begin
                           bit_count   <= 5'b0;
                           state       <= REESCRIBIR;
                           tx_done_o   <= 1'b1;
                           cs_ctrl_o   <= 1'b1;
                           n_rx_end_o  <= n_rx_end_o + 1;
                        end

                     if (n_rx_end_o < n_tx_end_i + 1) 
                        begin
                           control_transmision = send_i;
                        end else if (n_rx_end_o > n_tx_end_i + 1) 
                        begin
                           control_transmision = !send_i;
                        end

                     end else begin
                  rx_data_o <= {rx_data_o[6:0], !MISO_i};
                  end
               end

        
        REESCRIBIR: begin
  if (clk_i == 1'b1) begin
    if (trans_count == 1) begin
      we_2_o <= 1;
    end else if (trans_count == 14) begin
      we_2_o <= 0;
      state <= IDLE; // Return to IDLE state
      sclk_o <= 1'b0;
      trans_count <= 0; // Reset trans_count
    end

    trans_count <= trans_count + 1;
  end
end
        
        default: state <= IDLE;
      endcase
    end
  end

  assign instruccion_o = {6'b000000, n_rx_end_o, 3'b000, n_tx_end_i, all_0s_i, all_1s_i, 1'b0, control_transmision};
  
endmodule

