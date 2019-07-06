#!/bin/bash

if [ -z "$1" ]
then
	echo "1. option: verilator, xsim"
	exit
fi

if [ -d "work" ]; then
	rm -rf work
fi

mkdir work

cd work

if [ "$1" = 'verilator' ]
then
	verilator -cc -I../verilog/src/lzc ../verilog/src/lzc/lzc_4.sv
	verilator -cc -I../verilog/src/lzc ../verilog/src/lzc/lzc_8.sv
	verilator -cc -I../verilog/src/lzc ../verilog/src/lzc/lzc_16.sv
	verilator -cc -I../verilog/src/lzc ../verilog/src/lzc/lzc_32.sv
	verilator -cc -I../verilog/src/lzc ../verilog/src/lzc/lzc_64.sv
	verilator -cc -I../verilog/src/lzc ../verilog/src/lzc/lzc_128.sv
	verilator -cc -I../verilog/src/lzc ../verilog/src/lzc/lzc_256.sv

	verilator -cc --trace -I../verilog/src/lzc ../verilog/tb/test_lzc.sv --exe ../verilog/tb/test_lzc.cpp

	make -j -C obj_dir/ -f Vtest_lzc.mk Vtest_lzc

	obj_dir/Vtest_lzc
fi
if [ "$1" = 'xsim' ]
then
	xvlog ../verilog/src/lzc/lzc_wire.sv
	xvlog ../verilog/src/lzc/lzc_4.sv
	xvlog ../verilog/src/lzc/lzc_8.sv
	xvlog ../verilog/src/lzc/lzc_16.sv
	xvlog ../verilog/src/lzc/lzc_32.sv
	xvlog ../verilog/src/lzc/lzc_64.sv
	xvlog ../verilog/src/lzc/lzc_128.sv
	xvlog ../verilog/src/lzc/lzc_256.sv

	xvlog ../verilog/tb/test_lzc.sv

	xelab -debug typical test_lzc -s test_lzc_sim
	xsim test_lzc_sim -ieeewarnings -R
fi
