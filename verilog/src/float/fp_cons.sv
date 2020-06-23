module fp_cons();
	timeunit 1ns;
	timeprecision 1ps;

	parameter funct_fadd = 5'b00000;
	parameter funct_fsub = 5'b00001;
	parameter funct_fmul = 5'b00010;
	parameter funct_fdiv = 5'b00011;
	parameter funct_fsqrt = 5'b01011;
	parameter funct_fsgnj = 5'b00100;
	parameter funct_fminmax = 5'b00101;
	parameter funct_fcomp = 5'b10100;
	parameter funct_fclass = 5'b11100;
	parameter funct_fmv_f2i = 5'b11100;
	parameter funct_fmv_i2f = 5'b11110;
	parameter funct_fconv_f2i = 5'b11000;
	parameter funct_fconv_i2f = 5'b11010;
	parameter funct_fconv_f2f = 5'b01000;

	parameter funct_fmadd = 7'b1000011;
	parameter funct_fmsub = 7'b1000111;
	parameter funct_fnmsub = 7'b1001011;
	parameter funct_fnmadd = 7'b1001111;

	parameter opcode_fp = 7'b1010011;
	parameter opcode_fload = 7'b0000111;
	parameter opcode_fstore = 7'b0100111;
	parameter opcode_fmadd = 7'b1000011;
	parameter opcode_fmsub = 7'b1000111;
	parameter opcode_fnmsub = 7'b1001011;
	parameter opcode_fnmadd = 7'b1001111;

	parameter csr_fflags = 12'h001;
	parameter csr_frm = 12'h002;
	parameter csr_fcsr = 12'h003;

endmodule
