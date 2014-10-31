`timescale 1ns / 1ps
`include "define.v"

module part1(clk, rst);

input clk;
input	rst;

wire [`DSIZE-1:0] rdata1;
wire [`DSIZE-1:0] rdata2;
wire [`ASIZE-1:0] raddr2;
wire [`DSIZE-1:0] rdata2_imm_sel;
wire [`DSIZE-1:0] result;
wire [`DSIZE-1:0] INST;
wire [2:0] opcode;
wire [`DSIZE-1:0] imm_extended;
wire [`ISIZE-1:0] branch_adder_out;
//Data memory
wire [`DSIZE-1:0] rdata_mem;
//Control unit
wire wen;
wire branch;
wire zero;
wire PCSrc;
wire RegDst;
wire ALUSrc;
wire mem_write;
wire mem_to_reg;
wire [`DSIZE-1:0] wdata;
//Program counter
wire [`ISIZE-1:0] PCOUT; 
wire [`ISIZE-1:0] nPC;
reg [`ISIZE-1:0] PCIN;

//Pipeline 1
wire wen_P1;
wire [`ISIZE-1:0] nPC_P1;
wire [`DSIZE-1:0] imm_extended_P1;
wire branch_P1;
wire mem_to_reg_P1;
wire mem_write_P1;
wire mem_read_P1;
wire [`DSIZE-1:0] alu_in1;
wire [`DSIZE-1:0] alu_in2;
wire [`DSIZE-1:0] rdata2_P1;
wire [2:0] opcode_P1;
wire [`ASIZE-1:0] waddr_P1;

//Pipeline 2
wire wen_P2;
wire [`DSIZE-1:0] rdata2_P2;
wire mem_write_P2;
wire mem_read_P2;
wire mem_to_reg_P2;
wire [`DSIZE-1:0] result_P2;
wire [`ASIZE-1:0] waddr_P2;

//Pipeline 3
wire wen_P3;
wire mem_to_reg_P3;
wire [`DSIZE-1:0] result_P3;
wire [`DSIZE-1:0] rdata_mem_P3;
wire [`ASIZE-1:0] waddr_P3;



PC1 pc(.clk(clk),.rst(rst),.nextPC(PCIN),.currPC(PCOUT));

memory im( .clk(clk), .rst(rst), .wen(1'b0), .addr(PCOUT), .data_in(16'b0), .data_out(INST));

assign PCSrc = (branch_P1 & zero)? 1'b1: 1'b0;
adder PCAdder(.a(PCOUT), .b(16'b1), .out(nPC));
adder BranchAdder(.a(nPC_P1), .b(imm_extended_P1), .out(branch_adder_out));
assign raddr2 = (RegDst)? INST[11:8] : INST[3:0];
assign rdata2_imm_sel = (ALUSrc)? imm_extended : rdata2;
assign wdata = (mem_to_reg_P3)? rdata_mem_P3 : result_P3; 
//assign PCIN = (PCSrc)? branch_adder_out : nPC_P1; 

always @((clk))
begin
	//nPC <= PCOUT + 1;
	/*if (PCIN == 0)
		nPC_P1 = 1;*/
	
	if (PCSrc == 1)
		PCIN <= branch_adder_out;
	else
		PCIN <= nPC;
//PCIN <= (PCSrc)? branch_adder_out : nPC_P1; 
end

ID_EXE_stage PIPE1(
	.clk(clk), 
	//.rst(rst),
	.wen_in(wen), 
	.wen_out(wen_P1), 
	.nPC_in(nPC), 
	.nPC_out(nPC_P1), 
	.imm_extended_in(imm_extended), 
	.imm_extended_out(imm_extended_P1), 
	.branch_in(branch), 
	.branch_out(branch_P1), 
	.mem_to_reg_in(mem_to_reg), 
	.mem_to_reg_out(mem_to_reg_P1), 
	.mem_write_in(mem_write), 
	.mem_write_out(mem_write_P1), 
	.mem_read_in(mem_read), 
	.mem_read_out(mem_read_P1), 
	.waddr_in(INST[11:8]), 
	.waddr_out(waddr_P1), 
	.rdata1(rdata1), 
	.alu_in1(alu_in1), 
	.rdata2_imm_sel(rdata2_imm_sel), 
	.alu_in2(alu_in2), 
	.rdata2_in(rdata2),
	.rdata2_out(rdata2_P1), 
	.opcode_in(opcode), 
	.opcode_out(opcode_P1)
);

EXE_MEM_stage PIPE2(
	.clk(clk), 
	.wen_in(wen_P1), 
	.wen_out(wen_P2),   
	.rdata2_in(rdata2_P1),
	.rdata2_out(rdata2_P2),
	.mem_write_in(mem_write_P1),
	.mem_write_out(mem_write_P2),
	.mem_read_in(mem_read_P1),
	.mem_read_out(mem_read_P2),
	.mem_to_reg_in(mem_to_reg_P1),
	.mem_to_reg_out(mem_to_reg_P2),
	.result_in(result),
	.result_out(result_P2),
	.waddr_in(waddr_P1),
	.waddr_out(waddr_P2)
);

MEM_WB_stage PIPE3(
	.clk(clk),
	.wen_in(wen_P2),
	.wen_out(wen_P3),
	.mem_to_reg_in(mem_to_reg_P2),
	.mem_to_reg_out(mem_to_reg_P3),
	.result_in(result_P2),
	.result_out(result_P3),
	.rdata_mem_in(rdata_mem),
	.rdata_mem_out(rdata_mem_P3),
	.waddr_in(waddr_P2),
	.waddr_out(waddr_P3)
);

sign_extend SE (
	.imm(INST[3:0]), 
	.imm_sign_extend(imm_extended)
);

control C0 (
	.inst(INST[15:12]), 
	.wen(wen), 
	.aluop(opcode), 
	.branch(branch), 
	.mem_to_reg(mem_to_reg), 
	.mem_write(mem_write), 
	.mem_read(mem_read), 
	.ALUSrc(ALUSrc), 
	.RegDst(RegDst)
);

regfile  RF0 (
	.clk(clk), 
	.rst(rst), 
	.wen(wen_P3), 
	.raddr1(INST[7:4]), 
	.raddr2(raddr2), 
	.waddr(waddr_P3), 
	.wdata(wdata), 
	.rdata1(rdata1), 
	.rdata2(rdata2)
);

alu ALU0 (
	.a(alu_in1), 
	.b(alu_in2), 
	.op(opcode_P1), 
	.result(result), 
	.zero(zero)
);

data_memory DM (
	.clk(clk), 
	.rst(rst), 
	.wen(mem_write_P2), 
	.ren(mem_read_P2), 
	.addr(result), 
	.write_data(rdata2_P2), 
	.read_data(rdata_mem)
);

endmodule