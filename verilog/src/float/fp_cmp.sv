import fp_wire::*;

module fp_cmp
(
	input fp_cmp_in_type fp_cmp_i,
	output fp_cmp_out_type fp_cmp_o
);
	timeunit 1ns;
	timeprecision 1ps;

	logic [64:0] data1;
	logic [64:0] data2;
	logic [2:0] rm;
	logic [9:0] class1;
	logic [9:0] class2;

	logic comp_lt;
	logic comp_le;
	logic [63:0] result;
	logic [4:0] flags;

	always_comb begin

		data1 = fp_cmp_i.data1;
		data2 = fp_cmp_i.data2;
		rm = fp_cmp_i.rm;
		class1 = fp_cmp_i.class1;
		class2 = fp_cmp_i.class2;

		comp_lt = 0;
		comp_le = 0;
		result = 0;
		flags = 0;

		if ((rm == 0) || (rm == 1) || (rm == 2)) begin
			comp_lt = (data1[63:0] < data2[63:0]) ? 1'b1 : 1'b0;
			comp_le = (data1[63:0] <= data2[63:0]) ? 1'b1 : 1'b0;
		end

		if (rm == 2) begin //feq
			if ((class1[8] | class2[8]) == 1) begin
				flags[4] = 1;
			end else if ((class1[9] | class2[9]) == 1) begin
				flags[0] = 0;
			end else if (((class1[3] | class1[4]) & (class2[3] | class2[4])) == 1) begin
				result[0] = 1;
			end else if (data1 == data2) begin
				result[0] = 1;
			end
		end else if (rm == 1) begin //flt
			if ((class1[8] | class2[8] | class1[9] | class2[9]) == 1) begin
				flags[4] = 1;
			end else if (((class1[3] | class1[4]) & (class2[3] | class2[4])) == 1) begin
				result[0] = 0;
			end else if ((data1[64] ^ data2[64]) == 1) begin
				result[0] = data1[64];
			end else begin
				if (data1[64] == 1) begin
					result[0] = ~comp_le;
				end else begin
					result[0] = comp_lt;
				end
			end
		end else if (rm == 0) begin //fle
			if ((class1[8] | class2[8] | class1[9] | class2[9]) == 1) begin
				flags[4] = 1;
			end else if (((class1[3] | class1[4]) & (class2[3] | class2[4])) == 1) begin
				result[0] = 1;
			end else if ((data1[64] ^ data2[64]) == 1) begin
				result[0] = data1[64];
			end else begin
				if (data1[64] == 0) begin
					result[0] = comp_le;
				end else begin
					result[0] = ~comp_lt;
				end
			end
		end

		fp_cmp_o.result = result;
		fp_cmp_o.flags = flags;

	end

endmodule
