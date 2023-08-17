`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2023 04:43:50 PM
// Design Name: 
// Module Name: Registro
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Registro #(
    parameter N = 32
    )
    (
    input  logic         clk_i,
    input  logic         rst_i, 
    input  logic         push_i, //Entrada que al ser verdadera entoncer manda el valor a la salida
    input  logic [N-1:0] data_i,
    output logic [N-1:0] data_o
    );
    
    //Se crea el registro parametrizable
    always_ff@(posedge clk_i)begin 
    
        if(!rst_i)begin //Reset
            data_o <= '0;
            
        end else if (push_i)begin // Si recibe el push
            data_o <= data_i;
            
        end else //Si no recibe nada
            data_o <= data_o;
            
    end

endmodule
