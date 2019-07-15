default: none

GHDL ?= /opt/ghdl/bin/ghdl
VERILATOR ?= /opt/verilator/bin/verilator
TESTFLOAT ?= /opt/testfloat/testfloat_gen
PYTHON2 ?= python2

TEST ?= all

generate:
	tests/generate_test_cases.sh tests ${TESTFLOAT} ${PYTHON}

fpu_verilog:
	sim/test_fpu_verilog.sh ${TEST}

lzc_verilog:
	sim/test_lzc_verilog.sh

fpu_vhdl:
	sim/test_fpu_vhdl.sh ${TEST}

lzc_vhdl:
	sim/test_lzc_vhdl.sh

all:
	generate lzc_vhdl lzc_verilog fpu_vhdl fpu_verilog
