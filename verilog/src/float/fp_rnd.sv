import fp_wire::*;

module fp_rnd
(
	input fp_rnd_in_type fp_rnd_i,
	output fp_rnd_out_type fp_rnd_o
);
	timeunit 1ns;
	timeprecision 1ps;

	logic sig;
	logic [13:0] expo;
	logic [53:0] mant;
	logic [1:0] rema;
	logic [1:0] fmt;
	logic [2:0] rm;
	logic [2:0] grs;
	logic snan;
	logic qnan;
	logic dbz;
	logic inf;
	logic zero;

	logic odd;
	logic rnded;
	logic [63:0] result;
	logic [4:0] flags;

	always_comb begin

		sig  = fp_rnd_i.sig;
		expo = fp_rnd_i.expo;
		mant = fp_rnd_i.mant;
		rema = fp_rnd_i.rema;
		fmt  = fp_rnd_i.fmt;
		rm   = fp_rnd_i.rm;
		grs  = fp_rnd_i.grs;
		snan = fp_rnd_i.snan;
		qnan = fp_rnd_i.qnan;
		dbz  = fp_rnd_i.dbz;
		inf  = fp_rnd_i.inf;
		zero = fp_rnd_i.zero;

		result = 0;
		flags = 0;

		odd = mant[0] | |grs[1:0] | (rema == 1);
		flags[0] = (rema != 0) | |grs;

		rnded = 0;
		if (rm == 0) begin                       //rne
			if (grs[2] & odd) begin
				rnded = 1;
			end
		end else if (rm == 2) begin              //rdn
			if (sig & flags[0]) begin
				rnded = 1;
			end
		end else if (rm == 3) begin              //rup
			if (~sig & flags[0]) begin
				rnded = 1;
			end
		end else if (rm == 4) begin              //rmm
			if (grs[2] & flags[0]) begin
				rnded = 1;
			end
		end

		if (expo == 0) begin
			flags[1] = flags[0];
		end

		mant = mant + {53'h0,rnded};

		rnded = 0;
		if (fmt == 0) begin
			if (mant[24]) begin
				rnded = 1;
			end else if (mant[23]) begin
				if (expo == 0) begin
					expo = 1;
					if (expo == 1) begin
						flags[1] = ~grs[1];
					end
				end
			end
		end else if (fmt == 1) begin
			if (mant[53]) begin
				rnded = 1;
			end else if (mant[52]) begin
				if (expo == 0) begin
					expo = 1;
					if (expo == 1) begin
						flags[1] = ~grs[1];
					end
				end
			end
		end

		expo = expo + {13'h0,rnded};
		mant = mant >> rnded;

		if (snan) begin
			flags = 5'b10000;
		end else if (qnan) begin
			flags = 5'b00000;
		end else if (dbz) begin
			flags = 5'b01000;
		end else if (inf) begin
			flags = 5'b00000;
		end else if (zero) begin
			flags = 5'b00000;
		end

		if (fmt == 0) begin
			if (snan | qnan) begin
				result = {32'h00000000,1'h0,8'hFF,23'h400000};
			end else if (dbz | inf) begin
				result = {32'h00000000,sig,8'hFF,23'h000000};
			end else if (zero) begin
				result = {32'h00000000,sig,8'h00,23'h000000};
			end else if (expo == 0) begin
				result = {32'h00000000,sig,8'h00,mant[22:0]};
			end else if ($signed(expo) > 254) begin
				flags  = 5'b00101;
				result = {32'h00000000,sig,8'hFF,23'h000000};
			end else begin
				result = {32'h00000000,sig,expo[7:0],mant[22:0]};
			end
		end else if (fmt == 1) begin
			if (snan | qnan) begin
				result = {1'h0,11'h7FF,52'h8000000000000};
			end else if (dbz | inf) begin
				result = {sig,11'h7FF,52'h0000000000000};
			end else if (zero) begin
				result = {sig,11'h000,52'h0000000000000};
			end else if (expo == 0) begin
				result = {sig,11'h000,mant[51:0]};
			end else if ($signed(expo) > 2046) begin
				flags  = 5'b00101;
				result = {sig,11'h7FF,52'h0000000000000};
			end else begin
				result = {sig,expo[10:0],mant[51:0]};
			end
		end

		fp_rnd_o.result = result;
		fp_rnd_o.flags = flags;

	end

endmodule
