`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2023 05:09:43 PM
// Design Name: 
// Module Name: test_registros
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


module test_registros(

    );
    
   
    logic                     clk_i = 0;                              
    logic                     rst_i = 1;                                        
    logic                     push_i = 0;                                       
    logic [31:0]              data_i = '0;  //Unico dato que entra desde abajo   
    logic                     pop_i=0; 
    logic                     full_o=0;  
    logic                     pnding_o=0;                                                                           
    logic [31:0]              data_o;   //Salida de este modulo        
    
    initial begin
        clk_i = 0;
        forever #5 clk_i=~clk_i;
    end       
    
    fifo_top dut(
    
        .clk_i    (clk_i),
        .rst_i    (rst_i),
        .push_i   (push_i),
        .data_i   (data_i),
        .pop_i    (pop_i),
                  
        .data_o   (data_o),
        .full_o   (full_o),
        .pnding_o (pnding_o)

       );
   
    
    initial begin
        #100
        rst_i = 0;
        #100
        rst_i = 1;
        #100
        
        data_i = 31'hF2F277;
        #100
        push_i = 1;
        #10
        push_i = 0;
        #10
        
        data_i = 31'hA1A1;
        #100
        push_i = 1;
        #10
        push_i = 0;
        #10
        
        data_i = 31'hFFFF;
        #100
        push_i = 1;
        #10
        push_i = 0;
        
        data_i = 31'h2222;
        #100
        push_i = 1;
        #10
        push_i = 0;
        
        data_i = 31'h2222;
        #100
        push_i = 1;
        #10
        push_i = 0;
       
        #100
        pop_i = 1;
        #10
        pop_i = 0;
        
        #100
        pop_i = 1;
        #10
        pop_i = 0;
        
        #100
        pop_i = 1;
        #10
        pop_i = 0;
        
        #100
        pop_i = 1;
        #10
        pop_i = 0;
        
        #100
        pop_i = 1;
        #10
        pop_i = 0;
        
        data_i = 31'hA1A1;
        #100
        push_i = 1;
        #10
        push_i = 0;
        #10
        
        data_i = 31'hFFFF;
        #100
        push_i = 1;
        #10
        push_i = 0;
        
        data_i = 31'h2222;
        #100
        push_i = 1;
        #10
        push_i = 0;
        
        data_i = 31'h2222;
        #100
        push_i = 1;
        #10
        push_i = 0;
        
                
    
    
    end
    
    
    
endmodule
