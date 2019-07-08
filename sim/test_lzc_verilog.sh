#!/bin/bash

if [ -d "$1/sim/work" ]; then
	rm -rf $1/sim/work
fi

mkdir $1/sim/work

cd $1/sim/work

verilator -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_4.sv
verilator -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_8.sv
verilator -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_16.sv
verilator -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_32.sv
verilator -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_64.sv
verilator -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_128.sv
verilator -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_256.sv

verilator -cc --trace -I../../verilog/src/lzc ../../verilog/tb/test_lzc.sv --exe ../../verilog/tb/test_lzc.cpp

make -s -j -C obj_dir/ -f Vtest_lzc.mk Vtest_lzc

obj_dir/Vtest_lzc
