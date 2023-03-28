import fp_wire::*;

module test_float_s;

	timeunit 1ns;
	timeprecision 1ps;

	integer data_file;
	integer scan_file;

	logic [287:0] dataread;

	logic [63:0] result_calc;
	logic [4:0] flags_calc;
	logic ready_calc;
	logic enable;
	logic finish;

	typedef struct packed{
		logic [63:0] data1;
		logic [63:0] data2;
		logic [63:0] data3;
		logic [63:0] result;
		logic [4:0] flags;
		logic [1:0] fmt;
		logic [2:0] rm;
		logic [1:0] op;
		logic [9:0] opcode;
	} fp_result;

	fp_result init_fp_res = '{
		data1 : 0,
		data2 : 0,
		data3 : 0,
		result : 0,
		flags : 0,
		fmt : 0,
		rm : 0,
		op : 0,
		opcode : 0
	};

	fp_result fp_res;
	fp_result fp_res_reg;

	fp_unit_in_type fp_unit_i;
	fp_unit_out_type fp_unit_o;

	localparam idle = 0;
	localparam next = 1;
	localparam busy = 2;
	localparam comp = 3;
	localparam stop = 4;

	logic [2:0] state;
	logic [2:0] state_reg;

	logic [63:0] result_diff;
	logic [4:0] flags_diff;

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
		$dumpfile("fpu.vcd");
		$dumpvars(0,test_float_s);
	end

	initial begin
		data_file = $fopen("fpu.dat", "r");
		if (data_file == 0) begin
			$display("fpu.dat is not available!");
			$finish;
		end
	end

	generate

		always_ff @(posedge clock) begin
			if (reset == 0) begin
				enable <= 0;
				finish <= 0;
				dataread <= 0;
			end else begin
				if (state == next) begin
					if ($feof(data_file)) begin
						enable <= 1;
						finish <= 1;
						dataread <= 0;
					end else begin
						enable <= 1;
						finish <= 0;
						scan_file <= $fscanf(data_file,"%h\n", dataread);
					end
				end else begin
					enable <= 0;
					finish <= 0;
					dataread <= 0;
				end
			end
		end

		always_ff @(posedge clock) begin
			if (reset == 0) begin
				state_reg <= idle;
				fp_res_reg <= init_fp_res;
			end else begin
				state_reg <= state;
				fp_res_reg <= fp_res;
			end
		end

		always_comb begin
			state = state_reg;
			fp_res = fp_res_reg;
			if (state == idle) begin
				state = next;
			end else if (state == next) begin
				fp_res.data1 = dataread[287:224];
				fp_res.data2 = dataread[223:160];
				fp_res.data3 = dataread[159:96];
				fp_res.result = dataread[95:32];
				fp_res.flags = dataread[28:24];
				fp_res.fmt = dataread[21:20];
				fp_res.rm = dataread[18:16];
				fp_res.op = dataread[13:12];
				fp_res.opcode = dataread[9:0];
				if (finish == 1) begin
					state = stop;
				end else begin
					state = busy;
				end
			end else if (state == busy) begin
				if (ready_calc == 1) begin
					state = comp;
				end
			end else if (state == comp) begin
				state = next;
			end
		end

		assign fp_unit_i.fp_exe_i.data1 = fp_res.data1;
		assign fp_unit_i.fp_exe_i.data2 = fp_res.data2;
		assign fp_unit_i.fp_exe_i.data3 = fp_res.data3;
		assign fp_unit_i.fp_exe_i.fmt = fp_res.fmt;
		assign fp_unit_i.fp_exe_i.rm = fp_res.rm;
		assign fp_unit_i.fp_exe_i.op.fmadd = fp_res.opcode[0];
		assign fp_unit_i.fp_exe_i.op.fmsub = 0;
		assign fp_unit_i.fp_exe_i.op.fnmadd = 0;
		assign fp_unit_i.fp_exe_i.op.fnmsub = 0;
		assign fp_unit_i.fp_exe_i.op.fadd = fp_res.opcode[1];
		assign fp_unit_i.fp_exe_i.op.fsub = fp_res.opcode[2];
		assign fp_unit_i.fp_exe_i.op.fmul = fp_res.opcode[3];
		assign fp_unit_i.fp_exe_i.op.fdiv = fp_res.opcode[4];
		assign fp_unit_i.fp_exe_i.op.fsqrt = fp_res.opcode[5];
		assign fp_unit_i.fp_exe_i.op.fsgnj = 0;
		assign fp_unit_i.fp_exe_i.op.fcmp = fp_res.opcode[6];
		assign fp_unit_i.fp_exe_i.op.fmax = 0;
		assign fp_unit_i.fp_exe_i.op.fclass = 0;
		assign fp_unit_i.fp_exe_i.op.fmv_i2f = 0;
		assign fp_unit_i.fp_exe_i.op.fmv_f2i = 0;
		assign fp_unit_i.fp_exe_i.op.fcvt_f2f = fp_res.opcode[7];
		assign fp_unit_i.fp_exe_i.op.fcvt_i2f = fp_res.opcode[8];
		assign fp_unit_i.fp_exe_i.op.fcvt_f2i = fp_res.opcode[9];
		assign fp_unit_i.fp_exe_i.op.fcvt_op = fp_res.op;
		assign fp_unit_i.fp_exe_i.enable = enable;

		fp_unit fp_unit_comp
		(
			.reset ( reset ),
			.clock ( clock ),
			.fp_unit_i ( fp_unit_i ),
			.fp_unit_o ( fp_unit_o )
		);

		assign result_calc = fp_unit_o.fp_exe_o.result;
		assign flags_calc = fp_unit_o.fp_exe_o.flags;
		assign ready_calc = fp_unit_o.fp_exe_o.ready;

		always_comb begin
			if (ready_calc) begin
				if (fp_res.fmt == 0) begin
					if ((fp_res.opcode[9] == 0 && fp_res.opcode[6] == 0) && result_calc[31:0] == 32'h7FC00000) begin
						result_diff = {32'h0,1'h0,result_calc[30:22] ^ fp_res.result[30:22],22'h0};
					end else begin
						result_diff = result_calc ^ fp_res.result;
					end
				end else begin
					if ((fp_res.opcode[9] == 0 && fp_res.opcode[6] == 0) && result_calc[63:0] == 64'h7FF8000000000000) begin
						result_diff = {1'h0,result_calc[62:51] ^ fp_res.result[62:51],51'h0};
					end else begin
						result_diff = result_calc ^ fp_res.result;
					end
				end
				flags_diff = flags_calc ^ fp_res.flags;
			end else begin
				result_diff = 0;
				flags_diff = 0;
			end
		end

		always_ff @(posedge clock) begin
			if (ready_calc) begin
				if ((result_diff != 0) || (flags_diff != 0)) begin
					$write("%c[1;31m",8'h1B);
					$display("TEST FAILED");
					$display("A                 = 0x%H",fp_res.data1);
					$display("B                 = 0x%H",fp_res.data2);
					$display("C                 = 0x%H",fp_res.data3);
					$display("RESULT DIFFERENCE = 0x%H",result_diff);
					$display("RESULT REFERENCE  = 0x%H",fp_res.result);
					$display("RESULT CALCULATED = 0x%H",result_calc);
					$display("FLAGS DIFFERENCE  = 0x%H",flags_diff);
					$display("FLAGS REFERENCE   = 0x%H",fp_res.flags);
					$display("FLAGS CALCULATED  = 0x%H",flags_calc);
					$write("%c[0m",8'h1B);
					$display("simulation finished @%0t",$time);
					$finish;
				end else if (state == stop) begin
					$write("%c[1;32m",8'h1B);
					$display("TEST SUCCEEDED");
					$write("%c[0m",8'h1B);
					$display("simulation finished @%0t",$time);
					$finish;
				end
			end
		end

	endgenerate

endmodule
