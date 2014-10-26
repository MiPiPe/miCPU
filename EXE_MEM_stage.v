`timescale 1ns / 1ps
`include "define.v"

module EXE_MEM_stage(

	input  clk,  

	
	input wen_in,
	input [`DSIZE-1:0] rdata2_in,
	input mem_write_in,
	input mem_read_in,
	input mem_to_reg_in,
	input [`DSIZE-1:0] result_in,
	input [`ASIZE-1:0] waddr_in, 
	
	output reg wen_out,
	output reg [`DSIZE-1:0] rdata2_out,
	output reg mem_write_out,
	output reg mem_read_out,
	output reg mem_to_reg_out,
	output reg [`DSIZE-1:0] result_out,
	output reg [`ASIZE-1:0] waddr_out

    );

always @ (posedge clk) begin
	wen_out <= wen_in;
	rdata2_out <= rdata2_in;
	mem_write_out <= mem_write_in;
	mem_read_out <= mem_read_in;
	mem_to_reg_out <= mem_to_reg_in;

	waddr_out <= waddr_in;
	result_out <= result_in;
end

endmodule
