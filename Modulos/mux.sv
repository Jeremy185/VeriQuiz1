`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2023 05:31:02 PM
// Design Name: 
// Module Name: mux
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


module mux#(
    parameter WIDTH = 32, DEPTH = 32
    )
    (
    input  logic [$clog2(DEPTH) - 1:0]      sel_i, //Pasa a bits la direccion del dato
    input  logic [WIDTH - 1:0][DEPTH - 1:0] data_i,
    
    output logic [WIDTH - 1:0]              data_o
    );
    
    
    always_comb begin
        data_o = data_i [sel_i];  
    end 
    
    
    
endmodule
