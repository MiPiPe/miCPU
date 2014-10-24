`include "define.v"

module ID_EXE_stage (
	
	input  clk,  
	input [`DSIZE-1:0] rdata1_in,
	input [`DSIZE-1:0] rdata2_in,
	input [`DSIZE-1:0] imm_in,
	input [2:0] opcode_in,
	input [`ASIZE-1:0]waddr_in, 

	output reg [`DSIZE-1:0] rdata1_out,
	output reg [`DSIZE-1:0] rdata2_out,
	output reg [`DSIZE-1:0] imm_out,
	output reg [2:0] opcode_out,
	output reg[`ASIZE-1:0]waddr_out
	
);



//here we have not taken write enable (wen) as it is always 1 for R and I type instructions.
//ID_EXE register to save the values.
always @ (posedge clk) begin
	
		 begin
		waddr_out <= waddr_in;
		rdata1_out <= rdata1_in;
		rdata2_out <= rdata2_in;
		imm_out<=imm_in;
		opcode_out<=opcode_in;
	end
 
end
endmodule


