`timescale 1ns / 1ps

module TOP #(
    parameter WIDHT = 32, DEPTH = 32
    )
    (
    input  logic                            clk_i,
    input  logic                            rst_i,
    input  logic                            push_i,
    input  logic [WIDHT - 1:0]              data_i,
    
    output logic [WIDHT - 1:0][DEPTH - 1:0] data_o
    );
    
    always_ff@(posedge clk_i)
        if (!rst_i)begin
            data_o <= 0;
        end 
        
        else if (push_i)begin
            
        end 
        
        
    
    
    
    
endmodule
