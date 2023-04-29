default: all

export GHDL ?= /opt/ghdl/bin/ghdl
export VERILATOR ?= /opt/verilator/bin/verilator
export SYSTEMC ?= /opt/systemc
export TESTFLOAT ?= /opt/testfloat/testfloat_gen
export PYTHON ?= /usr/bin/python3
export BASEDIR ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
export LANGUAGE ?= verilog# verilog, vhdl
export DESIGN ?= fpu# fpu, lzc

generate:
	tests/generate.sh

simulate:
	sim/run.sh

all: generate simulate
