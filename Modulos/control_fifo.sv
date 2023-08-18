`timescale 1ns / 1ps

module control_fifo #(parameter WIDTH = 32, DEPTH = 16)
    (
    input  logic                            clk_i,
    input  logic                            rst_i,
    input  logic                            push_i,
    input logic                             pop_i,
    
    output logic                            full_o,
    output logic                            pnding_o,
    output logic [$clog2(DEPTH) - 1:0]      selmux_o,
    output logic                            rst_reg_o
    
    );
       
    logic [$clog2(DEPTH) - 1:0] count;
    always_ff@(posedge clk_i or negedge rst_i) begin
        if (!rst_i)begin
            count    <= 0;
            selmux_o <= 0;
            rst_reg_o <= 0;
            
        end else begin
            case({push_i,pop_i})
                2'b00: begin
                    selmux_o <= selmux_o; //Ambos se mantienen
                    count    <= count;
                    rst_reg_o <= 0;
                end
                
                2'b01: begin // POP
                   if(count == 0) begin
                        selmux_o <= 0;
                        count    <= count;  
                        rst_reg_o <= 1;
                                      
                   end else begin
                        selmux_o <= selmux_o - 1;
                        count    <= count - 1;
                        rst_reg_o <= 0;
                   end
                end
                
                
                2'b10: begin  // PUSH
                    if(count == 0) begin
                        selmux_o <= 0;
                        count    <= count + 1;
                        rst_reg_o <= 0;
                        
                    end else if (count == DEPTH - 1) begin
                        selmux_o <= count; 
                        count    <= count;
                        rst_reg_o <= 0;
             
                    end else begin
                        selmux_o <= selmux_o + 1;
                        count    <= count + 1;
                        rst_reg_o <= 0;
                    end
                end
                
                2'b11: begin  
                   selmux_o <= selmux_o;
                   count    <= count;
                   rst_reg_o <= 0;
                end
            endcase
        end
        
        pnding_o <= (count > '0 && selmux_o < (DEPTH - 1)) ? {1'b1} : {1'b0}; 
        full_o <= (selmux_o == DEPTH-1) ? {1'b1} : {1'b0};
    
    end
 endmodule       
        
