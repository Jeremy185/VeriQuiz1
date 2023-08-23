`timescale 1ns / 1ps


module fifo_top #(parameter WIDTH = 32, DEPTH = 4)
    (
    input  logic                            clk_i,  
    input  logic                            rst_i,  
    input  logic                            push_i, 
    input  logic [WIDTH - 1:0]              data_i,  //Dato de entrada que se le hara push
    input  logic                            pop_i,
    
    output logic [WIDTH - 1:0]              data_o,  //Dato de salida despues de hacer pop
    output logic                            full_o,  //Señal de que los registros ya estan llenos 
    output logic                            pnding_o //indica que hay datos que se pueden procesar

);
    
    logic [$clog2(DEPTH) - 1:0]      sel_mux;           // Puntero al registro
    logic [DEPTH - 1:0][WIDTH - 1:0] data_in_mux;       // Dato de salida de los registros hacia la entrada del mux
    logic                            rst_reg_o;
    logic                            full;
    
    // Maquina de control
    control_fifo #(.WIDTH(WIDTH),.DEPTH(DEPTH)) control(
        .clk_i    (clk_i),
        .rst_i    (rst_i),
        .push_i   (push_i),
        .pop_i    (pop_i),
        .full_o   (full),
        .pnding_o (pnding_o),
        .selmux_o (sel_mux),
        .rst_reg_o(rst_reg_o)
    );
   
    
    // Cantidad de registros DEPTH con un tamaño WIDTH
    Registros #(.WIDTH(WIDTH), .DEPTH(DEPTH)) registros
     (
        .rst_i          (rst_i&~rst_reg_o),
        .push_i         (push_i & ~full),
        .data_i         (data_i),   
        .data_o         (data_in_mux)
        );
        
        
    //Assign que funciona como multiplexor
    assign data_o = data_in_mux [sel_mux]; // selecciona unicamente el valor que indica el indice 
    
    
    //Conectando el wire full con la salida full_o
    assign full_o = full;
    
endmodule