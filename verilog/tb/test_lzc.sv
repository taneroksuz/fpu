module test_lzc;

	timeunit 1ns;
	timeprecision 1ps;

	parameter xlen = 256;
	parameter xlog = 8;

	logic [(xlen-1):0] a;
	logic [(xlog-1):0] counter;

	logic [xlen-1:0] msb;
	logic [xlen-1:0] lsb;
	logic [xlog-1:0] max;

	logic [(xlog-1):0] c;
	logic v;

	logic reset = 0;
	logic clock = 0;

	initial begin
		$timeformat(-9,0,"ns",0);
		#10ns reset = 1;
	end

	always begin
		#1ns clock=~clock;
	end

	initial begin
		msb = {{1'b1},{xlen-1{1'b0}}};
		lsb = {{xlen-1{1'b0}},{1'b1}};
		max = {xlog{1'b1}};
	end

	always_ff @(posedge clock) begin
		if (reset == 0) begin
			a <= lsb;
			counter <= max;
		end else begin
			if (a == msb) begin
				$write("%c[1;32m",8'h1B);
				$display("TEST SUCCEEDED");
				$write("%c[0m",8'h1B);
				$display("simulation finished @%0t",$time);
				$finish;
			end
			if (counter != (~c)) begin
				$write("%c[1;31m",8'h1B);
				$display("TEST FAILED");
				$write("%c[0m",8'h1B);
				$display("simulation finished @%0t",$time);
				$finish;
			end
			a <= a << 1;
			counter <= counter - 1;
		end
	end

	generate
		if (xlen == 4) begin
			lzc_4 lzc_comp ( .a (a), .c (c), .v (v));
		end
		if (xlen == 8) begin
			lzc_8 lzc_comp ( .a (a), .c (c), .v (v));
		end
		if (xlen == 16) begin
			lzc_16 lzc_comp ( .a (a), .c (c), .v (v));
		end
		if (xlen == 32) begin
			lzc_32 lzc_comp ( .a (a), .c (c), .v (v));
		end
		if (xlen == 64) begin
			lzc_64 lzc_comp ( .a (a), .c (c), .v (v));
		end
		if (xlen == 128) begin
			lzc_128 lzc_comp ( .a (a), .c (c), .v (v));
		end
		if (xlen == 256) begin
			lzc_256 lzc_comp ( .a (a), .c (c), .v (v));
		end
	endgenerate

endmodule
