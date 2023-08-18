`timescale 1ns / 1ps

module mux#( parameter WIDTH = 32, DEPTH = 16 )
    (
    input  logic [$clog2(DEPTH) - 1:0]      sel_i, //Pasa a bits la dirección del dato, es el puntero 
    input  logic [WIDTH - 1:0][DEPTH - 1:0] data_i, 
    
    output logic [WIDTH - 1:0]              data_o
    );
    
    
    always_comb begin
        data_o = data_i[sel_i];  
    end 
    
    
    
endmodule
