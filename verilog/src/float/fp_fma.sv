import lzc_wire::*;
import fp_wire::*;

module fp_fma
(
	input reset,
	input clock,
	input fp_fma_in_type fp_fma_i,
	output fp_fma_out_type fp_fma_o,
	input lzc_256_out_type lzc_o,
	output lzc_256_in_type lzc_i
);

	fp_fma_reg_type_1 r_1;
	fp_fma_reg_type_2 r_2;
	fp_fma_reg_type_3 r_3;
	fp_fma_reg_type_4 r_4;

	fp_fma_reg_type_1 rin_1;
	fp_fma_reg_type_2 rin_2;
	fp_fma_reg_type_3 rin_3;
	fp_fma_reg_type_4 rin_4;

	fp_fma_var_type_1 v_1;
	fp_fma_var_type_2 v_2;
	fp_fma_var_type_3 v_3;
	fp_fma_var_type_4 v_4;

	initial begin

		r_1 = init_fp_fma_reg_1;
		r_2 = init_fp_fma_reg_2;
		r_3 = init_fp_fma_reg_3;
		r_4 = init_fp_fma_reg_4;

		rin_1 = init_fp_fma_reg_1;
		rin_2 = init_fp_fma_reg_2;
		rin_3 = init_fp_fma_reg_3;
		rin_4 = init_fp_fma_reg_4;

	end

	always_comb begin

		v_1.a = fp_fma_i.data1;
		v_1.b = fp_fma_i.data2;
		v_1.c = fp_fma_i.data3;
		v_1.class_a = fp_fma_i.class1;
		v_1.class_b = fp_fma_i.class2;
		v_1.class_c = fp_fma_i.class3;
		v_1.fmt = fp_fma_i.fmt;
		v_1.rm = fp_fma_i.rm;
		v_1.snan = 0;
		v_1.qnan = 0;
		v_1.dbz = 0;
		v_1.inf = 0;
		v_1.zero = 0;
		v_1.neg = fp_fma_i.op.fnmsub | fp_fma_i.op.fnmadd;
		v_1.ready = fp_fma_i.op.fmadd | fp_fma_i.op.fmsub | fp_fma_i.op.fnmsub | fp_fma_i.op.fnmadd | fp_fma_i.op.fadd | fp_fma_i.op.fsub | fp_fma_i.op.fmul;

		if (fp_fma_i.op.fadd | fp_fma_i.op.fsub) begin
			v_1.c = v_1.b;
			v_1.class_c = v_1.class_b;
			v_1.b = 65'h07FF0000000000000;
			v_1.class_b = 10'h040;
		end

		if (fp_fma_i.op.fmsub | fp_fma_i.op.fnmsub | fp_fma_i.op.fsub) begin
			v_1.c[64] = ~v_1.c[64];
		end

		if (fp_fma_i.op.fmul) begin
			v_1.c = {v_1.a[64] ^ v_1.b[64],64'h0000000000000000};
			v_1.class_c = 0;
		end

		v_1.sign_a = v_1.a[64];
		v_1.exponent_a = v_1.a[63:52];
		v_1.mantissa_a = {|v_1.exponent_a,v_1.a[51:0]};

		v_1.sign_b = v_1.b[64];
		v_1.exponent_b = v_1.b[63:52];
		v_1.mantissa_b = {|v_1.exponent_b,v_1.b[51:0]};

		v_1.sign_c = v_1.c[64];
		v_1.exponent_c = v_1.c[63:52];
		v_1.mantissa_c = {|v_1.exponent_c,v_1.c[51:0]};

		if (v_1.class_a[8] | v_1.class_b[8] | v_1.class_c[8]) begin
			v_1.snan = 1;
		end else if (((v_1.class_a[3] | v_1.class_a[4]) & (v_1.class_b[0] | v_1.class_b[7])) | ((v_1.class_b[3] | v_1.class_b[4]) & (v_1.class_a[0] | v_1.class_a[7]))) begin
			v_1.snan = 1;
		end else if (v_1.class_a[9] | v_1.class_b[9] | v_1.class_c[9]) begin
			v_1.qnan = 1;
		end else if (((v_1.class_a[0] | v_1.class_a[7]) | (v_1.class_b[0] | v_1.class_b[7])) & ((v_1.class_c[0] | v_1.class_c[7]) & ((v_1.a[64] ^ v_1.b[64]) != v_1.c[64]))) begin
			v_1.snan = 1;
		end else if ((v_1.class_a[0] | v_1.class_a[7]) | (v_1.class_b[0] | v_1.class_b[7]) | (v_1.class_c[0] | v_1.class_c[7])) begin
			v_1.inf = 1;
		end

		rin_1.fmt = v_1.fmt;
		rin_1.rm = v_1.rm;
		rin_1.snan = v_1.snan;
		rin_1.qnan = v_1.qnan;
		rin_1.dbz = v_1.dbz;
		rin_1.inf = v_1.inf;
		rin_1.zero = v_1.zero;
		rin_1.neg = v_1.neg;
		rin_1.sign_a = v_1.sign_a;
		rin_1.exponent_a = v_1.exponent_a;
		rin_1.mantissa_a = v_1.mantissa_a;
		rin_1.sign_b = v_1.sign_b;
		rin_1.exponent_b = v_1.exponent_b;
		rin_1.mantissa_b = v_1.mantissa_b;
		rin_1.sign_c = v_1.sign_c;
		rin_1.exponent_c = v_1.exponent_c;
		rin_1.mantissa_c = v_1.mantissa_c;
		rin_1.ready = v_1.ready;

	end

	always_comb begin

		v_2.fmt        = r_1.fmt;
		v_2.rm         = r_1.rm;
		v_2.snan       = r_1.snan;
		v_2.qnan       = r_1.qnan;
		v_2.dbz        = r_1.dbz;
		v_2.inf        = r_1.inf;
		v_2.zero       = r_1.zero;
		v_2.neg        = r_1.neg;
		v_2.sign_a     = r_1.sign_a;
		v_2.exponent_a = r_1.exponent_a;
		v_2.mantissa_a = r_1.mantissa_a;
		v_2.sign_b     = r_1.sign_b;
		v_2.exponent_b = r_1.exponent_b;
		v_2.mantissa_b = r_1.mantissa_b;
		v_2.sign_c     = r_1.sign_c;
		v_2.exponent_c = r_1.exponent_c;
		v_2.mantissa_c = r_1.mantissa_c;
		v_2.ready      = r_1.ready;

		v_2.sign_add = v_2.sign_c;
		v_2.sign_mul = v_2.sign_a ^ v_2.sign_b;

		v_2.exponent_add = $signed({2'h0,v_2.exponent_c});
		v_2.exponent_mul = $signed({2'h0,v_2.exponent_a}) + $signed({2'h0,v_2.exponent_b}) - 2047;

		if (&v_2.exponent_c) begin
			v_2.exponent_add = 14'h0FFF;
		end
		if (&v_2.exponent_a | &v_2.exponent_b) begin
			v_2.exponent_mul = 14'h0FFF;
		end

		v_2.mantissa_add[163:161] = 0;
		v_2.mantissa_add[160:108] = v_2.mantissa_c;
		v_2.mantissa_add[107:0] = 0;
		v_2.mantissa_mul[163:162] = 0;
		v_2.mantissa_mul[161:56] = v_2.mantissa_a * v_2.mantissa_b;
		v_2.mantissa_mul[55:0] = 0;

		v_2.exponent_dif = $signed(v_2.exponent_mul) - $signed(v_2.exponent_add);
		v_2.counter_dif  = 0;

		v_2.exponent_neg = v_2.exponent_dif[13];

		if (v_2.exponent_neg) begin
			v_2.counter_dif = 56;
			if ($signed(v_2.exponent_dif) > -56) begin
				v_2.counter_dif = -v_2.exponent_dif[6:0];
			end
			v_2.mantissa_l = v_2.mantissa_add;
			v_2.mantissa_r = v_2.mantissa_mul;
		end else begin
			v_2.counter_dif = 108;
			if ($signed(v_2.exponent_dif) < 108) begin
				v_2.counter_dif = v_2.exponent_dif[6:0];
			end
			v_2.mantissa_l  = v_2.mantissa_mul;
			v_2.mantissa_r  = v_2.mantissa_add;
		end

		v_2.mantissa_r = v_2.mantissa_r >> v_2.counter_dif;

		if (v_2.exponent_neg) begin
			v_2.mantissa_add = v_2.mantissa_l;
			v_2.mantissa_mul = v_2.mantissa_r;
		end else begin
			v_2.mantissa_add = v_2.mantissa_r;
			v_2.mantissa_mul = v_2.mantissa_l;
		end

		rin_2.fmt = v_2.fmt;
		rin_2.rm = v_2.rm;
		rin_2.snan = v_2.snan;
		rin_2.qnan = v_2.qnan;
		rin_2.dbz = v_2.dbz;
		rin_2.inf = v_2.inf;
		rin_2.zero = v_2.zero;
		rin_2.neg = v_2.neg;
		rin_2.sign_mul = v_2.sign_mul;
		rin_2.exponent_mul = v_2.exponent_mul;
		rin_2.mantissa_mul = v_2.mantissa_mul;
		rin_2.sign_add = v_2.sign_add;
		rin_2.exponent_add = v_2.exponent_add;
		rin_2.mantissa_add = v_2.mantissa_add;
		rin_2.exponent_neg = v_2.exponent_neg;
		rin_2.ready = v_2.ready;

	end

	always_comb begin

		v_3.fmt          = r_2.fmt;
		v_3.rm           = r_2.rm;
		v_3.snan         = r_2.snan;
		v_3.qnan         = r_2.qnan;
		v_3.dbz          = r_2.dbz;
		v_3.inf          = r_2.inf;
		v_3.zero         = r_2.zero;
		v_3.neg          = r_2.neg;
		v_3.sign_mul     = r_2.sign_mul;
		v_3.exponent_mul = r_2.exponent_mul;
		v_3.mantissa_mul = r_2.mantissa_mul;
		v_3.sign_add     = r_2.sign_add;
		v_3.exponent_add = r_2.exponent_add;
		v_3.mantissa_add = r_2.mantissa_add;
		v_3.exponent_neg = r_2.exponent_neg;
		v_3.ready        = r_2.ready;

		if (v_3.exponent_neg) begin
			v_3.exponent_mac = v_3.exponent_add;
		end else begin
			v_3.exponent_mac = v_3.exponent_mul;
		end

		if (v_3.sign_add) begin
			v_3.mantissa_add = ~v_3.mantissa_add;
		end
		if (v_3.sign_mul) begin
			v_3.mantissa_mul = ~v_3.mantissa_mul;
		end

		v_3.mantissa_mac = v_3.mantissa_add + v_3.mantissa_mul + {163'h0,v_3.sign_add} + {163'h0,v_3.sign_mul};
		v_3.sign_mac     = v_3.mantissa_mac[163];

		v_3.zero = ~|v_3.mantissa_mac;

		if (v_3.zero) begin
			v_3.sign_mac = v_3.sign_add & v_3.sign_mul;
		end else if (v_3.sign_mac) begin
			v_3.mantissa_mac = -v_3.mantissa_mac;
		end

		rin_3.fmt = v_3.fmt;
		rin_3.rm = v_3.rm;
		rin_3.snan = v_3.snan;
		rin_3.qnan = v_3.qnan;
		rin_3.dbz = v_3.dbz;
		rin_3.inf = v_3.inf;
		rin_3.zero = v_3.zero;
		rin_3.neg = v_3.neg;
		rin_3.sign_mac = v_3.sign_mac;
		rin_3.exponent_mac = v_3.exponent_mac;
		rin_3.mantissa_mac = v_3.mantissa_mac;
		rin_3.ready = v_3.ready;

	end

	always_comb begin

		v_4.fmt          = r_3.fmt;
		v_4.rm           = r_3.rm;
		v_4.snan         = r_3.snan;
		v_4.qnan         = r_3.qnan;
		v_4.dbz          = r_3.dbz;
		v_4.inf          = r_3.inf;
		v_4.zero         = r_3.zero;
		v_4.neg          = r_3.neg;
		v_4.sign_mac     = r_3.sign_mac;
		v_4.exponent_mac = r_3.exponent_mac;
		v_4.mantissa_mac = r_3.mantissa_mac;
		v_4.ready        = r_3.ready;

		v_4.bias = 1918;
		if (v_4.fmt == 1) begin
			v_4.bias = 1022;
		end

		lzc_i.a = {v_4.mantissa_mac[162:0],{93{1'b1}}};
		v_4.counter_mac  = ~lzc_o.c;
		v_4.mantissa_mac = v_4.mantissa_mac << v_4.counter_mac;

		v_4.sign_rnd = v_4.sign_mac ^ v_4.neg;
		v_4.exponent_rnd = v_4.exponent_mac - {3'h0,v_4.bias} - {6'h0,v_4.counter_mac};

		v_4.counter_sub = 0;
		if ($signed(v_4.exponent_rnd) <= 0) begin
			v_4.counter_sub  = 63;
			if ($signed(v_4.exponent_rnd) > -63) begin
				v_4.counter_sub = 14'h1 - v_4.exponent_rnd;
			end
			v_4.exponent_rnd = 0;
		end

		v_4.mantissa_mac = v_4.mantissa_mac >> v_4.counter_sub[5:0];

		v_4.mantissa_rnd = {30'h0,v_4.mantissa_mac[162:139]};
		v_4.grs = {v_4.mantissa_mac[138:137],|v_4.mantissa_mac[136:0]};
		if (v_4.fmt == 1) begin
			v_4.mantissa_rnd = {1'h0,v_4.mantissa_mac[162:110]};
			v_4.grs = {v_4.mantissa_mac[109:108],|v_4.mantissa_mac[107:0]};
		end

		rin_4.sign_rnd = v_4.sign_rnd;
		rin_4.exponent_rnd = v_4.exponent_rnd;
		rin_4.mantissa_rnd = v_4.mantissa_rnd;
		rin_4.fmt = v_4.fmt;
		rin_4.rm = v_4.rm;
		rin_4.grs = v_4.grs;
		rin_4.snan = v_4.snan;
		rin_4.qnan = v_4.qnan;
		rin_4.dbz = v_4.dbz;
		rin_4.inf = v_4.inf;
		rin_4.zero = v_4.zero;
		rin_4.ready = v_4.ready;

	end

	always_comb begin

		fp_fma_o.fp_rnd.sig = r_4.sign_rnd;
		fp_fma_o.fp_rnd.expo = r_4.exponent_rnd;
		fp_fma_o.fp_rnd.mant = r_4.mantissa_rnd;
		fp_fma_o.fp_rnd.rema = 2'h0;
		fp_fma_o.fp_rnd.fmt = r_4.fmt;
		fp_fma_o.fp_rnd.rm = r_4.rm;
		fp_fma_o.fp_rnd.grs = r_4.grs;
		fp_fma_o.fp_rnd.snan = r_4.snan;
		fp_fma_o.fp_rnd.qnan = r_4.qnan;
		fp_fma_o.fp_rnd.dbz = r_4.dbz;
		fp_fma_o.fp_rnd.inf = r_4.inf;
		fp_fma_o.fp_rnd.zero = r_4.zero;
		fp_fma_o.ready = r_4.ready;

	end

	always_ff @(posedge clock) begin
		if (!reset) begin
			r_1 <= init_fp_fma_reg_1;
			r_2 <= init_fp_fma_reg_2;
			r_3 <= init_fp_fma_reg_3;
			r_4 <= init_fp_fma_reg_4;
		end else begin
			r_1 <= rin_1;
			r_2 <= rin_2;
			r_3 <= rin_3;
			r_4 <= rin_4;
		end
	end

endmodule
