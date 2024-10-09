default: all

export GHDL ?= ghdl
export VERILATOR ?= verilator
export TESTFLOAT ?= testfloat_gen
export VERIBLE ?= verible
export PYTHON ?= python3
export BASEDIR ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

export VERILOG ?= 0# 1 -> enable, 0 -> disable
export VHDL ?= 0# 1 -> enable, 0 -> disable

tool:
	tools/install-ghdl.sh
	tools/install-testfloat.sh
	tools/install-verible.sh
	tools/install-verilator.sh

generate:
	tests/generate.sh

simulate:
	sim/run.sh

parse:
	check/run.sh

all: generate simulate
