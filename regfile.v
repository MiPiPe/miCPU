// Register File module
`include "define.v"

module regfile (
	clk,
	rst,
	wen,
	raddr1, 
	raddr2, 
	waddr, 
	wdata, 

	rdata1,
	rdata2
	);


    
	input clk;
	input rst;
	input wen;
	input [`ASIZE-1:0] raddr1; 
	input [`ASIZE-1:0] raddr2; 
	input [`ASIZE-1:0] waddr; 
	input [`DSIZE-1:0] wdata; 

	output [`DSIZE-1:0] rdata1;
	output [`DSIZE-1:0] rdata2;



	reg [`DSIZE-1:0] regdata [0:`NREG-1];
	
integer i;

	always@(posedge clk)
		begin
			if(rst)
				begin
					for (i=0; i<`NREG; i=i+1)
					regdata[i] <=0;
					regdata[1] <=5;//initialization regdata[1] is initialized with 5.
					
				end

			else
				regdata[waddr] <= ((wen == 1) && (waddr != 0)) ? wdata : regdata[waddr];
		end
	
	assign rdata1 = ((wen) && (waddr == raddr1) && (waddr != 0)) ? wdata : regdata[raddr1];
	assign rdata2 = ((wen) && (waddr == raddr2) && (waddr != 0)) ? wdata : regdata[raddr2];

endmodule 
