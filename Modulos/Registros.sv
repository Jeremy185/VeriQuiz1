`timescale 1ns / 1ps

module Registros#( parameter WIDTH = 32, DEPTH = 4 ) //Derecha ancho del vector
                                                      //Izquierda Tama?o de los registros 
    (
    input  logic                            rst_i,
    input  logic                            push_i,
    input  logic [WIDTH - 1:0]              data_i,  // Dato que entra al primer flip flop  
      
    output logic [DEPTH - 1:0][WIDTH - 1:0] data_o   //Salida de este modulo.
    );
    
    genvar i;
    generate 
        for (i = 0; i < DEPTH; i = i + 1)begin: register
        
            if (i == 0)begin //Mete el dato en el primer registro 
                Registro #(.N(WIDTH)) regs(
                    .rst_i      (rst_i),
                    .push_i     (push_i),
                    .data_i     (data_i),
                    .data_o     (data_o[i]) //i=0
                    );
                    
            end else begin //
                Registro #(.N(WIDTH)) regs(
                    .rst_i      (rst_i),
                    .push_i     (push_i),
                    .data_i     (data_o[i - 1]),  //Ejemplo: i 
                    .data_o     (data_o[i])
                    );
            end
                
            
        end 
    endgenerate
    
endmodule
