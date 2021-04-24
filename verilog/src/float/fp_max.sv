import fp_wire::*;

module fp_max
(
	input fp_max_in_type fp_max_i,
	output fp_max_out_type fp_max_o
);
	timeunit 1ns;
	timeprecision 1ps;

	logic [63:0] data1;
	logic [63:0] data2;
	logic [64:0] extend1;
	logic [64:0] extend2;
	logic [1:0] fmt;
	logic [2:0] rm;
	logic [9:0] class1;
	logic [9:0] class2;

	logic [63:0] nan;
	logic comp;

	logic [63:0] result;
	logic [4:0] flags;

	always_comb begin

		data1 = fp_max_i.data1;
		data2 = fp_max_i.data2;
		extend1 = fp_max_i.ext1;
		extend2 = fp_max_i.ext2;
		fmt = fp_max_i.fmt;
		rm = fp_max_i.rm;
		class1 = fp_max_i.class1;
		class2 = fp_max_i.class2;

		nan = 64'h7ff8000000000000;
		comp = 0;

		result = 0;
		flags = 0;

		if (fmt == 0) begin
			nan = 64'h000000007fc00000;
		end

		if (extend1[63:0] > extend2[63:0]) begin
			comp = 1;
		end

		if (rm == 0) begin
			if ((class1[8] | class2[8]) == 1) begin
				result = nan;
				flags[4] = 1;
			end else if ((class1[9] & class2[9]) == 1) begin
				result = nan;
			end else if (class1[9] == 1) begin
				result = data2;
			end else if (class2[9] == 1) begin
				result = data1;
			end else if ((extend1[4] ^ extend2[64]) == 1) begin
				if (extend1[64] == 1) begin
					result = data1;
				end else begin
					result = data2;
				end
			end else begin
				if (extend1[64] == 1) begin
					if (comp == 1) begin
						result = data1;
					end else begin
						result = data2;
					end
				end else begin
					if (comp == 0) begin
						result = data1;
					end else begin
						result = data2;
					end
				end
			end
		end else if (rm == 1) begin
			if ((class1[8] | class2[8]) == 1) begin
				result = nan;
				flags[4] = 1;
			end else if ((class1[9] & class2[9]) == 1) begin
				result = nan;
			end else if (class1[9] == 1) begin
				result = data2;
			end else if (class2[9] == 1) begin
				result = data1;
			end else if ((extend1[4] ^ extend2[64]) == 1) begin
				if (extend1[64] == 1) begin
					result = data1;
				end else begin
					result = data2;
				end
			end else begin
				if (extend1[64] == 1) begin
					if (comp == 1) begin
						result = data2;
					end else begin
						result = data1;
					end
				end else begin
					if (comp == 0) begin
						result = data2;
					end else begin
						result = data1;
					end
				end
			end
		end

		fp_max_o.result = result;
		fp_max_o.flags = flags;

	end

endmodule
