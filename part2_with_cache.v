`timescale 1ns / 1ps
`include "define.v"

module part2_with_cache(clk, rst);

input clk;
input	rst;

wire clk_gate;

wire [`DSIZE-1:0] rdata1;
wire [`DSIZE-1:0] rdata2;
wire [`ASIZE-1:0] raddr2;
wire [`DSIZE-1:0] rdata2_imm_sel;
wire [`DSIZE-1:0] result;
wire [`DSIZE-1:0] INST;
wire [2:0] opcode;
wire [`DSIZE-1:0] imm_extended;
wire [`DSIZE-1:0] result_memread_sel;

//Cache
wire write_back;
wire [11:0] wb_addr;
wire [255:0] wb_data;
wire [255:0] fetch_data;
wire [11:0] fetch_addr;
wire clk_lock;

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
wire jump, jr, jal;
//Program counter
wire [`ISIZE-1:0] PCOUT;
wire [`ISIZE-1:0] nPC;
wire [`ISIZE-1:0] PCIN;
wire [`ISIZE-1:0] branch_adder_out;
wire [`ISIZE-1:0] jump_sel;
wire [`ISIZE-1:0] PCSrc_sel;
wire [`ISIZE-1:0] jump_addr;
//JAL register
wire [`ASIZE-1:0] waddr_jal_sel;
wire [`DSIZE-1:0] wdata_jal_sel;
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
wire jal_P1;
wire [`ISIZE-1:0] PC_jal_P1;

//Pipeline 2
wire wen_P2;
wire [`DSIZE-1:0] rdata2_P2;
wire mem_write_P2;
wire mem_read_P2;
wire mem_to_reg_P2;
wire [`DSIZE-1:0] result_P2;
wire [`ASIZE-1:0] waddr_P2;
wire jal_P2;
wire [`ISIZE-1:0] PC_jal_P2;

//Pipeline 3
wire wen_P3;
wire mem_to_reg_P3;
wire [`DSIZE-1:0] result_P3;
wire [`DSIZE-1:0] rdata_mem_P3;
wire [`ASIZE-1:0] waddr_P3;
wire jal_P3;
wire [`ISIZE-1:0] PC_jal_P3;

PC1 pc(.clk(clk_gate),.rst(rst),.nextPC(PCIN),.currPC(PCOUT));

memory im( .clk(clk_gate), .rst(rst), .wen(1'b0), .addr(PCOUT), .data_in(16'b0), .data_out(INST));

// assign clk_gate = (clk & clk_lock)? 1'b1 : 1'b0;
assign PCSrc = (branch_P1 & zero)? 1'b1 : 1'b0;
adder PCAdder(.a(PCOUT), .b(16'b1), .out(nPC));
adder BranchAdder(.a(nPC_P1), .b(imm_extended_P1), .out(branch_adder_out));
assign raddr2 = (RegDst)? INST[11:8] : INST[3:0];
assign rdata2_imm_sel = (ALUSrc)? imm_extended : rdata2;
assign result_memread_sel = (mem_to_reg_P3)? rdata_mem_P3 : result_P3;
assign PCSrc_sel = (PCSrc)? branch_adder_out : nPC;
assign jump_addr = {nPC[15:12], INST[11:0]};
assign jump_sel = (jump)? jump_addr : PCSrc_sel;
assign PCIN = (jr)? rdata1 : jump_sel;
assign waddr_jal_sel = (jal_P3)? 4'hf : waddr_P3;
assign wdata_jal_sel = (jal_P3)? PC_jal_P3 : result_memread_sel;

ID_EXE_stage PIPE1(
                 .clk(clk_gate),
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
                 .opcode_out(opcode_P1),
                 .jal_in(jal),
                 .jal_out(jal_P1),
                 .PC_jal_in(nPC),
                 .PC_jal_out(PC_jal_P1)
             );

EXE_MEM_stage PIPE2(
                  .clk(clk_gate),
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
                  .waddr_out(waddr_P2),
                  .jal_in(jal_P1),
                  .jal_out(jal_P2),
                  .PC_jal_in(PC_jal_P1),
                  .PC_jal_out(PC_jal_P2)
              );

MEM_WB_stage PIPE3(
                 .clk(clk_gate),
                 .wen_in(wen_P2),
                 .wen_out(wen_P3),
                 .mem_to_reg_in(mem_to_reg_P2),
                 .mem_to_reg_out(mem_to_reg_P3),
                 .result_in(result_P2),
                 .result_out(result_P3),
                 .rdata_mem_in(rdata_mem),
                 .rdata_mem_out(rdata_mem_P3),
                 .waddr_in(waddr_P2),
                 .waddr_out(waddr_P3),
                 .jal_in(jal_P2),
                 .jal_out(jal_P3),
                 .PC_jal_in(PC_jal_P2),
                 .PC_jal_out(PC_jal_P3)
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
            .RegDst(RegDst),
            .jr(jr),
            .jump(jump),
            .jal(jal)
        );

regfile  RF0 (
             .clk(clk_gate),
             .rst(rst),
             .wen(wen_P3),
             .raddr1(INST[7:4]),
             .raddr2(raddr2),
             .waddr(waddr_jal_sel),
             .wdata(wdata_jal_sel),
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
                .wen(write_back),
                .waddr(wb_addr),
                .raddr(fetch_addr),
                .write_data(wb_data),
                .read_data(fetch_data)
            );
cache CA (
          .clk(clk),
          .rst(rst),
          .mem_read(mem_read_P2),
          .mem_write(mem_write_P2),
          .addr(result_P2),
          .cache_data_in(rdata2_P2),
          .fetch_addr(fetch_addr),
          .fetch_data(fetch_data),
          .cache_data_out(rdata_mem),
          //.clk_lock(clk_lock),
          .write_back(write_back),
          .wb_addr(wb_addr),
          .wb_data(wb_data),
          .clk_out(clk_gate)
      );

endmodule
