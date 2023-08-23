`timescale 1ns / 1ps

module Registro #( parameter N = 32)
    (
    input  logic         rst_i, 
    input  logic         push_i, //Entrada que al ser verdadera entoncer manda el valor a la salida
    input  logic [N-1:0] data_i,
    output logic [N-1:0] data_o
    );
    
    //Se crea un unico registro parametrizable
    always_ff@(posedge push_i or negedge rst_i)begin // Es con reset asincronico 
    
        if(!rst_i)begin 
            data_o <= '0;    
            
        end else if (push_i) begin //si recibe algo
            data_o <= data_i;
            
        end else //Si no recibe nada
            data_o <= data_o;
    end

endmodule
