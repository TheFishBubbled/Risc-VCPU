module ControlUnit(
        input [1:0] cmp, 
        input [6:0] op,         
        input [2:0] funct3,   
        input [6:0] funct7,    
        output reg PCSrc,    
        output reg[2:0] AluOp,  
        output reg Alu1Src,  
        output reg Alu2Src, 
        output reg[1:0] RegDst,
        output reg RegWr,   
        output reg[2:0] ExtSel, 
        output reg Sign,    
        output reg[1:0] Digit, 
        output reg DataWr,   
        output reg immres   
);


always@(cmp,op,funct3,funct7)
	begin
		case(op)
			7'b0110011:
			begin

			PCSrc   =1'b0;
			Alu1Src =1'b0;
			RegWr   =1'b1;
			Digit   =2'b10;
			DataWr  =1'b0;
			ExtSel=3'b000;// no relationship
			Sign  =1'b0;//no relationship

			case(funct3)
				3'b010:begin
					Alu2Src=1'b1;
					RegDst=2'b11;
				end
				3'b011:begin
					Alu2Src=1'b1;
					RegDst=2'b11;
				end
				default:begin
					Alu2Src=1'b0;
					RegDst=2'b00;
				end
			endcase

			case(funct3)
				3'b000:begin
					case(funct7)
						7'b0000000:begin
						AluOp=3'b000;
						end
						7'b0100000:begin
						AluOp=3'b001;
						end
					endcase
				end
				3'b001:begin
				AluOp=3'b101;
				end
				3'b100:begin
				AluOp=3'b010;
				end
				3'b101:begin
					case(funct7)
						7'b0000000:begin
						AluOp=3'b110;
						end
						7'b0100000:begin
						AluOp=3'b111;
						end
					endcase
				end
				3'b110:begin
				AluOp=3'b011;
				end
				3'b111:begin
				AluOp=3'b100;
				end
				default:begin
				AluOp=3'b000;
				end
			endcase
				immres= 1'b0; 

			end

			7'b0010011:
			begin

			//I with no load
				PCSrc=1'b0;
				Alu1Src=1'b0;
				RegWr=1'b1;
				Digit=2'b10;
				DataWr=1'b0;
				case(funct3)
					3'b000:begin
					AluOp=3'b000;
					end
					3'b001:begin
					AluOp=3'b101;
					end
					3'b100:begin
					AluOp=3'b010;
					end
					3'b101:begin
						case(funct7)
							7'b0000000:begin
							AluOp=3'b110;
							end
							7'b0100000:begin
							AluOp=3'b111;
							end
						endcase
					end
					3'b110:begin
					AluOp=3'b011;
					end
					3'b111:begin
					AluOp=3'b100;
					end
					default:begin
					AluOp=3'b000;
					end
				endcase

				case(funct3)
					3'b010:begin
					Alu2Src=1'b0;
					end
					3'b011:begin
					Alu2Src=1'b0;
					end
					default:begin
					Alu2Src=1'b1;
					end
				endcase

				case(funct3)
					3'b010:begin
					RegDst=2'b11;
					end
					3'b011:begin
					RegDst=2'b11;
					end
					default:begin
					RegDst=2'b00;
					end
				endcase

				case(funct3)
					3'b001:begin
					ExtSel=3'b101;
					end
					3'b101:begin
					ExtSel=3'b101;
					end
					default:begin
					ExtSel=3'b000;
					end
				endcase

				case(funct3)
					3'b011:begin
					Sign=1'b0;
					end
					default:begin
					Sign=1'b1;
					end
				endcase
				immres= 1'b0; 

			end
			7'b0000011:
			begin
			//I with load
				PCSrc=1'b0;
				AluOp=3'b000;
				Alu1Src=1'b0;
				Alu2Src=1'b1;
				RegDst=2'b01;
				RegWr=1'b1;
				ExtSel=3'b000;
				DataWr=1'b0;

				case(funct3)
					3'b100:Sign=1'b0;
					3'b101:Sign=1'b0;
				default:Sign=1'b1;
				endcase
				case(funct3)
					3'b001:Digit=2'b01;
					3'b010:Digit=2'b10;
					3'b101:Digit=2'b01;
				default:Digit=2'b00;
				endcase
				immres= 1'b0; 

			end

			7'b0100011:
			//S	
			begin
				PCSrc=1'b0;
				AluOp=3'b000;
				Alu1Src=1'b0;
				Alu2Src=1'b1;
				RegDst=2'b00;
				RegWr=1'b0;
				ExtSel=3'b001;
				Sign=1'b1;
				DataWr=1'b1;
				case(funct3)
					3'b000:Digit=2'b00;
					3'b001:Digit=2'b01;
					3'b010:Digit=2'b10;
				endcase
				immres= 1'b0; 

			end

			7'b1100011:
			begin
			//SB
			/*
			Due to the peculiarities of SB-type instructions and the fact that 
			we do not select their determined output in the ALI, we are going to 
			select the corresponding output according to the cmp here
				*/
				case(funct3)
					3'b000:PCSrc= (cmp==2'b00) ? 1'b1:1'b0;
					3'b001:PCSrc= (cmp!=2'b00) ? 1'b1:1'b0;
					3'b100:PCSrc= (cmp==2'b01) ? 1'b1:1'b0;
					3'b101:PCSrc= (cmp!=2'b01) ? 1'b1:1'b0;
					3'b110:PCSrc= (cmp==2'b01) ? 1'b1:1'b0;
					3'b111:PCSrc= (cmp!=2'b01) ? 1'b1:1'b0;
				endcase

				AluOp=3'b000;
				Alu1Src=1'b1;
				Alu2Src=1'b1;
				RegDst=2'b00;
				RegWr=1'b0;
				ExtSel=3'b010;
				Digit=2'b10;
				DataWr=1'b0;
				case(funct3)
					3'b110:Sign=1'b0;
					3'b111:Sign=1'b0;
					default:Sign=1'b1;
				endcase
				immres= 1'b0; 
			end
		// The other is a little bit spefic,we shall do it dandu
			7'b1101111:
			begin
				PCSrc=1'b1;
				AluOp=3'b000;
				Alu1Src=1'b1;
				Alu2Src=1'b1;
				RegDst=2'b10;
				RegWr=1'b1;
				ExtSel=3'b100;
				Sign=1'b1;
				Digit=2'b10;
				DataWr=1'b0;
				immres= 1'b0; 
			end
			7'b1100111:
			begin
				PCSrc=1'b1;
				AluOp=3'b000;
				Alu1Src=1'b0;
				Alu2Src=1'b1;
				RegDst=2'b10;
				RegWr=1'b1;
				ExtSel=3'b000;
				Sign=1'b1;
				Digit=2'b10;
				DataWr=1'b0;
				immres= 1'b0; 
			end
			7'b0110111:
			begin
				PCSrc=1'b0;
				AluOp=3'b000;
				Alu1Src=1'b0;
				Alu2Src=1'b0;
				RegDst=2'b00;
				RegWr=1'b1;
				ExtSel=3'b011;
				Sign=1'b1;
				Digit=2'b10;
				DataWr=1'b0;
				immres= 1'b1;   
			end
			7'b0010111:
			begin
				PCSrc=1'b0;
				AluOp=3'b000;
				Alu1Src=1'b1;
				Alu2Src=1'b1;
				RegDst=2'b00;
				RegWr=1'b1;
				ExtSel=3'b011;
				Sign=1'b1;
				Digit=2'b10;
				DataWr=1'b0;
				immres= 1'b0; 
			end
		endcase
	end



endmodule

			

