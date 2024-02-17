default: all

export GHDL ?= ghdl
export VERILATOR ?= verilator
export TESTFLOAT ?= testfloat_gen
export PYTHON ?= python3
export BASEDIR ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

export VERILOG ?= 0# 1 -> enable, 0 -> disable
export VHDL ?= 0# 1 -> enable, 0 -> disable

generate:
	tests/generate.sh

simulate:
	sim/run.sh

all: generate simulate
