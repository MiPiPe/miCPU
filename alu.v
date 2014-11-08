`include "define.v"// defines


module alu(
           a,   //1st operand
           b,   //2nd operand
           op,   //3-bit operation
           result,   //result
           zero
       );



input [`DSIZE-1:0] a, b;
input [2:0] op;
output reg zero;
output reg [`DSIZE-1:0] result;

always @(*)
begin
    case(op)
        `ADD: result = a + b;
        `SUB: result = a - b;
        `AND: result = a & b;
        `XOR:  result = a ^ b;
        `SLL: result = a << b;
        `SRL: result = a >> b;
        `COM: result = a <= b;
        `MUL: result = a * b;
    endcase

    zero = (a == b)? 1'b1 : 1'b0;

end



endmodule


