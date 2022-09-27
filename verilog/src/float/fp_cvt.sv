import lzc_wire::*;
import fp_wire::*;

module fp_cvt
(
	input fp_cvt_f2f_in_type fp_cvt_f2f_i,
	output fp_cvt_f2f_out_type fp_cvt_f2f_o,
	input fp_cvt_f2i_in_type fp_cvt_f2i_i,
	output fp_cvt_f2i_out_type fp_cvt_f2i_o,
	input fp_cvt_i2f_in_type fp_cvt_i2f_i,
	output fp_cvt_i2f_out_type fp_cvt_i2f_o,
	input lzc_64_out_type lzc_o,
	output lzc_64_in_type lzc_i
);
	timeunit 1ns;
	timeprecision 1ps;

	fp_cvt_f2f_var_type v_f2f;
	fp_cvt_f2i_var_type v_f2i;
	fp_cvt_i2f_var_type v_i2f;

	always_comb begin

		v_f2f.data = fp_cvt_f2f_i.data;
		v_f2f.fmt = fp_cvt_f2f_i.fmt;
		v_f2f.rm = fp_cvt_f2f_i.rm;
		v_f2f.classification = fp_cvt_f2f_i.classification;

		v_f2f.snan = v_f2f.classification[8];
		v_f2f.qnan = v_f2f.classification[9];
		v_f2f.dbz = 0;
		v_f2f.inf = v_f2f.classification[0] | v_f2f.classification[7];
		v_f2f.zero = v_f2f.classification[3] | v_f2f.classification[4];

		v_f2f.exponent_cvt = v_f2f.data[63:52];
		v_f2f.mantissa_cvt = {2'h1,v_f2f.data[51:0],26'h0};

		v_f2f.exponent_bias = 1920;
		if (v_f2f.fmt == 1) begin
			v_f2f.exponent_bias = 1024;
		end

		v_f2f.sign_rnd = v_f2f.data[64];
		v_f2f.exponent_rnd = {2'h0,v_f2f.exponent_cvt} - {3'h0,v_f2f.exponent_bias};

		v_f2f.counter_cvt = 0;
		if ($signed(v_f2f.exponent_rnd) <= 0) begin
			v_f2f.counter_cvt = 63;
			if ($signed(v_f2f.exponent_rnd) > -63) begin
				v_f2f.counter_cvt = 14'h1 - v_f2f.exponent_rnd;
			end
			v_f2f.exponent_rnd = 0;
		end

		v_f2f.mantissa_cvt = v_f2f.mantissa_cvt >> v_f2f.counter_cvt[5:0];

		v_f2f.mantissa_rnd = {29'h0,v_f2f.mantissa_cvt[79:55]};
		v_f2f.grs = {v_f2f.mantissa_cvt[54:53],|v_f2f.mantissa_cvt[52:0]};
		if (v_f2f.fmt == 1) begin
			v_f2f.mantissa_rnd = v_f2f.mantissa_cvt[79:26];
			v_f2f.grs = {v_f2f.mantissa_cvt[25:24],|v_f2f.mantissa_cvt[23:0]};
		end

		fp_cvt_f2f_o.fp_rnd.sig = v_f2f.sign_rnd;
		fp_cvt_f2f_o.fp_rnd.expo = v_f2f.exponent_rnd;
		fp_cvt_f2f_o.fp_rnd.mant = v_f2f.mantissa_rnd;
		fp_cvt_f2f_o.fp_rnd.rema = 2'h0;
		fp_cvt_f2f_o.fp_rnd.fmt = v_f2f.fmt;
		fp_cvt_f2f_o.fp_rnd.rm = v_f2f.rm;
		fp_cvt_f2f_o.fp_rnd.grs = v_f2f.grs;
		fp_cvt_f2f_o.fp_rnd.snan = v_f2f.snan;
		fp_cvt_f2f_o.fp_rnd.qnan = v_f2f.qnan;
		fp_cvt_f2f_o.fp_rnd.dbz = v_f2f.dbz;
		fp_cvt_f2f_o.fp_rnd.inf = v_f2f.inf;
		fp_cvt_f2f_o.fp_rnd.zero = v_f2f.zero;

	end

	always_comb begin

		v_f2i.data = fp_cvt_f2i_i.data;
		v_f2i.op = fp_cvt_f2i_i.op.fcvt_op;
		v_f2i.rm = fp_cvt_f2i_i.rm;
		v_f2i.classification = fp_cvt_f2i_i.classification;

		v_f2i.flags = 0;
		v_f2i.result = 0;

		v_f2i.snan = v_f2i.classification[8];
		v_f2i.qnan = v_f2i.classification[9];
		v_f2i.inf = v_f2i.classification[0] | v_f2i.classification[7];
		v_f2i.zero = 0;

		if (v_f2i.op == 0) begin
			v_f2i.exponent_bias = 34;
		end else if (v_f2i.op == 1) begin
			v_f2i.exponent_bias = 35;
		end else if (v_f2i.op == 2) begin
			v_f2i.exponent_bias = 66;
		end else begin
			v_f2i.exponent_bias = 67;
		end

		v_f2i.sign_cvt = v_f2i.data[64];
		v_f2i.exponent_cvt = v_f2i.data[63:52] - 13'd2044;
		v_f2i.mantissa_cvt = {68'h1,v_f2i.data[51:0]};

		if ((v_f2i.classification[3] | v_f2i.classification[4]) == 1) begin
			v_f2i.mantissa_cvt[52] = 0;
		end

		v_f2i.oor = 0;

		if ($signed(v_f2i.exponent_cvt) > $signed({5'h0,v_f2i.exponent_bias})) begin
			v_f2i.oor = 1;
		end else if ($signed(v_f2i.exponent_cvt) > 0) begin
			v_f2i.mantissa_cvt = v_f2i.mantissa_cvt << v_f2i.exponent_cvt;
		end

		v_f2i.mantissa_uint = v_f2i.mantissa_cvt[119:55];

		v_f2i.grs = {v_f2i.mantissa_cvt[54:53],|v_f2i.mantissa_cvt[52:0]};
		v_f2i.odd = v_f2i.mantissa_uint[0] | |v_f2i.grs[1:0];

		v_f2i.rnded = 0;
		if (v_f2i.rm == 0) begin //rne
			if (v_f2i.grs[2] & v_f2i.odd) begin
				v_f2i.rnded = 1;
			end
		end else if (v_f2i.rm == 2) begin //rdn
			if (v_f2i.sign_cvt & v_f2i.flags[0]) begin
				v_f2i.rnded = 1;
			end
		end else if (v_f2i.rm == 3) begin //rup
			if (~v_f2i.sign_cvt & v_f2i.flags[0]) begin
				v_f2i.rnded = 1;
			end
		end else if (v_f2i.rm == 4) begin //rmm
			if (v_f2i.flags[0]) begin
				v_f2i.rnded = 1;
			end
		end

		v_f2i.mantissa_uint = v_f2i.mantissa_uint + {64'h0,v_f2i.rnded};

		v_f2i.or_1 = v_f2i.mantissa_uint[64];
		v_f2i.or_2 = v_f2i.mantissa_uint[63];
		v_f2i.or_3 = |v_f2i.mantissa_uint[62:32];
		v_f2i.or_4 = v_f2i.mantissa_uint[31];
		v_f2i.or_5 = |v_f2i.mantissa_uint[30:0];

		v_f2i.zero = v_f2i.or_1 | v_f2i.or_2 | v_f2i.or_3 | v_f2i.or_4 | v_f2i.or_5;

		v_f2i.oor_64u = v_f2i.or_1;
		v_f2i.oor_64s = v_f2i.or_1;
		v_f2i.oor_32u = v_f2i.or_1 | v_f2i.or_2 | v_f2i.or_3;
		v_f2i.oor_32s = v_f2i.or_1 | v_f2i.or_2 | v_f2i.or_3;

		if (v_f2i.sign_cvt) begin
			if (v_f2i.op == 0) begin
				v_f2i.oor_32s = v_f2i.oor_32s | (v_f2i.or_4 & v_f2i.or_5);
			end else if (v_f2i.op == 1) begin
				v_f2i.oor = v_f2i.oor | v_f2i.zero;
			end else if (v_f2i.op == 2) begin
				v_f2i.oor_64s = v_f2i.oor_64s | (v_f2i.or_2 & (v_f2i.or_3 | v_f2i.or_4 | v_f2i.or_5));
			end else if (v_f2i.op == 3) begin
				v_f2i.oor = v_f2i.oor | v_f2i.zero;
			end
		end else begin
			v_f2i.oor_64s = v_f2i.oor_64s | v_f2i.or_2;
			v_f2i.oor_32s = v_f2i.oor_32s | v_f2i.or_4;
		end

		v_f2i.oor_64u = (v_f2i.op == 3) & (v_f2i.oor_64u | v_f2i.oor | v_f2i.inf | v_f2i.snan | v_f2i.qnan);
		v_f2i.oor_64s = (v_f2i.op == 2) & (v_f2i.oor_64s | v_f2i.oor | v_f2i.inf | v_f2i.snan | v_f2i.qnan);
		v_f2i.oor_32u = (v_f2i.op == 1) & (v_f2i.oor_32u | v_f2i.oor | v_f2i.inf | v_f2i.snan | v_f2i.qnan);
		v_f2i.oor_32s = (v_f2i.op == 0) & (v_f2i.oor_32s | v_f2i.oor | v_f2i.inf | v_f2i.snan | v_f2i.qnan);

		if (v_f2i.sign_cvt) begin
			v_f2i.mantissa_uint = -v_f2i.mantissa_uint;
		end

		v_f2i.flags[0] = |v_f2i.grs;

		if (v_f2i.op == 0) begin
			v_f2i.result = {32'h0,v_f2i.mantissa_uint[31:0]};
			if (v_f2i.oor_32s) begin
				v_f2i.result = 64'h0000000080000000;
				v_f2i.flags = 5'b10000;
			end
		end else if (v_f2i.op == 1) begin
			v_f2i.result = {32'h0,v_f2i.mantissa_uint[31:0]};
			if (v_f2i.oor_32u) begin
				v_f2i.result = 64'h00000000FFFFFFFF;
				v_f2i.flags = 5'b10000;
			end
		end else if (v_f2i.op == 2) begin
			v_f2i.result = v_f2i.mantissa_uint[63:0];
			if (v_f2i.oor_64s) begin
				v_f2i.result = 64'h8000000000000000;
				v_f2i.flags = 5'b10000;
			end
		end else if (v_f2i.op == 3) begin
			v_f2i.result = v_f2i.mantissa_uint[63:0];
			if (v_f2i.oor_64u) begin
				v_f2i.result = 64'hFFFFFFFFFFFFFFFF;
				v_f2i.flags = 5'b10000;
			end
		end

		fp_cvt_f2i_o.result = v_f2i.result;
		fp_cvt_f2i_o.flags = v_f2i.flags;

	end

	always_comb begin

		v_i2f.data = fp_cvt_i2f_i.data;
		v_i2f.op = fp_cvt_i2f_i.op.fcvt_op;
		v_i2f.fmt = fp_cvt_i2f_i.fmt;
		v_i2f.rm = fp_cvt_i2f_i.rm;

		v_i2f.snan = 0;
		v_i2f.qnan = 0;
		v_i2f.dbz = 0;
		v_i2f.inf = 0;
		v_i2f.zero = 0;

		v_i2f.exponent_bias = 127;
		if (v_i2f.fmt == 1) begin
			v_i2f.exponent_bias = 1023;
		end

		v_i2f.sign_uint = 0;
		if (v_i2f.op == 0) begin
			v_i2f.sign_uint = v_i2f.data[31];
		end else if (v_i2f.op == 2) begin
			v_i2f.sign_uint = v_i2f.data[63];
		end

		if (v_i2f.sign_uint) begin
			v_i2f.data = -v_i2f.data;
		end

		v_i2f.mantissa_uint = 64'hFFFFFFFFFFFFFFFF;
		v_i2f.exponent_uint = 0;
		if (!v_i2f.op[1]) begin
			v_i2f.mantissa_uint = {v_i2f.data[31:0],32'h0};
			v_i2f.exponent_uint = 31;
		end else if (v_i2f.op[1]) begin
			v_i2f.mantissa_uint = v_i2f.data[63:0];
			v_i2f.exponent_uint = 63;
		end

		v_i2f.zero = ~|v_i2f.mantissa_uint;

		lzc_i.a = v_i2f.mantissa_uint;
		v_i2f.counter_uint = ~lzc_o.c;

		v_i2f.mantissa_uint = v_i2f.mantissa_uint << v_i2f.counter_uint;

		v_i2f.sign_rnd = v_i2f.sign_uint;
		v_i2f.exponent_rnd = {8'h0,v_i2f.exponent_uint} + {4'h0,v_i2f.exponent_bias} - {8'h0,v_i2f.counter_uint};

		v_i2f.mantissa_rnd = {30'h0,v_i2f.mantissa_uint[63:40]};
		v_i2f.grs = {v_i2f.mantissa_uint[39:38],|v_i2f.mantissa_uint[37:0]};
		if (v_i2f.fmt == 1) begin
			v_i2f.mantissa_rnd = {1'h0,v_i2f.mantissa_uint[63:11]};
			v_i2f.grs = {v_i2f.mantissa_uint[10:9],|v_i2f.mantissa_uint[8:0]};
		end

		fp_cvt_i2f_o.fp_rnd.sig = v_i2f.sign_rnd;
		fp_cvt_i2f_o.fp_rnd.expo = v_i2f.exponent_rnd;
		fp_cvt_i2f_o.fp_rnd.mant = v_i2f.mantissa_rnd;
		fp_cvt_i2f_o.fp_rnd.rema = 2'h0;
		fp_cvt_i2f_o.fp_rnd.fmt = v_i2f.fmt;
		fp_cvt_i2f_o.fp_rnd.rm = v_i2f.rm;
		fp_cvt_i2f_o.fp_rnd.grs = v_i2f.grs;
		fp_cvt_i2f_o.fp_rnd.snan = v_i2f.snan;
		fp_cvt_i2f_o.fp_rnd.qnan = v_i2f.qnan;
		fp_cvt_i2f_o.fp_rnd.dbz = v_i2f.dbz;
		fp_cvt_i2f_o.fp_rnd.inf = v_i2f.inf;
		fp_cvt_i2f_o.fp_rnd.zero = v_i2f.zero;

	end

endmodule
