module InsMEM(
        input [31:0] curPC,     
        output reg[6:0] op,     
        output reg[2:0] funct3,  
        output reg[6:0] funct7,
        output reg[4:0] rs1,     
        output reg[4:0] rs2,     
        output reg[4:0] rd,     
        output reg[24:0] imm,    
        output reg [31:0] instr  
    );
 reg [31:0] RAM[127:0];

    initial begin
        op = 7'b0000000;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        rs1 = 5'b00000;
        rs2 = 5'b00000;
        imm = 20'b00000000000000000000;

  
    end

always@(curPC)
    begin
         instr[31:0] = RAM[curPC/4];
    end

   always@(instr) 
    begin
        op = instr[6:0];
        rs1 = instr[19:15];
        rs2 = instr[24:20];
        rd = instr[11:7];
        funct3 = instr[14:12];
        funct7 = instr[31:25];
        imm = instr[31:7];
     end


endmodule

