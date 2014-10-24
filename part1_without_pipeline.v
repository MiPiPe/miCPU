`timescale 1ns / 1ps
`include "define.v"

module part1_without_pipeline(clk, rst, fileid, rdata1, rdata2, raddr2, alu_in2, aluout, INST, aluop, imm_in, imm_extended, 
	branch_adder_out, rdata_mem, wdata_mem, mem_write, mem_to_reg, branch, zero, PCSrc, RegDst, ALUSrc, PCOUT, nPC);

input clk;
											
input	rst;
input fileid; 

output [`DSIZE-1:0] rdata1;
output [`DSIZE-1:0] rdata2;
output [`ASIZE-1:0] raddr2;
output [`DSIZE-1:0] alu_in2;
output [`DSIZE-1:0] aluout;
output [`DSIZE-1:0] INST;
output [2:0] aluop;
output [`DSIZE-1:0] imm_in, imm_extended;
output [`ISIZE-1:0] branch_adder_out;
//Data memory
output [`DSIZE-1:0] rdata_mem, wdata_mem;
output mem_write, mem_to_reg;
//Program counter
output branch, zero, PCSrc;
output RegDst;
output ALUSrc;

output [`ISIZE-1:0] PCOUT, nPC;

reg [`ISIZE-1:0] PCIN=16'b0;

PC1 pc(.clk(clk),.rst(rst),.nextPC(PCIN),.currPC(PCOUT));

//instruction memory
memory im( .clk(clk), .rst(rst), .wen(1'b0), .addr(PCOUT), .data_in(16'b0), .fileid(4'b0),.data_out(INST));

//here we are not taking the multiplexers for initialization as initialization is done within reg file itself.
wire wen;
// wire [`DSIZE-1:0] imm_ID_EXE;

assign PCSrc = (branch & zero)? 1'b1: 1'b0;
adder PCAdder(.a(PCOUT), .b(16'b1), .out(nPC));
adder BranchAdder(.a(nPC), .b(imm_extended), .out(branch_adder_out));
assign raddr2 = (RegDst)? INST[11:8] : INST[3:0];
assign alu_in2 = (ALUSrc)? imm_extended : rdata2;
assign wdata = (mem_to_reg)? aluout : rdata_mem; 

always @((clk))
begin
	PCIN <= (PCSrc)? branch_adder_out : nPC; 
end


// adder JumpAdder(.a(), .b(), out(JumpAdder_out));

sign_extend SE (.imm(INST[3:0]), .imm_sign_extend(imm_extended));

control C0 (.inst(INST[15:12]), .wen(wen), .aluop(aluop), .branch(branch), .mem_to_reg(mem_to_reg), .mem_write(mem_write), .ALUSrc(ALUSrc), .RegDst(RegDst));

regfile  RF0 ( .clk(clk), .rst(rst), .wen(wen), .raddr1(INST[7:4]), .raddr2(INST[3:0]), .waddr(INST[11:8]), .wdata(wdata), .rdata1(rdata1), .rdata2(rdata2));

alu ALU0 ( .a(rdata1), .b(alu_in2), .op(aluop), .result(aluout), .zero(zero));

data_memory DM (.clk(clk), .rst(rst), .wen(mem_write), .ren(mem_to_reg), .addr(aluout), .write_data(wdata_mem), .read_data(rdata_mem));

endmodule


