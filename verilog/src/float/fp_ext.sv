import lzc_wire::*;
import fp_wire::*;

module fp_ext
(
	input fp_ext_in_type fp_ext_i,
	output fp_ext_out_type fp_ext_o,
	input lzc_64_out_type lzc_o,
	output lzc_64_in_type lzc_i
);
	timeunit 1ns;
	timeprecision 1ps;

	logic [63:0] data;
	logic [1:0] fmt;

	logic [63:0] mantissa;
	logic [64:0] result;
	logic [9:0] classification;
	logic [5:0] counter;
	logic mantissa_zero;
	logic exponent_zero;
	logic exponent_ones;

	always_comb begin

		data = fp_ext_i.data;
		fmt = fp_ext_i.fmt;

		mantissa = 64'hFFFFFFFFFFFFFFFF;
		counter = 0;

		result = 0;
		classification = 0;

		mantissa_zero = 0;
		exponent_zero = 0;
		exponent_ones = 0;

		if (fmt == 0) begin
			mantissa = {1'h0,data[22:0],40'hFFFFFFFFFF};
			exponent_zero = ~|data[30:23];
			exponent_ones = &data[30:23];
			mantissa_zero = ~|data[22:0];
		end else begin
			mantissa = {1'h0,data[51:0],11'h7FF};
			exponent_zero = ~|data[62:52];
			exponent_ones = &data[62:52];
			mantissa_zero = ~|data[51:0];
		end

		lzc_i.a = mantissa;
		counter = ~lzc_o.c;

		if (fmt == 0) begin
			result[64] = data[31];
			if (&data[30:23]) begin
				result[63:52] = 12'hFFF;
				result[51:29] = data[22:0];
			end else if (|data[30:23]) begin
				result[63:52] = {4'h0,data[30:23]} + 12'h780;
				result[51:29] = data[22:0];
			end else if (counter < 24) begin
				result[63:52] = 12'h781 - {6'h0,counter};
				result[51:29] = (data[22:0] << counter);
			end
			result[28:0] = 0;
		end else if (fmt == 1) begin
			result[64] = data[63];
			if (&data[62:52]) begin
				result[63:52] = 12'hFFF;
				result[51:0] = data[51:0];
			end else if (|data[62:52]) begin
				result[63:52] = {1'h0,data[62:52]} + 12'h400;
				result[51:0] = data[51:0];
			end else if (counter < 53) begin
				result[63:52] = 12'h401 - {6'h0,counter};
				result[51:0] = (data[51:0] << counter);
			end
		end

		if (result[64]) begin
			if (exponent_ones) begin
				if (mantissa_zero) begin
					classification[0] = 1;
				end else if (result[51] == 0) begin
					classification[8] = 1;
				end else begin
					classification[9] = 1;
				end
			end else if (exponent_zero) begin
				if (mantissa_zero == 1) begin
					classification[3] = 1;
				end else begin
					classification[2] = 1;
				end
			end else begin
				classification[1] = 1;
			end
		end else begin
			if (exponent_ones) begin
				if (mantissa_zero) begin
					classification[7] = 1;
				end else if (result[51] == 0) begin
					classification[8] = 1;
				end else begin
					classification[9] = 1;
				end
			end else if (exponent_zero) begin
				if (mantissa_zero == 1) begin
					classification[4] = 1;
				end else begin
					classification[5] = 1;
				end
			end else begin
				classification[6] = 1;
			end
		end

		fp_ext_o.result = result;
		fp_ext_o.classification = classification;

	end

endmodule
