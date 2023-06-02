`timescale 10ps / 1ps
//data memory ?????
module DataMEM(
	input[31:0] pc,
        input DataWr,        
        input [1:0] Digit,   
        input CLK,           
        input [31:0] DAddr,  
        input [31:0] DataIn, 
        output reg[31:0] DataOut 
    );

    reg [7:0] rom [4095:0];    
    
  
    always@(*)
    begin
	 case(Digit)
		2'b00:DataOut[7:0] = rom[DAddr ];
		2'b01:begin
			DataOut[7:0] = rom[DAddr ];
			DataOut[15:8] = rom[DAddr + 1];  
		end
		2'b10:begin
			DataOut[7:0] = rom[DAddr ];
        		DataOut[15:8] = rom[DAddr + 1];     
       			DataOut[23:16] = rom[DAddr + 2];     
      			DataOut[31:24] = rom[DAddr + 3 ];
		end
	endcase
    end

    always@(negedge CLK)
    begin   
        if(DataWr) 
            begin
		case(Digit)
			2'b00:rom[DAddr] = DataIn[7:0];
			2'b01:begin
			rom[DAddr + 1] = DataIn[15:8];     
                	rom[DAddr] = DataIn[7:0];
			end
			2'b10:begin	
                		rom[DAddr + 3] = DataIn[31:24];    
                		rom[DAddr + 2] = DataIn[23:16];
                		rom[DAddr + 1] = DataIn[15:8];     
                		rom[DAddr] = DataIn[7:0];
			
			end
		endcase
              $display("pc = %h: dataaddr = %h, memdata = %h",pc,DAddr,DataIn);
            end
    end

endmodule
