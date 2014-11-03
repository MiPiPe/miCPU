`timescale 1ns / 1ps
`include "define.v"

module pipelined_regfile_3stage(clk, rst, fileid, PCOUT, INST, aluop, rdata1, rdata2, rdata1_ID_EXE,rdata2_ID_EXE, aluop_ID_EXE,waddr_out_ID_EXE,aluout,aluout_EXE_WB,waddr_out_EXE_WB,imm_in);

input clk;

input	rst;
input fileid;

output [`ISIZE-1:0]PCOUT;
output [`DSIZE-1:0] rdata1;
output [`DSIZE-1:0] rdata1_ID_EXE;//output from ID_EXE stage
output [`DSIZE-1:0] rdata2;
output [`DSIZE-1:0] rdata2_ID_EXE;//output from ID_EXE stage
output [`DSIZE-1:0] aluout;
output [`DSIZE-1:0] aluout_EXE_WB;//output from EXE_WB stage
output [`DSIZE-1:0]INST;
output [2:0] aluop;
output [2:0] aluop_ID_EXE;//output from ID_EXE stage
output [`ASIZE-1:0] waddr_out_ID_EXE;//output from ID_EXE stage
output [`ASIZE-1:0] waddr_out_EXE_WB;//output from EXE_WB stage
output [`DSIZE-1:0] imm_in;

//Program counter
reg [`ISIZE-1:0]PCIN=16'b0;

PC1 pc(.clk(clk),.rst(rst),.nextPC(PCIN),.currPC(PCOUT));

always @((clk))
begin
    PCIN <= PCOUT + 16'b1; //increments PC to PC +1
end

//instruction memory
memory im( .clk(clk), .rst(rst), .wen(1'b0), .addr(PCOUT), .data_in(16'b0), .fileid(4'b0),.data_out(INST));

//here we are not taking the multiplexers for initialization as initialization is done within reg file itself.
wire wen;
wire [`DSIZE-1:0] imm_ID_EXE;

SignExtend SE (.imm(INST[3:0]), .imm_signExt(imm_in));

control C0 (.inst(INST[15:12]),.wen(wen), .aluop(aluop));

regfile  RF0 ( .clk(clk), .rst(rst), .wen(wen), .raddr1(INST[7:4]), .raddr2(INST[3:0]), .waddr(waddr_out_EXE_WB), .wdata(aluout_EXE_WB), .rdata1(rdata1), .rdata2(rdata2));

ID_EXE_stage PIPE1(.clk(clk), .rdata1_in(rdata1),.rdata2_in(rdata2),.imm_in(imm_in),.opcode_in(aluop), .waddr_in(INST[11:8]), .waddr_out(waddr_out_ID_EXE), .rdata1_out(rdata1_ID_EXE), .rdata2_out(rdata2_ID_EXE), .imm_out(imm_ID_EXE), .opcode_out(aluop_ID_EXE));//immediate value is given as 0 as we are concentrating only on R-type instuctions

EXE_WB_stage PIPE2(.clk(clk), .waddr_in(waddr_out_ID_EXE), .waddr_out(waddr_out_EXE_WB), .alu_in(aluout), .alu_out(aluout_EXE_WB) );//immediate value is given as 0 as we are concentrating only on R-type instuctions

alu ALU0 ( .a(rdata1_ID_EXE), .b(rdata2_ID_EXE), .op(aluop_ID_EXE), .imm(imm_ID_EXE), .out(aluout));//alu takes its input from the pipeline register

endmodule


