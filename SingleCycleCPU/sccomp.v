
module xgriscv_sc(clk, rstn ,pcW);
   input          clk;
   input          rstn;
   output [31:0]     pcW;


   wire [31:0]instr;
   wire [6:0] op;
   wire [2:0] funct3;  
   wire [6:0] funct7;
   wire [4:0] rs1;     
   wire [4:0] rs2;     
   wire [4:0] rd;    
   wire [24:0]imm;    
   wire rst = rstn;

  // instantiation of single-cycle CPU  
 
   SingleCycleCPU U_SCPU(
         .CLK(clk),                 // input:  cpu clock
         .Reset(rst),                 // input:  reset
         .op(op),             // input:  instruction
         .funct7(funct7),        // input:  data to cpu  
         .funct3(funct3),       // output: memory write signal
         .rs1(rs1),                   // output: PC
         .rs2(rs2),          // output: address from cpu to memory
         .rd(rd),        // output: data from cpu to memory
         .imm(imm),         // input:  register selection
         .instr(instr),        // output: register data
	 .curPC(pcW)
         );

         
  // instantiation of intruction memory (used for simulation)
   InsMEM    U_imem ( 
      .curPC(pcW


),     // input:  rom address
      .op(op),             // input:  instruction
      .funct7(funct7),        // input:  data to cpu  
      .funct3(funct3),       // output: memory write signal
      .rs1(rs1),                   // output: PC
      .rs2(rs2),          // output: address from cpu to memory
      .rd(rd),        // output: data from cpu to memory
      .imm(imm),         // input:  register selection
      .instr(instr)        // output: register data
   );


        
endmodule

