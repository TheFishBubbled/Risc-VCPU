
module Extend(
        input [24:0] imm,            
        input [2:0] ExtSel,  
        output reg [31:0] extend 
    );

always@(imm or ExtSel)
    begin
        case (ExtSel)
            3'b000://I direct break extension
            begin
                extend[11:0] = imm[24:13];
                extend[31:12] = (imm[24] ? 20'hfffff : 20'h00000);
            end
            3'b101: //I 
            begin
                extend[4:0] = imm[16:13];
                extend[31:5] = 27'b000000000000000000000000000;
            end
            3'b001: //S
            begin
                extend[4:0] = imm[4:0];
                extend[11:5] = imm[24:18];
                extend[31:12] = (imm[24] ? 20'hfffff : 20'h00000);
            end
            3'b010: //SB
            begin
                extend[0] = 0;
                extend[11] = imm[0];
                extend[4:1] = imm[4:1];
                extend[10:5] = imm[23:18];
                extend[12] = imm[24];
                extend[31:13] = (imm[24] ? 19'b1111111111111111111 : 19'b0000000000000000000);
            end
            3'b011:  //U
            begin
                extend[11:0] = 12'h000;
                extend[31:12] = imm[24:5];
            end
            3'b100:  //UJ
            begin
                extend[0] = 0;
                extend[19:12] = imm[12:5];
                extend[11] = imm[13];
                extend[10:1] = imm[23:14];
                extend[20] = imm[24];
                extend[31:21] = (imm[24] ? 11'b11111111111 : 11'b00000000000);
            end
        endcase
end
endmodule
