`timescale 1ns / 1ps
`include "define.v"

module MEM_WB_stage(
	input  clk,  
	
	input wen_in,
	input mem_to_reg_in,
	input [`DSIZE-1:0] result_in,
	input [`DSIZE-1:0] rdata_mem_in,
	input [`ASIZE-1:0] waddr_in, 

	output reg wen_out,
	output reg mem_to_reg_out,
	output reg [`DSIZE-1:0] result_out,
	output reg [`DSIZE-1:0] rdata_mem_out,
	output reg [`ASIZE-1:0] waddr_out

    );

always @ (posedge clk) begin
	wen_out <= wen_in;
	mem_to_reg_out <= mem_to_reg_in;
	result_out <= result_in;
	rdata_mem_out <= rdata_mem_in;
	waddr_out <= waddr_in;	
end

endmodule
