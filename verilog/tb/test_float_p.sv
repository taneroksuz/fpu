import fp_wire::*;

module test_float_p
(
	input reset,
	input clock
);
	timeunit 1ns;
	timeprecision 1ps;

	integer data_file;
	integer scan_file;

	logic [287:0] dataread;

	logic [63:0] result_calc;
	logic [4:0] flags_calc;
	logic ready_calc;
	logic enable;

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

	fp_result fp_res_1;
	fp_result fp_res_2;
	fp_result fp_res_3;
	fp_result fp_res_4;
	fp_result fp_res_5;

	fp_unit_in_type fp_unit_i;
	fp_unit_out_type fp_unit_o;

	logic [63:0] result_diff;
	logic [4:0] flags_diff;

	initial begin
		data_file = $fopen("fpu.dat", "r");
		if (data_file == 0) begin
			$display("fpu.dat is not available!");
			$finish;
		end
	end

	generate

		always_ff @(posedge clock) begin
			if (!reset) begin
				fp_res_1 <= init_fp_res;
				fp_res_2 <= init_fp_res;
				fp_res_3 <= init_fp_res;
				fp_res_4 <= init_fp_res;
				fp_res_5 <= init_fp_res;
				enable <= 0;
			end else begin
				if ($feof(data_file)) begin
					$display("TEST SUCCEEDED");
					$finish;
				end
				scan_file <= $fscanf(data_file,"%h\n", dataread);
				fp_res_1.data1 <= dataread[287:224];
				fp_res_1.data2 <= dataread[223:160];
				fp_res_1.data3 <= dataread[159:96];
				fp_res_1.result <= dataread[95:32];
				fp_res_1.flags <= dataread[28:24];
				fp_res_1.fmt <= dataread[21:20];
				fp_res_1.rm <= dataread[18:16];
				fp_res_1.op <= dataread[13:12];
				fp_res_1.opcode <= dataread[9:0];
				fp_res_2 <= fp_res_1;
				fp_res_3 <= fp_res_2;
				fp_res_4 <= fp_res_3;
				fp_res_5 <= fp_res_4;
				enable <= 1;
			end
		end

		assign fp_unit_i.fp_exe_i.data1 = fp_res_1.data1;
		assign fp_unit_i.fp_exe_i.data2 = fp_res_1.data2;
		assign fp_unit_i.fp_exe_i.data3 = fp_res_1.data3;
		assign fp_unit_i.fp_exe_i.fmt = fp_res_1.fmt;
		assign fp_unit_i.fp_exe_i.rm = fp_res_1.rm;
		assign fp_unit_i.fp_exe_i.op.fmadd = fp_res_1.opcode[0];
		assign fp_unit_i.fp_exe_i.op.fmsub = 0;
		assign fp_unit_i.fp_exe_i.op.fnmadd = 0;
		assign fp_unit_i.fp_exe_i.op.fnmsub = 0;
		assign fp_unit_i.fp_exe_i.op.fadd = fp_res_1.opcode[1];
		assign fp_unit_i.fp_exe_i.op.fsub = fp_res_1.opcode[2];
		assign fp_unit_i.fp_exe_i.op.fmul = fp_res_1.opcode[3];
		assign fp_unit_i.fp_exe_i.op.fdiv = fp_res_1.opcode[4];
		assign fp_unit_i.fp_exe_i.op.fsqrt = fp_res_1.opcode[5];
		assign fp_unit_i.fp_exe_i.op.fsgnj = 0;
		assign fp_unit_i.fp_exe_i.op.fcmp = fp_res_1.opcode[6];
		assign fp_unit_i.fp_exe_i.op.fmax = 0;
		assign fp_unit_i.fp_exe_i.op.fclass = 0;
		assign fp_unit_i.fp_exe_i.op.fmv_i2f = 0;
		assign fp_unit_i.fp_exe_i.op.fmv_f2i = 0;
		assign fp_unit_i.fp_exe_i.op.fcvt_f2f = fp_res_1.opcode[7];
		assign fp_unit_i.fp_exe_i.op.fcvt_i2f = fp_res_1.opcode[8];
		assign fp_unit_i.fp_exe_i.op.fcvt_f2i = fp_res_1.opcode[9];
		assign fp_unit_i.fp_exe_i.op.fcvt_op = fp_res_1.op;
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

		always_ff @(posedge clock) begin

			if (~reset) begin

			end else begin
				if (ready_calc) begin
					if (fp_res_5.fmt == 0) begin
						if (fp_res_5.opcode[9] == 0 & result_calc[31:0] == 32'h7FC00000) begin
							result_diff = {32'h0,1'h0,result_calc[30:22] ^ fp_res_5.result[30:22],22'h0};
						end else begin
							result_diff = result_calc ^ fp_res_5.result;
						end
					end else begin
						if (fp_res_5.opcode[9] == 0 & result_calc[63:0] == 64'h7FF8000000000000) begin
							result_diff = {1'h0,result_calc[62:51] ^ fp_res_5.result[62:51],51'h0};
						end else begin
							result_diff = result_calc ^ fp_res_5.result;
						end
					end
					flags_diff = flags_calc ^ fp_res_5.flags;
					if ((result_diff != 0) || (flags_diff != 0)) begin
						$display("TEST FAILED");
						$display("CLOCKS: %t",$time);
						$display("data1: 0x%h \n",fp_res_5.data1);
						$display("data2: 0x%h \n",fp_res_5.data2);
						$display("data3: 0x%h \n",fp_res_5.data3);
						$display("rm: %b \n",fp_res_5.rm);
						$display("opcode: %b \n",fp_res_5.opcode);
						$display("result: expected -> 0x%h calculated -> 0x%h difference -> 0x%h \n",fp_res_5.result,result_calc,result_diff);
						$display("flags: expected -> %b calculated -> %b difference -> %b \n",fp_res_5.flags,flags_calc,flags_diff);
						$display("wrong result");
						$finish;
					end
				end
			end

		end

	endgenerate

endmodule
