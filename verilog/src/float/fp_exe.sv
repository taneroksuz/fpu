import fp_wire::*;

module fp_exe
(
	input fp_exe_in_type fp_exe_i,
	output fp_exe_out_type fp_exe_o,
	input fp_ext_out_type fp_ext1_o,
	output fp_ext_in_type fp_ext1_i,
	input fp_ext_out_type fp_ext2_o,
	output fp_ext_in_type fp_ext2_i,
	input fp_ext_out_type fp_ext3_o,
	output fp_ext_in_type fp_ext3_i,
	input fp_cmp_out_type fp_cmp_o,
	output fp_cmp_in_type fp_cmp_i,
	input fp_max_out_type fp_max_o,
	output fp_max_in_type fp_max_i,
	input fp_sgnj_out_type fp_sgnj_o,
	output fp_sgnj_in_type fp_sgnj_i,
	input fp_cvt_f2f_out_type fp_cvt_f2f_o,
	output fp_cvt_f2f_in_type fp_cvt_f2f_i,
	input fp_cvt_f2i_out_type fp_cvt_f2i_o,
	output fp_cvt_f2i_in_type fp_cvt_f2i_i,
	input fp_cvt_i2f_out_type fp_cvt_i2f_o,
	output fp_cvt_i2f_in_type fp_cvt_i2f_i,
	input fp_fma_out_type fp_fma_o,
	output fp_fma_in_type fp_fma_i,
	input fp_fdiv_out_type fp_fdiv_o,
	output fp_fdiv_in_type fp_fdiv_i,
	input fp_rnd_out_type fp_rnd_o,
	output fp_rnd_in_type fp_rnd_i
);
	timeunit 1ns;
	timeprecision 1ps;

	logic [63:0] data1;
	logic [63:0] data2;
	logic [63:0] data3;
	fp_operation_type op;
	logic [1:0] fmt;
	logic [2:0] rm;

	logic [63:0] result;
	logic [4:0] flags;
	logic ready;

	logic [1:0] fmt_ext;

	logic [64:0] extend1;
	logic [64:0] extend2;
	logic [64:0] extend3;

	logic [9:0] class1;
	logic [9:0] class2;
	logic [9:0] class3;

	fp_rnd_in_type fp_rnd;

	always_comb begin

		data1 = fp_exe_i.data1;
		data2 = fp_exe_i.data2;
		data3 = fp_exe_i.data3;
		op = fp_exe_i.op;
		fmt = fp_exe_i.fmt;
		rm = fp_exe_i.rm;
		op = fp_exe_i.op;

		result = 0;
		flags = 0;
		ready = fp_exe_i.enable;

		if (op.fcvt_f2f) begin
			fmt_ext = fp_exe_i.op.fcvt_op;
		end else begin
			fmt_ext = fp_exe_i.fmt;
		end

		fp_ext1_i.data = data1;
		fp_ext1_i.fmt = fmt_ext;
		fp_ext2_i.data = data2;
		fp_ext2_i.fmt = fmt_ext;
		fp_ext3_i.data = data3;
		fp_ext3_i.fmt = fmt_ext;

		extend1 = fp_ext1_o.result;
		extend2 = fp_ext2_o.result;
		extend3 = fp_ext3_o.result;

		class2 = fp_ext2_o.classification;
		class1 = fp_ext1_o.classification;
		class3 = fp_ext3_o.classification;

		fp_cmp_i.data1 = extend1;
		fp_cmp_i.data2 = extend2;
		fp_cmp_i.rm = rm;
		fp_cmp_i.class1 = class1;
		fp_cmp_i.class2 = class2;

		fp_max_i.data1 = data1;
		fp_max_i.data2 = data2;
		fp_max_i.ext1 = extend1;
		fp_max_i.ext2 = extend2;
		fp_max_i.fmt = fmt;
		fp_max_i.rm = rm;
		fp_max_i.class1 = class1;
		fp_max_i.class2 = class2;

		fp_sgnj_i.data1 = data1;
		fp_sgnj_i.data2 = data2;
		fp_sgnj_i.fmt = fmt;
		fp_sgnj_i.rm = rm;

		fp_fma_i.data1 = extend1;
		fp_fma_i.data2 = extend2;
		fp_fma_i.data3 = extend3;
		fp_fma_i.fmt = fmt;
		fp_fma_i.rm = rm;
		fp_fma_i.op = op;
		fp_fma_i.class1 = class1;
		fp_fma_i.class2 = class2;
		fp_fma_i.class3 = class3;

		fp_fdiv_i.data1 = extend1;
		fp_fdiv_i.data2 = extend2;
		fp_fdiv_i.fmt = fmt;
		fp_fdiv_i.rm = rm;
		fp_fdiv_i.op = op;
		fp_fdiv_i.class1 = class1;
		fp_fdiv_i.class2 = class2;

		fp_cvt_i2f_i.data = data1;
		fp_cvt_i2f_i.op = op;
		fp_cvt_i2f_i.fmt = fmt;
		fp_cvt_i2f_i.rm = rm;

		fp_cvt_f2f_i.data = extend1;
		fp_cvt_f2f_i.fmt = fmt;
		fp_cvt_f2f_i.rm = rm;
		fp_cvt_f2f_i.classification = class1;

		fp_cvt_f2i_i.data = extend1;
		fp_cvt_f2i_i.op = op;
		fp_cvt_f2i_i.rm = rm;
		fp_cvt_f2i_i.classification = class1;

		fp_rnd = init_fp_rnd_in;

		if (fp_fma_o.ready) begin
			fp_rnd = fp_fma_o.fp_rnd;
		end else if (fp_fdiv_o.ready) begin
			fp_rnd = fp_fdiv_o.fp_rnd;
		end else if (op.fcvt_f2f) begin
			fp_rnd = fp_cvt_f2f_o.fp_rnd;
		end else if (op.fcvt_i2f) begin
			fp_rnd = fp_cvt_i2f_o.fp_rnd;
		end

		fp_rnd_i = fp_rnd;

		if (fp_fma_o.ready) begin
			result = fp_rnd_o.result;
			flags = fp_rnd_o.flags;
			ready = 1;
		end else if (fp_fdiv_o.ready) begin
			result = fp_rnd_o.result;
			flags = fp_rnd_o.flags;
			ready = 1;
		end else if (op.fmadd | op.fmsub | op.fnmadd | op.fnmsub | op.fadd | op.fadd | op.fsub | op.fmul) begin
			ready = 0;
		end else if (op.fdiv | op.fsqrt) begin
			ready = 0;
		end else if (op.fcmp) begin
			result = fp_cmp_o.result;
			flags = fp_cmp_o.flags;
		end else if (op.fsgnj) begin
			result = fp_sgnj_o.result;
			flags = 0;
		end else if (op.fmax) begin
			result = fp_max_o.result;
			flags = fp_max_o.flags;
		end else if (op.fcmp) begin
			result = fp_cmp_o.result;
			flags = fp_cmp_o.flags;
		end else if (op.fclass) begin
			result = {54'h0,class1};
			flags = 0;
		end else if (op.fmv_f2i) begin
			result = data1;
			flags = 0;
		end else if (op.fmv_i2f) begin
			result = data1;
			flags = 0;
		end else if (op.fcvt_f2f) begin
			result = fp_rnd_o.result;
			flags = fp_rnd_o.flags;
		end else if (op.fcvt_i2f) begin
			result = fp_rnd_o.result;
			flags = fp_rnd_o.flags;
		end else if (op.fcvt_f2i) begin
			result = fp_cvt_f2i_o.result;
			flags = fp_cvt_f2i_o.flags;
		end

		fp_exe_o.result = result;
		fp_exe_o.flags = flags;
		fp_exe_o.ready = ready;

	end

endmodule
