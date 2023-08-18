`timescale 1ns / 1ps

module control_fifo #(parameter WIDTH = 32, DEPTH = 16)
    (
    input  logic                            clk_i,
    input  logic                            rst_i,
    input  logic                            push_i,
    input logic                             pop_i,
    
    output logic                            full_o,
    output logic                            pnding_o,
    output logic [$clog2(DEPTH) - 1:0]      selmux_o
    
    );
       
    always_ff@(posedge clk_i or negedge rst_i) begin
        if (!rst_i)begin
            selmux_o <= 0;
        end else begin
            case({push_i,pop_i})
                2'b00: begin
                    selmux_o <= selmux_o;
                end
                2'b01: begin // POP
                   if(selmux_o == 0) begin
                        selmux_o <= 0;                  
                   end else begin
                        selmux_o <= selmux_o - 1;
                   end
                end
                2'b10: begin  // PUSH
                    if(selmux_o == DEPTH) begin
                        selmux_o <= selmux_o;                  
                    end else begin
                        selmux_o <= selmux_o + 1;
                    end
                end
                2'b11: begin  
                   selmux_o <= selmux_o;
                end
            endcase
        end
        
        pnding_o <= (selmux_o == '0) ? {1'b0} : {1'b1}; 
        full_o <= (selmux_o == DEPTH) ? {1'b1} : {1'b0};
    
    end
 endmodule       
        
