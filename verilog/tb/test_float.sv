import fp_wire::*;

module test_float
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

	logic [63:0] data1;
	logic [63:0] data2;
	logic [63:0] data3;
	logic [63:0] result;
	logic [4:0] flags;
	logic [1:0] fmt;
	logic [2:0] rm;
	logic [1:0] op;
	logic [9:0] opcode;
	logic enable;
	logic stop;

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
				data1 <= 0;
				data2 <= 0;
				data3 <= 0;
				result <= 0;
				flags <= 0;
				fmt <= 0;
				rm <= 0;
				op <= 0;
				opcode <= 0;
				enable <= 0;
				stop <= 0;
			end else begin
				if ($feof(data_file)) begin
					stop <= 1;
					dataread <= 0;
				end else begin
					scan_file <= $fscanf(data_file,"%h\n", dataread);
				end
				data1 <= dataread[287:224];
				data2 <= dataread[223:160];
				data3 <= dataread[159:96];
				result <= dataread[95:32];
				flags <= dataread[28:24];
				fmt <= dataread[21:20];
				rm <= dataread[18:16];
				op <= dataread[13:12];
				opcode <= dataread[9:0];
				enable <= 1;
			end
		end

		assign fp_unit_i.fp_exe_i.data1 = data1;
		assign fp_unit_i.fp_exe_i.data2 = data2;
		assign fp_unit_i.fp_exe_i.data3 = data3;
		assign fp_unit_i.fp_exe_i.fmt = fmt;
		assign fp_unit_i.fp_exe_i.rm = rm;
		assign fp_unit_i.fp_exe_i.op.fmadd = opcode[0];
		assign fp_unit_i.fp_exe_i.op.fmsub = 0;
		assign fp_unit_i.fp_exe_i.op.fnmadd = 0;
		assign fp_unit_i.fp_exe_i.op.fnmsub = 0;
		assign fp_unit_i.fp_exe_i.op.fadd = opcode[1];
		assign fp_unit_i.fp_exe_i.op.fsub = opcode[2];
		assign fp_unit_i.fp_exe_i.op.fmul = opcode[3];
		assign fp_unit_i.fp_exe_i.op.fdiv = opcode[4];
		assign fp_unit_i.fp_exe_i.op.fsqrt = opcode[5];
		assign fp_unit_i.fp_exe_i.op.fsgnj = 0;
		assign fp_unit_i.fp_exe_i.op.fcmp = opcode[6];
		assign fp_unit_i.fp_exe_i.op.fmax = 0;
		assign fp_unit_i.fp_exe_i.op.fclass = 0;
		assign fp_unit_i.fp_exe_i.op.fmv_i2f = 0;
		assign fp_unit_i.fp_exe_i.op.fmv_f2i = 0;
		assign fp_unit_i.fp_exe_i.op.fcvt_f2f = opcode[7];
		assign fp_unit_i.fp_exe_i.op.fcvt_i2f = opcode[8];
		assign fp_unit_i.fp_exe_i.op.fcvt_f2i = opcode[9];
		assign fp_unit_i.fp_exe_i.op.fcvt_op = op;
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
					if (fmt == 0) begin
						if ((opcode[9] == 0 && opcode[6] == 0) && result_calc[31:0] == 32'h7FC00000) begin
							result_diff = {32'h0,1'h0,result_calc[30:22] ^ result[30:22],22'h0};
						end else begin
							result_diff = result_calc ^ result;
						end
					end else begin
						if ((opcode[9] == 0 && opcode[6] == 0) && result_calc[63:0] == 64'h7FF8000000000000) begin
							result_diff = {1'h0,result_calc[62:51] ^ result[62:51],51'h0};
						end else begin
							result_diff = result_calc ^ result;
						end
					end
					flags_diff = flags_calc ^ flags;
					if ((result_diff != 0) || (flags_diff != 0)) begin
						$display("TEST FAILED");
						$display("A                 = 0x%H",data1);
						$display("B                 = 0x%H",data2);
						$display("C                 = 0x%H",data3);
						$display("RESULT DIFFERENCE = 0x%H",result_diff);
						$display("RESULT REFERENCE  = 0x%H",result);
						$display("RESULT CALCULATED = 0x%H",result_calc);
						$display("FLAGS DIFFERENCE  = 0x%H",flags_diff);
						$display("FLAGS REFERENCE   = 0x%H",flags);
						$display("FLAGS CALCULATED  = 0x%H",flags_calc);
						$finish;
					end
					if (stop) begin
						$display("TEST SUCCEEDED");
						$finish;
					end
				end
			end

		end

	endgenerate

endmodule
