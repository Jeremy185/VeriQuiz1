`timescale 1ns / 1ps
`default_nettype none
`define BITS 32
`define DEPTH 4
`define TESTING
`include "fifo_top.sv"
`include "Registro.sv"
`include "Registros.sv"
`include "control_fifo.sv"

module test_registros;
  
// Inputs de la FIFO
logic                clk;                              
logic                rst;                                        
logic                push;  
logic                pop;                                     
logic [`BITS - 1:0]  data_in;

// Salidas de la FIFO     
logic                full;  
logic                pnding;                                                                           
logic [`BITS - 1:0]  data_out;           
    
// Instancia de la FIFO       
fifo_top dut(
    .clk_i    (clk),
    .rst_i    (rst),
    .push_i   (push),
    .data_i   (data_in),
    .pop_i    (pop),        
    .data_o   (data_out),
    .full_o   (full),
    .pnding_o (pnding)

);
    
initial begin

    $dumpfile("test_registros_tb.vcd");
    $dumpvars(0, test_registros);

    clk = 0;
    rst = 0;
    data_in = '0; 
    push = 0;
    pop = 0;
   
    #10;         
end   

// Creaci�n del reloj
always #5 clk = ~clk;

always@(posedge clk) begin
    test ();
end

int ciclo = 1;
int dato = 32'h000A;
int cont = 0;
int cont2 = `DEPTH;

    task test();

    
    case (ciclo)
        1: begin
            rst = 1'b1;
            pop = 1'b0;
            push = 1'b0;
            data_in = 'b0;
            ciclo = 2;    
        end
        
        2: begin    // ---------->  LLENADO
            rst = 1'b1;
            pop = 1'b0;
            push = ~push;
            data_in = dato;
            if (push == 1) begin
                $display("En el tiempo %g se hizo push al dato: %g count %g",$time,dato,test_registros.dut.control.count);
            end else if ( full == 1) begin
                ciclo = 3;
            end else begin
                dato = dato + 1;
            end
        end
        
        3: begin  // ------------> VACIADO
            rst = 1'b1;         
            push = 1'b0;
            pop = ~pop;
            data_in = dato;
            if (pop == 1) begin
                $display("En el tiempo %g se hizo pop al dato: %g count %g",$time,data_out,test_registros.dut.control.count);
            end
            if (pnding == 0) begin        
                ciclo = 4;
                #10; 
                pop = 1'b0;
                #10;  
            end
        end
        
        4: begin            // VUELVO A LLENAR       
            rst = 1'b1;
            pop = 1'b0;
            push = ~push;
            data_in = dato;
            if (push == 1) begin
                $display("En el tiempo %g se hizo push al dato: %g count %g",$time,dato,test_registros.dut.control.count);
            end else if ( full == 1) begin
                ciclo = 5;
                #10; 
                push = 1'b0;
                #10; 
            end else begin
                dato = dato + 1;
            end
         end
         
        5: begin      // -----------> PUSH CUANDO YA EST� LLENA
            rst = 1'b1;
            pop = 1'b0;
            push = 1'b1;
            data_in = dato;
            ciclo = 6;
        end
        
        6: begin       // -----------> RESET CUANDO ESTA LLENA
            rst = 1'b0;
            pop = 1'b0;
            push = 1'b0;
            ciclo = 7;
         end
                    
         7: begin       // -----------> POP CUANDO ESTA VACIA
            rst = 1'b1;
            pop = 1'b1;
            push = 1'b0;
            data_in = dato;
            ciclo = 8;
         end
         
         8: begin       // -----------> RESET CUANDO ESTA VACIA
            rst = 1'b0;
            rst = 1'b0;
            pop = 1'b0;
            push = 1'b0;
            ciclo = 9;
         end
         
         9: begin            //  --------> LLENO A LA MITAD       
            rst = 1'b1;
            pop = 1'b0;
            push = ~push;
            data_in = dato;
            if (push == 1) begin
                $display("En el tiempo %g se hizo push al dato: %g count %g",$time,dato,test_registros.dut.control.count);
                cont = cont + 1;
            end else if ( cont == (`DEPTH/2)) begin
                ciclo = 10;
            end else begin
                dato = dato + 1;
            end
         end
         
         10: begin           // ----------> RESET CUANDO ESTA A LA MITAD
            rst = 1'b0;
            pop = 1'b0;
            push = 1'b0;
            ciclo = 11;
            cont = 0;
         end
         
         11: begin         // ------------> PUSH Y POP ALEATORIOS
            rst = 1'b1;
            data_in = $urandom & 3'b111;
            pop = $urandom & 1'b1;
            push = $urandom & 1'b1;
            $display("En el tiempo %g push tiene un valor de %g y pop de %g count %g ",$time,push,pop,test_registros.dut.control.count);
            $display("El dato de entrada es: %g \nEl dato de salida es: %g",data_in,data_out);
            if(cont2 == 0) begin
                ciclo = 12;
            end else begin
                cont2 = cont2 - 1;
            end
            #10;
         end
         
         12: begin        // ------------> PUSH Y POP AL MISMO TIEMPO
            rst = 1'b1;
            pop = 1'b1;
            push = 1'b1;
            ciclo = 13;
         end
         
         13: begin
            rst = 1'b1;
            pop = 1'b0;
            push = 1'b0;
            data_in = '0;
            ciclo = 14;
         end
         
         14: begin
            $finish;
         end
         
    endcase
endtask

endmodule
