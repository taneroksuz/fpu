import lzc_wire::*;
import fp_wire::*;

module fp_unit
(
	input reset,
	input clock,
	input fp_unit_in_type fp_unit_i,
	output fp_unit_out_type fp_unit_o
);
	timeunit 1ns;
	timeprecision 1ps;

	lzc_64_in_type lzc1_64_i;
	lzc_64_out_type lzc1_64_o;
	lzc_64_in_type lzc2_64_i;
	lzc_64_out_type lzc2_64_o;
	lzc_64_in_type lzc3_64_i;
	lzc_64_out_type lzc3_64_o;
	lzc_64_in_type lzc4_64_i;
	lzc_64_out_type lzc4_64_o;

	lzc_256_in_type lzc_256_i;
	lzc_256_out_type lzc_256_o;

	fp_ext_in_type fp_ext1_i;
	fp_ext_out_type fp_ext1_o;
	fp_ext_in_type fp_ext2_i;
	fp_ext_out_type fp_ext2_o;
	fp_ext_in_type fp_ext3_i;
	fp_ext_out_type fp_ext3_o;

	fp_cmp_in_type fp_cmp_i;
	fp_cmp_out_type fp_cmp_o;
	fp_max_in_type fp_max_i;
	fp_max_out_type fp_max_o;
	fp_sgnj_in_type fp_sgnj_i;
	fp_sgnj_out_type fp_sgnj_o;
	fp_fma_in_type fp_fma_i;
	fp_fma_out_type fp_fma_o;
	fp_rnd_in_type fp_rnd_i;
	fp_rnd_out_type fp_rnd_o;

	fp_cvt_f2f_in_type fp_cvt_f2f_i;
	fp_cvt_f2f_out_type fp_cvt_f2f_o;
	fp_cvt_f2i_in_type fp_cvt_f2i_i;
	fp_cvt_f2i_out_type fp_cvt_f2i_o;
	fp_cvt_i2f_in_type fp_cvt_i2f_i;
	fp_cvt_i2f_out_type fp_cvt_i2f_o;

	fp_mac_in_type fp_mac_i;
	fp_mac_out_type fp_mac_o;
	fp_fdiv_in_type fp_fdiv_i;
	fp_fdiv_out_type fp_fdiv_o;

	lzc_64 lzc_64_comp_1
	(
	.a ( lzc1_64_i.a ),
	.c ( lzc1_64_o.c ),
	.v ( lzc1_64_o.v )
	);

	lzc_64 lzc_64_comp_2
	(
	.a ( lzc2_64_i.a ),
	.c ( lzc2_64_o.c ),
	.v ( lzc2_64_o.v )
	);

	lzc_64 lzc_64_comp_3
	(
	.a ( lzc3_64_i.a ),
	.c ( lzc3_64_o.c ),
	.v ( lzc3_64_o.v )
	);

	lzc_64 lzc_64_comp_4
	(
	.a ( lzc4_64_i.a ),
	.c ( lzc4_64_o.c ),
	.v ( lzc4_64_o.v )
	);

	lzc_256 lzc_256_comp
	(
	.a ( lzc_256_i.a ),
	.c ( lzc_256_o.c ),
	.v ( lzc_256_o.v )
	);

	fp_ext fp_ext_comp_1
	(
	.fp_ext_i ( fp_ext1_i	),
	.fp_ext_o ( fp_ext1_o	),
	.lzc_o ( lzc1_64_o	),
	.lzc_i ( lzc1_64_i )
	);

	fp_ext fp_ext_comp_2
	(
	.fp_ext_i ( fp_ext2_i	),
	.fp_ext_o ( fp_ext2_o	),
	.lzc_o ( lzc2_64_o	),
	.lzc_i ( lzc2_64_i )
	);

	fp_ext fp_ext_comp_3
	(
	.fp_ext_i ( fp_ext3_i	),
	.fp_ext_o ( fp_ext3_o	),
	.lzc_o ( lzc3_64_o	),
	.lzc_i ( lzc3_64_i )
	);

	fp_cmp fp_cmp_comp
	(
	.fp_cmp_i ( fp_cmp_i ),
	.fp_cmp_o ( fp_cmp_o )
	);

	fp_max fp_max_comp
	(
	.fp_max_i ( fp_max_i ),
	.fp_max_o ( fp_max_o )
	);

	fp_sgnj fp_sgnj_comp
	(
	.fp_sgnj_i ( fp_sgnj_i ),
	.fp_sgnj_o ( fp_sgnj_o )
	);

	fp_cvt fp_cvt_comp
	(
	.fp_cvt_f2f_i (fp_cvt_f2f_i),
	.fp_cvt_f2f_o (fp_cvt_f2f_o),
	.fp_cvt_f2i_i (fp_cvt_f2i_i),
	.fp_cvt_f2i_o (fp_cvt_f2i_o),
	.fp_cvt_i2f_i (fp_cvt_i2f_i),
	.fp_cvt_i2f_o (fp_cvt_i2f_o),
	.lzc_o (lzc4_64_o),
	.lzc_i (lzc4_64_i)
	);

	fp_fma fp_fma_comp
	(
	.reset ( reset ),
	.clock ( clock ),
	.fp_fma_i ( fp_fma_i ),
	.fp_fma_o ( fp_fma_o ),
	.lzc_o ( lzc_256_o ),
	.lzc_i ( lzc_256_i )
	);

	fp_mac fp_mac_comp
	(
	.reset (reset),
	.clock (clock),
	.fp_mac_i (fp_mac_i),
	.fp_mac_o (fp_mac_o)
	);

	fp_fdiv fp_fdiv_comp
	(
	.reset (reset),
	.clock (clock),
	.fp_fdiv_i (fp_fdiv_i),
	.fp_fdiv_o (fp_fdiv_o),
	.fp_mac_o (fp_mac_o),
	.fp_mac_i (fp_mac_i)
	);

	fp_rnd fp_rnd_comp
	(
	.fp_rnd_i (fp_rnd_i),
	.fp_rnd_o (fp_rnd_o)
	);

	fp_exe fp_exe_comp
	(
	.fp_exe_i ( fp_unit_i.fp_exe_i ),
	.fp_exe_o ( fp_unit_o.fp_exe_o ),
	.fp_ext1_o ( fp_ext1_o ),
	.fp_ext1_i ( fp_ext1_i ),
	.fp_ext2_o ( fp_ext2_o ),
	.fp_ext2_i ( fp_ext2_i ),
	.fp_ext3_o ( fp_ext3_o ),
	.fp_ext3_i ( fp_ext3_i ),
	.fp_cmp_o ( fp_cmp_o ),
	.fp_cmp_i ( fp_cmp_i ),
	.fp_max_o ( fp_max_o ),
	.fp_max_i ( fp_max_i ),
	.fp_sgnj_o ( fp_sgnj_o ),
	.fp_sgnj_i ( fp_sgnj_i ),
	.fp_cvt_f2f_i (fp_cvt_f2f_i),
	.fp_cvt_f2f_o (fp_cvt_f2f_o),
	.fp_cvt_f2i_i (fp_cvt_f2i_i),
	.fp_cvt_f2i_o (fp_cvt_f2i_o),
	.fp_cvt_i2f_i (fp_cvt_i2f_i),
	.fp_cvt_i2f_o (fp_cvt_i2f_o),
	.fp_fma_o ( fp_fma_o ),
	.fp_fma_i ( fp_fma_i ),
	.fp_fdiv_o (fp_fdiv_o),
	.fp_fdiv_i (fp_fdiv_i),
	.fp_rnd_o ( fp_rnd_o ),
	.fp_rnd_i ( fp_rnd_i )
	);

endmodule
