import fp_wire::*;

module fp_sgnj
(
	input fp_sgnj_in_type fp_sgnj_i,
	output fp_sgnj_out_type fp_sgnj_o
);
	timeunit 1ns;
	timeprecision 1ps;

	logic [63:0] data1;
	logic [63:0] data2;
	logic [1:0] fmt;
	logic [2:0] rm;
	logic [63:0] result;

	always_comb begin

		data1 = fp_sgnj_i.data1;
		data2 = fp_sgnj_i.data2;
		fmt = fp_sgnj_i.fmt;
		rm = fp_sgnj_i.rm;

		result = 0;

		if (fmt == 0) begin
			result[30:0] = data1[30:0];
			if (rm == 0) begin
				result[31] = data2[31];
			end else if (rm == 1) begin
				result[31] = ~data2[31];
			end else if (rm == 2) begin
				result[31] = data1[31] ^ data2[31];
			end
		end else if (fmt == 1) begin
			result[62:0] = data1[62:0];
			if (rm == 0) begin
				result[63] = data2[63];
			end else if (rm == 1) begin
				result[63] = ~data2[63];
			end else if (rm == 2) begin
				result[63] = data1[63] ^ data2[63];
			end
		end

		fp_sgnj_o.result = result;

	end

endmodule
