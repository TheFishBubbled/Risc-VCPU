`timescale 10ps / 1ps
module PC(
        input CLK,               
        input Reset,            
        input PCSrc,             
        input [31:0] AluOutput,  
        output reg[31:0] curPC,  
        output reg[31:0] nextPC  
    );

   initial begin
        curPC <= 0; 
        nextPC <= 4;
    end



    always@(negedge CLK)
    begin
        case(PCSrc)   
            1'b0:   nextPC <= curPC + 4;
            1'b1:   nextPC <= AluOutput;
            default:  nextPC <= curPC + 4;
        endcase
    end


    always@(posedge CLK or posedge Reset)
    begin
        if(Reset) 
            curPC <= 0;
        else 
            curPC <= nextPC;
    end


  
  
endmodule
