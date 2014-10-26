`timescale 1ns / 1ps
`include "define.v"

module part1_without_pipeline(clk, rst);

input clk;
											
input	rst;

wire [`DSIZE-1:0] rdata1;
wire [`DSIZE-1:0] rdata2;
wire [`ASIZE-1:0] raddr2;
wire [`DSIZE-1:0] alu_in2;
wire [`DSIZE-1:0] aluout;
wire [`DSIZE-1:0] INST;
wire [2:0] aluop;
wire [`DSIZE-1:0] imm_extended;
wire [`ISIZE-1:0] branch_adder_out;
//Data memory
wire [`DSIZE-1:0] rdata_mem;
wire mem_write, mem_to_reg, mem_read;
//Program counter
wire branch, zero, PCSrc;
wire RegDst;
wire ALUSrc;

wire [`ISIZE-1:0] PCOUT, nPC;

reg [`ISIZE-1:0] PCIN=16'b0;

PC1 pc(.clk(clk),.rst(rst),.nextPC(PCIN),.currPC(PCOUT));

//instruction memory
memory im( .clk(clk), .rst(rst), .wen(1'b0), .addr(PCOUT), .data_in(16'b0), .data_out(INST));

wire wen;
// wire [`DSIZE-1:0] imm_ID_EXE;
wire [15:0] wdata;

assign PCSrc = (branch & zero)? 1'b1: 1'b0;
adder PCAdder(.a(PCOUT), .b(16'b1), .out(nPC));
adder BranchAdder(.a(nPC), .b(imm_extended), .out(branch_adder_out));
assign raddr2 = (RegDst)? INST[11:8] : INST[3:0];
assign alu_in2 = (ALUSrc)? imm_extended : rdata2;
assign wdata = (mem_to_reg)? rdata_mem : aluout; 

always @((clk))
begin
	PCIN <= (PCSrc)? branch_adder_out : nPC; 
end

// adder JumpAdder(.a(), .b(), out(JumpAdder_out));

sign_extend SE (.imm(INST[3:0]), .imm_sign_extend(imm_extended));

control C0 (.inst(INST[15:12]), .wen(wen), .aluop(aluop), .branch(branch), .mem_to_reg(mem_to_reg), .mem_write(mem_write), .mem_read(mem_read), .ALUSrc(ALUSrc), .RegDst(RegDst));

regfile  RF0 (.clk(clk), .rst(rst), .wen(wen), .raddr1(INST[7:4]), .raddr2(raddr2), .waddr(INST[11:8]), .wdata(wdata), .rdata1(rdata1), .rdata2(rdata2));

alu ALU0 (.a(rdata1), .b(alu_in2), .op(aluop), .result(aluout), .zero(zero));

data_memory DM (.clk(clk), .rst(rst), .wen(mem_write), .ren(mem_read), .addr(aluout), .write_data(rdata2), .read_data(rdata_mem));

endmodule


