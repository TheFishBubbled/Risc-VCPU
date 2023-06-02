module RegisterFile(
    input CLK,              //????
    input immres,      
    input [4:0] rs1,      
    input [4:0] rs2,      
    input [4:0] WriteReg,  
    input [31:0] AluOutput, 
    input [31:0] extend,  
    input [31:0] Datain, 
    input [31:0] PC,    
    input [1:0] cmp,      
    input [1:0] RegDst,    
    input RegWr,            
    output reg[31:0] DB, 
    output reg[31:0] ReadData1,
    output reg[31:0] ReadData2  
);

reg [31:0] regFile[0:31];
integer i;

initial begin
	for(i=0;i<32;i=i+1) begin
	regFile[i]=0;
	end
end

always@(rs1 or rs2 or CLK) 
begin
    if (CLK) begin
        ReadData1 = (rs1!=0)?regFile[rs1]:0;
        ReadData2 = (rs2!=0)?regFile[rs2]:0;
    end
end

always@(negedge CLK) 
begin
    if(WriteReg!=0) begin
    if(immres & RegWr) begin
	$display("x%d = %h",WriteReg,extend);
        regFile[WriteReg] = extend;
        DB = extend;
    end
    else begin
        if(RegWr)begin
     case (RegDst)
                2'b00: begin
		    $display("x%d = %h",WriteReg,AluOutput);
                    regFile[WriteReg] = AluOutput;
                    DB = AluOutput;
                end 
                2'b01: begin
		    $display("x%d = %h",WriteReg,Datain);
                    regFile[WriteReg] = Datain;
                    DB = Datain;
                end 
                2'b10: begin
		    $display("x%d = %h",WriteReg,PC+4);
                    regFile[WriteReg] = PC+4;
                    DB = PC+4;
                end 
                2'b11: begin
		    $display("x%d = %h",WriteReg,{31'b0, cmp[0]});
                    regFile[WriteReg][31:1] = 0;
                    regFile[WriteReg][0] = cmp[0];
                    DB[31:1] = 0;
                    DB[0] = cmp[0];
                end
            endcase
        end
    end
   end
end

endmodule

