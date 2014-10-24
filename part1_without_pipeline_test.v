`timescale 1ns / 1ps

module part1_without_pipeline_test;

	// Inputs
	reg clk;
	reg rst;
	reg fileid;

	// Outputs
	wire [15:0] rdata1;
	wire [15:0] rdata2;
	wire [3:0] raddr2;
	wire [15:0] alu_in2;
	wire [15:0] aluout;
	wire [15:0] INST;
	wire [2:0] aluop;
	wire [15:0] imm_in;
	wire [15:0] imm_extended;
	wire [15:0] branch_adder_out;
	wire [15:0] rdata_mem;
	wire [15:0] wdata_mem;
	wire mem_write;
	wire mem_to_reg;
	wire branch;
	wire zero;
	wire PCSrc;
	wire RegDst;
	wire ALUSrc;
	wire [15:0] PCOUT;
	wire [15:0] nPC;

	// Instantiate the Unit Under Test (UUT)
	part1_without_pipeline uut (
		.clk(clk), 
		.rst(rst), 
		.fileid(fileid), 
		.rdata1(rdata1), 
		.rdata2(rdata2), 
		.raddr2(raddr2), 
		.alu_in2(alu_in2), 
		.aluout(aluout), 
		.INST(INST), 
		.aluop(aluop), 
		.imm_in(imm_in), 
		.imm_extended(imm_extended), 
		.branch_adder_out(branch_adder_out), 
		.rdata_mem(rdata_mem), 
		.wdata_mem(wdata_mem), 
		.mem_write(mem_write), 
		.mem_to_reg(mem_to_reg), 
		.branch(branch), 
		.zero(zero), 
		.PCSrc(PCSrc), 
		.RegDst(RegDst), 
		.ALUSrc(ALUSrc), 
		.PCOUT(PCOUT), 
		.nPC(nPC)
	);

always #15 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		fileid = 0;

		// Wait 100 ns for global reset to finish
		#100;
#25 rst =1;
#25 rst=0;
		// Add stimulus here

	end
      
endmodule

