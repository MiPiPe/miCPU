//control unit for write enable and ALU control

`include "define.v"
module control(
           input [3:0] inst,
           output reg wen,
           output reg [2:0] aluop,
           output reg branch,
           output reg mem_to_reg,
           output reg mem_write,
           output reg mem_read,
           output reg ALUSrc,
           output reg RegDst

       );

always@(*)
begin

    case(inst)
        `ADD: begin
            wen=1;
            aluop=inst[2:0];
        end
        `SUB: begin
            wen=1;
            aluop=inst[2:0];
        end
        `AND: begin
            wen=1;
            aluop=inst[2:0];
        end
        `XOR: begin
            wen=1;
            aluop=inst[2:0];
        end
        `SLL: begin
            wen=1;
            aluop=inst[2:0];
        end
        `SRL: begin
            wen=1;
            aluop=inst[2:0];
        end
        `COM: begin
            wen=1;
            aluop=inst[2:0];
        end
        `MUL: begin
            wen=1;
            aluop=inst[2:0];
        end
        `LW:  begin
            wen=1;
            aluop=`ADD;
        end
        `SW:  begin
            wen=0;
            aluop=`ADD;
        end
        `BEQ: begin
            wen=0;
            aluop=`SUB;
        end

    endcase

    branch = (inst == `BEQ)? 1'b1 : 1'b0;
    mem_to_reg = (inst == `LW)? 1'b1 : 1'b0;
    mem_write = (inst == `SW)? 1'b1 : 1'b0;
    mem_read = (inst == `LW)? 1'b1 : 1'b0;
    ALUSrc = (inst == `SLL || inst == `SRL || inst == `LW || inst == `SW)? 1'b1 : 1'b0;
    RegDst = (inst == `SW || inst == `BEQ)? 1'b1 : 1'b0;

end

endmodule
