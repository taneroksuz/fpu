#!/bin/bash

VERILATOR=${1}
SYSTEMC=${2}

export SYSTEMC_LIBDIR=$SYSTEMC/lib-linux64/
export SYSTEMC_INCLUDE=$SYSTEMC/include/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SYSTEMC/lib-linux64/

if [ -d "sim/work" ]; then
	rm -rf sim/work
fi

mkdir sim/work

cd sim/work

start=`date +%s`
${VERILATOR} -sc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_4.sv
${VERILATOR} -sc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_8.sv
${VERILATOR} -sc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_16.sv
${VERILATOR} -sc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_32.sv
${VERILATOR} -sc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_64.sv
${VERILATOR} -sc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_128.sv
${VERILATOR} -sc -I../../verilog/src/lzc ../../verilog/src/lzc/lzc_256.sv

${VERILATOR} -sc -I../../verilog/src/lzc ../../verilog/tb/test_lzc.sv --exe ../../verilog/tb/test_lzc.cpp

make -s -j -C obj_dir/ -f Vtest_lzc.mk Vtest_lzc

obj_dir/Vtest_lzc 2> /dev/null

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
