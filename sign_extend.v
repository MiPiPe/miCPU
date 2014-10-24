`include "define.v"

module sign_extend(
	input [3:0] imm,
	output [`DSIZE-1:0] imm_sign_extend
);

assign imm_sign_extend = {{12{imm[3]}}, imm[3:0]};

endmodule
