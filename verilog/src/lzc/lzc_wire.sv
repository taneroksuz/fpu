package lzc_wire;
	timeunit 1ns;
	timeprecision 1ps;

	typedef struct packed{
		logic [63:0] a;
	} lzc_64_in_type;

	typedef struct packed{
		logic [5:0] c;
		logic v;
	} lzc_64_out_type;

	typedef struct packed{
		logic [255:0] a;
	} lzc_256_in_type;

	typedef struct packed{
		logic [7:0] c;
		logic v;
	} lzc_256_out_type;

endpackage
