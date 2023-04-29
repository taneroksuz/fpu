import fp_wire::*;

module test_float_p
(
  input  logic reset,
  input  logic clock
);

	timeunit 1ns;
	timeprecision 1ps;

	integer data_file;
	integer scan_file;

	logic [63:0] dataread [0:4];

	typedef struct packed{
		logic [63:0] data1;
		logic [63:0] data2;
		logic [63:0] data3;
		logic [63:0] result;
		logic [4:0] flags;
		logic [1:0] fmt;
		logic [2:0] rm;
		fp_operation_type op;
		logic [0:0] enable;
		logic [63:0] result_orig;
		logic [63:0] result_calc;
		logic [63:0] result_diff;
		logic [4:0] flags_orig;
		logic [4:0] flags_calc;
		logic [4:0] flags_diff;
		logic [0:0] ready_calc;
		logic [0:0] terminate;
		logic [0:0] load;
		integer i;
		integer j;
	} fp_result;

	fp_result init_fp_res = '{
		data1 : 0,
		data2 : 0,
		data3 : 0,
		result : 0,
		flags : 0,
		fmt : 0,
		rm : 0,
		op : init_fp_operation,
		enable : 0,
		result_orig : 0,
		result_calc : 0,
		result_diff : 0,
		flags_orig : 0,
		flags_calc : 0,
		flags_diff : 0,
		ready_calc : 0,
		terminate : 0,
		load : 0,
		i : 0,
		j : 0
	};

	fp_result v_initial,v_final;
	fp_result r_1,r_2,r_3;
	fp_result rin_1,rin_2,rin_3;

	fp_unit_in_type fp_unit_i;
	fp_unit_out_type fp_unit_o;

	string operation [0:7] = '{"f32_mulAdd","f32_add","f32_sub","f32_mul","f64_mulAdd","f64_add","f64_sub","f64_mul"};
	string mode [0:4] = '{"rne","rtz","rdn","rup","rmm"};
	logic [1:0] fmt [0:7] = '{0,0,0,0,1,1,1,1};
	logic [2:0] rm [0:4] = '{0,1,2,3,4};

	string filename;

	always_comb begin

		@(posedge clock);

		v_initial = init_fp_res;

		v_initial.load = r_1.load;
		v_initial.i = r_1.i;
		v_initial.j = r_1.j;

		if (v_initial.load == 0) begin
			filename = {operation[v_initial.i],"_",mode[v_initial.j],".hex"};
			data_file = $fopen(filename, "r");
			if (data_file == 0) begin
				$display({filename," is not available!"});
				$finish;
			end
			v_initial.load = 1;
		end

		if ($feof(data_file)) begin
			v_initial.enable = 1;
			v_initial.terminate = 1;
			dataread = '{default:0};
		end else begin
			v_initial.enable = 1;
			v_initial.terminate = 0;
			if (operation[v_initial.i] == "f32_mulAdd" || operation[v_initial.i] == "f64_mulAdd") begin
				scan_file = $fscanf(data_file,"%h %h %h %h %h\n", dataread[0], dataread[1], dataread[2], dataread[3], dataread[4]);
			end else begin
				scan_file = $fscanf(data_file,"%h %h %h %h\n", dataread[0], dataread[1], dataread[2], dataread[3]);
			end
		end

		if (v_initial.terminate == 1) begin
			$write("%c[1;34m",8'h1B);
			$display({operation[v_initial.i]," ",mode[v_initial.j]});
			$write("%c[0m",8'h1B);
			$write("%c[1;32m",8'h1B);
			$display("TEST SUCCEEDED");
			$write("%c[0m",8'h1B);
			$fclose(data_file);
			if (v_initial.j == 4 && v_initial.i == 7) begin
				$finish;
			end
			v_initial.i = v_initial.j == 4 ? v_initial.i + 1 : v_initial.i;
			v_initial.j = v_initial.j == 4 ? 0 : v_initial.j + 1;
			v_initial.load = 0;
		end

		if (operation[v_initial.i] == "f32_mulAdd" || operation[v_initial.i] == "f64_mulAdd") begin
			v_initial.data1 = dataread[0];
			v_initial.data2 = dataread[1];
			v_initial.data3 = dataread[2];
			v_initial.result = dataread[3];
			v_initial.flags = dataread[4][4:0];
		end else begin
			v_initial.data1 = dataread[0];
			v_initial.data2 = dataread[1];
			v_initial.data3 = 0;
			v_initial.result = dataread[2];
			v_initial.flags = dataread[3][4:0];
		end

		v_initial.fmt = fmt[v_initial.i];
		v_initial.rm = rm[v_initial.j];
		v_initial.op.fmadd = operation[v_initial.i] == "f32_mulAdd" || operation[v_initial.i] == "f64_mulAdd" ? 1 : 0;
		v_initial.op.fadd = operation[v_initial.i] == "f32_add" || operation[v_initial.i] == "f64_add" ? 1 : 0;
		v_initial.op.fsub = operation[v_initial.i] == "f32_sub" || operation[v_initial.i] == "f64_sub" ? 1 : 0;
		v_initial.op.fmul = operation[v_initial.i] == "f32_mul" || operation[v_initial.i] == "f64_mul" ? 1 : 0;
		v_initial.op.fdiv = 0;
		v_initial.op.fsqrt = 0;
		v_initial.op.fmv_i2f = 0;
		v_initial.op.fmv_f2i = 0;
		v_initial.op.fcmp = 0;
		v_initial.op.fcvt_f2f = 0;
		v_initial.op.fcvt_i2f = 0;
		v_initial.op.fcvt_f2i = 0;
		v_initial.op.fcvt_op = 0;

		if (reset == 0) begin
			v_initial.op = init_fp_operation;
			v_initial.enable = 0;
		end

		fp_unit_i.fp_exe_i.data1 = v_initial.data1;
		fp_unit_i.fp_exe_i.data2 = v_initial.data2;
		fp_unit_i.fp_exe_i.data3 = v_initial.data3;
		fp_unit_i.fp_exe_i.fmt = v_initial.fmt;
		fp_unit_i.fp_exe_i.rm = v_initial.rm;
		fp_unit_i.fp_exe_i.op = v_initial.op;
		fp_unit_i.fp_exe_i.enable = v_initial.enable;

		if (fp_unit_o.fp_exe_o.ready == 1) begin
			v_final = r_3;

			v_final.result_orig = v_final.result;
			v_final.flags_orig = v_final.flags;

			v_final.result_calc = fp_unit_o.fp_exe_o.result;
			v_final.flags_calc = fp_unit_o.fp_exe_o.flags;
			v_final.ready_calc = fp_unit_o.fp_exe_o.ready;
		end

		if (v_final.ready_calc == 1) begin
			if (v_final.fmt == 0) begin
				if ((v_final.op.fcvt_f2i == 0 && v_final.op.fcmp == 0) && v_final.result_calc[31:0] == 32'h7FC00000) begin
					v_final.result_diff = {32'h0,1'h0,v_final.result_orig[30:22] ^ v_final.result_calc[30:22],22'h0};
				end else begin
					v_final.result_diff = v_final.result_orig ^ v_final.result_orig;
				end
			end else begin
				if ((v_final.op.fcvt_f2i == 0 && v_final.op.fcmp == 0) && v_final.result_calc[63:0] == 64'h7FF800000000000) begin
					v_final.result_diff = {1'h0,v_final.result_orig[62:51] ^ v_final.result_calc[62:51],51'h0};
				end else begin
					v_final.result_diff = v_final.result_orig ^ v_final.result_orig;
				end
			end
			v_final.flags_diff = v_final.flags_orig ^ v_final.flags_calc;
		end else begin
			v_final.result_diff = 0;
			v_final.flags_diff = 0;
		end

		if (v_final.ready_calc == 1) begin
			if ((v_final.result_diff != 0) || (v_final.flags_diff != 0)) begin
				$write("%c[1;34m",8'h1B);
				$display({operation[v_final.i]," ",mode[v_final.j]});
				$write("%c[0m",8'h1B);
				$write("%c[1;31m",8'h1B);
				$display("TEST FAILED");
				$display("A                 = 0x%H",v_final.data1);
				$display("B                 = 0x%H",v_final.data2);
				$display("C                 = 0x%H",v_final.data3);
				$display("RESULT DIFFERENCE = 0x%H",v_final.result_diff);
				$display("RESULT REFERENCE  = 0x%H",v_final.result_orig);
				$display("RESULT CALCULATED = 0x%H",v_final.result_calc);
				$display("FLAGS DIFFERENCE  = 0x%H",v_final.flags_diff);
				$display("FLAGS REFERENCE   = 0x%H",v_final.flags_orig);
				$display("FLAGS CALCULATED  = 0x%H",v_final.flags_calc);
				$write("%c[0m",8'h1B);
				$finish;
			end
		end

		rin_1 = v_initial;
		rin_2 = r_1;
		rin_3 = r_2;

	end

	always_ff @(posedge clock) begin
		if (reset == 0) begin
			r_1 <= init_fp_res;
			r_2 <= init_fp_res;
			r_3 <= init_fp_res;
		end else begin
			r_1 <= rin_1;
			r_2 <= rin_2;
			r_3 <= rin_3;
		end
	end

	fp_unit fp_unit_comp
	(
		.reset ( reset ),
		.clock ( clock ),
		.fp_unit_i ( fp_unit_i ),
		.fp_unit_o ( fp_unit_o )
	);

endmodule
