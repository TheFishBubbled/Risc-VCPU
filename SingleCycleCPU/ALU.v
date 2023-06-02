module ALU(
        input ALUSrc1,      
        input ALUSrc2,       
        input [31:0] ReadData1, 
        input [31:0] ReadData2, 
        input [31:0] extend,  
        input [31:0] PC,        
        input [2:0] AluOp,    
        output reg[1:0] cmp,   
        output reg[31:0] AluOutput,
	input  Sign
    );


reg [31:0] A ;
reg [31:0] B ;
reg [31:0] C ;

always@(ReadData1 or ReadData2 or ALUSrc1 or ALUSrc2 or AluOp or PC or extend)
   begin
	A = (ALUSrc1 == 1'b0) ? ReadData1 : PC;
        B = (ALUSrc2 == 1'b0) ? ReadData2 : extend;
        C = (ALUSrc2 == 1'b1) ? ReadData2 : extend;

   if(Sign) begin
        if ($signed(ReadData1) == $signed(C)) begin
            cmp <= 2'b00;
        end
        else begin
            if ($signed(ReadData1) < $signed(C)) begin
                cmp <= 2'b01;
            end
            else begin
                cmp <= 2'b10;
            end
        end
   end

   else begin
 	if (ReadData1 == C) begin
            cmp <= 2'b00;
        end
        else begin
            if (ReadData1 < C) begin
                cmp <= 2'b01;
            end
            else begin
                cmp <= 2'b10;
            end
        end
   end

   	case(AluOp)
            3'b000: AluOutput <= A + B;
            3'b001: AluOutput <= A - B;
            3'b010: AluOutput <= A ^ B;
            3'b011: AluOutput <= A | B;
            3'b100: AluOutput <= A & B;
            3'b101: AluOutput <= (A << B);
            3'b110: AluOutput <=  (A >> B); //????
            3'b111: AluOutput <= (( $signed(A) ) >>> B); //????
        endcase
    end 
endmodule

//ALU not correct
