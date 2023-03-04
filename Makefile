default: all

export GHDL ?= /opt/ghdl/bin/ghdl
export VERILATOR ?= /opt/verilator/bin/verilator
export SYSTEMC ?= /opt/systemc
export TESTFLOAT ?= /opt/testfloat/testfloat_gen
export PYTHON ?= /usr/bin/python3
export BASEDIR ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
export LANGUAGE ?= verilog# verilog, vhdl
export DESIGN ?= fpu# fpu, lzc
export TEST ?= all# f32_mulAdd, f32_add, f32_sub, f32_mul, f32_div, f32_sqrt,
                  # f64_mulAdd, f64_add, f64_sub, f64_mul, f64_div, f64_sqrt,
                  # f32_le, f32_lt, f32_eq, f64_le, f64_lt, f64_eq, f32_to_f64,
                  # f64_to_f32, i32_to_f32, ui32_to_f32, i64_to_f32, ui64_to_f32,
                  # i32_to_f64, ui32_to_f64, i64_to_f64, ui64_to_f64, f32_to_i32,
                  # f32_to_ui32, f32_to_i64, f32_to_ui64, f64_to_i32, f64_to_ui32,
                  # f64_to_i64, f64_to_ui64
export ROUND ?=rne# rne, rtz, rdn, rup, rmm

generate:
	tests/generate_test_cases.sh

simulation:
	@if [ ${LANGUAGE} = "verilog" ] && [ ${DESIGN} = "fpu" ]; \
	then \
		sim/test_fpu_verilog.sh; \
	elif [ ${LANGUAGE} = "verilog" ] && [ ${DESIGN} = "lzc" ]; \
	then \
		sim/test_lzc_verilog.sh; \
	elif [ ${LANGUAGE} = "vhdl" ] && [ ${DESIGN} = "fpu" ]; \
	then \
		sim/test_fpu_vhdl.sh; \
	elif [ ${LANGUAGE} = "vhdl" ] && [ ${DESIGN} = "lzc" ]; \
	then \
		sim/test_lzc_vhdl.sh; \
	fi

all: generate simulation
