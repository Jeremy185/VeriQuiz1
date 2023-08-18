`timescale 1ns / 1ps


module fifo_top #(parameter WIDTH = 32, DEPTH = 16)
    (
    input  logic                            clk_i,
    input  logic                            rst_i,
    input  logic                            push_i,
    input  logic [WIDTH - 1:0]              data_i,
    input logic                             pop_i,
    
    output logic [WIDTH - 1:0]              data_o,
    output logic                            full_o,
    output logic                            pnding_o

);
    
logic [$clog2(DEPTH) - 1:0] sel_mux;                // Puntero
logic [WIDTH - 1:0] data_out;                       // Dato de salida
logic [WIDTH - 1:0][DEPTH - 1:0] data_in_mux;      // Dato de salida de los registros hacia el mux, ALGO NO CUADRA EN EL ESQUEMATICO


// Maquina de control
control_fifo #(WIDTH,DEPTH) control(
    .clk_i    (clk_i),
    .rst_i    (rst_i),
    .push_i   (push_i),
    .pop_i    (pop_i),
    .full_o   (full_o),
    .pnding_o (pnding_o),
    .selmux_o (sel_mux)
);

// Multiplexor
mux #(WIDTH, DEPTH ) mux_fifo
(
   .sel_i (sel_mux),
   .data_i (data_in_mux),
   .data_o (data_out)
);

// Los DEPTH flip flops conectados 
Registros #(WIDTH,DEPTH) registros
 (
    .rst_i          (rst_i),
    .push_i         (push_i),
    .data_i         (data_i),   
    .data_o         (data_in_mux)
    );
  
assign data_o = data_out;
 
endmodule