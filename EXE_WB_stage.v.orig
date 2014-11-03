`include "define.v"

module EXE_WB_stage (
	
	input  clk,  
	input [`DSIZE-1:0] alu_in,
	input [`ASIZE-1:0]waddr_in, 
	
	output reg [`DSIZE-1:0] alu_out,
	output reg[`ASIZE-1:0] waddr_out
	
);



//here we have not taken write enable (wen) as it is always 1 for R and I type instructions.
//ID_EXE register to save the values.
always @ (posedge clk) begin
	
		 begin
		waddr_out <= waddr_in;
		alu_out<=alu_in;
	end
 
end
endmodule

