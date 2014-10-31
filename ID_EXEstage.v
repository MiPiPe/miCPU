`include "define.v"

module ID_EXE_stage (
	
	input clk,
	//input rst,
	input wen_in,
	input [`ISIZE-1:0] nPC_in,
	input [`DSIZE-1:0] imm_extended_in,
	input branch_in,
	input mem_to_reg_in,
	input mem_write_in,
	input mem_read_in,
	input [`DSIZE-1:0] rdata1,
	input [`DSIZE-1:0] rdata2_imm_sel,
	input [`DSIZE-1:0] rdata2_in,
	input [2:0] opcode_in,
	input [`ASIZE-1:0] waddr_in, 
	


	output reg wen_out,
	output reg [`ISIZE-1:0] nPC_out,
	output reg [`DSIZE-1:0] imm_extended_out,
	output reg branch_out,
	output reg mem_to_reg_out,
	output reg mem_write_out,
	output reg mem_read_out,
	output reg [`DSIZE-1:0] alu_in1,
	output reg [`DSIZE-1:0] alu_in2,
	output reg [`DSIZE-1:0] rdata2_out,
	output reg [2:0] opcode_out,
	output reg [`ASIZE-1:0] waddr_out
	
);



//here we have not taken write enable (wen) as it is always 1 for R and I type instructions.
//ID_EXE register to save the values.
always @ (posedge clk) begin
	/*if (rst)
		nPC_out <= 0;
	else begin*/
		nPC_out <= nPC_in;
		wen_out <= wen_in;
		imm_extended_out <= imm_extended_in;
		branch_out <= branch_in;
		mem_to_reg_out <= mem_to_reg_in;
		mem_write_out <= mem_write_in;
		mem_read_out <= mem_read_in;
		alu_in1 <= rdata1;
		alu_in2 <= rdata2_imm_sel;
		rdata2_out <= rdata2_in;
		opcode_out <= opcode_in;
		waddr_out <= waddr_in;
	//end
end
endmodule


