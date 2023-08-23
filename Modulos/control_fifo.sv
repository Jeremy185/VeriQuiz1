`timescale 1ns / 1ps

module control_fifo #(parameter WIDTH = 32, DEPTH = 16)
    (
    input  logic                            clk_i,
    input  logic                            rst_i,
    input  logic                            push_i, //meter un dato
    input logic                             pop_i, //sacar un dato
    
    output logic                            full_o, //Memoria llena
    output logic                            pnding_o, //Datos disponibles para procesar
    output logic [$clog2(DEPTH) - 1:0]      selmux_o, //Seleccion del dato en el mux
    output logic                            rst_reg_o //vaciado completo de la memoria
    
    );
       
    logic [$clog2(DEPTH) - 1:0] count; // Es el puntero del dato que quiero leer
    
    always_ff@(posedge clk_i or negedge rst_i) begin
        if (!rst_i)begin
            count    <= 0;
            selmux_o <= 0;
            rst_reg_o <= 0;
            
        end else begin
            case({push_i,pop_i})
                2'b00: begin //No sucede nada
                    selmux_o <= selmux_o; //Ambos se mantienen
                    count    <= count;
                    rst_reg_o <= 0;
                end
                
                2'b01: begin // POP: Se tira el dato a la salida y el contador disminuye
                   if(count == 0) begin
                        selmux_o <= 0;
                        count    <= count;  
                        rst_reg_o <= 1; //Si se hace push y el contador es 0 entonces resetea todos los registros
                                      
                   end else begin
                        selmux_o <= selmux_o - 1;
                        count    <= count - 1;
                        rst_reg_o <= 0;
                   end
                end
                
                
                2'b10: begin  // PUSH: se agrega un dato y el contador aumenta
                    if(count == 0) begin //Si count es 0 mantiene el puntero en 0 y aumenta count
                        selmux_o <= 0;
                        count    <= count + 1;
                        rst_reg_o <= 0;
                        
                    end else if (count == DEPTH - 1) begin //Si esta lleno mantiene el puntero igual
                        selmux_o <= count; 
                        count    <= count;
                        rst_reg_o <= 0;
             
                    end else begin 
                        selmux_o <= selmux_o + 1;
                        count    <= count + 1;
                        rst_reg_o <= 0;
                    end
                end
                
                2'b11: begin //Si se tocan al mismo tiempo, sale un dato y se agrega otro
                   selmux_o <= selmux_o;
                   count    <= count;
                   rst_reg_o <= 0;
                end
            endcase
        end
        
      
        pnding_o <= (count == 0) ? {1'b0} : {1'b1};  // Se desactiva cuando ya no hay elementos en los registros
        full_o <= (selmux_o == DEPTH-1 && count == DEPTH-1) ? {1'b1} : {1'b0}; //Indica que los registros estan llenos.
    
    end
 endmodule       
        
