default: none

MDIR := $(abspath $(lastword $(MAKEFILE_LIST)))
CDIR := $(notdir $(patsubst %/,%,$(dir $(MDIR))))

export ${CDIR}

GHDL ?= /opt/ghdl/bin/ghdl
VERILATOR ?= /opt/verilator/bin/verilator
TESTFLOAT ?= /opt/testfloat/testfloat_gen
PYTHON2 ?= python2

TEST ?= all

generate:
	${CDIR}/tests/generate_test_cases.sh ${CDIR}/tests ${TESTFLOAT} ${PYTHON}

fpu_verilog:
	${CDIR}/sim/test_fpu_verilog.sh ${CDIR} ${TEST}

lzc_verilog:
	${CDIR}/sim/test_lzc_verilog.sh ${CDIR}

fpu_vhdl:
	${CDIR}/sim/test_fpu_vhdl.sh ${CDIR} ${TEST}

lzc_vhdl:
	${CDIR}/sim/test_lzc_vhdl.sh ${CDIR}

all:
	generate lzc_vhdl lzc_verilog fpu_vhdl fpu_verilog
