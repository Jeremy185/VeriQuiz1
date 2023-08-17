`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2023 04:48:03 PM
// Design Name: 
// Module Name: Registros
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


module Registros#(
    parameter WIDHT = 32, DEPTH = 32
    )
    (
    input  logic                            clk_i,
    input  logic                            rst_i,
    input  logic                            push_i,
    input  logic [WIDHT - 1:0]              data_i,  //Unico dato que entra desde abajo
    
    output logic [WIDHT - 1:0][DEPTH - 1:0] data_o   //Salida de este modulo
    );
    
    genvar i;
    
    generate 
        for (i = 0; i < DEPTH; i = i + 1)begin: depth
        
            if (i == 0)begin //Mete el dato en el primer registro 
                Registro regs(
                    .clk_i      (clk_i),
                    .rst_i      (rst_i),
                    .push_i     (push_i),
                    .data_i     (data_i),
                    .data_o     (data_o[i]) //i=0
                    );
                    
            end else begin //
                Registro regs(
                    .clk_i      (clk_i),
                    .rst_i      (rst_i),
                    .push_i     (push_i),
                    .data_i     (data_o[i - 1]),  //Ejemplo: i 
                    .data_o     (data_o[i])
                    );
            end
                
            
        end 
    endgenerate
    
endmodule
