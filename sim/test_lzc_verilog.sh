#!/bin/bash

verilator=${1}

if [ -d "sim/work" ]; then
	rm -rf sim/work
fi

mkdir sim/work

cd sim/work

${verilator} -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_4.sv
${verilator} -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_8.sv
${verilator} -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_16.sv
${verilator} -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_32.sv
${verilator} -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_64.sv
${verilator} -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_128.sv
${verilator} -cc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_256.sv

${verilator} -cc --trace -I../../verilog/src/lzc ../../verilog/tb/test_lzc.sv --exe ../../verilog/tb/test_lzc.cpp

make -s -j -C obj_dir/ -f Vtest_lzc.mk Vtest_lzc

obj_dir/Vtest_lzc
