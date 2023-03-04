#!/bin/bash
set -e

export SYSTEMC_LIBDIR=$SYSTEMC/lib-linux64/
export SYSTEMC_INCLUDE=$SYSTEMC/include/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SYSTEMC/lib-linux64/

if [ -d "${BASEDIR}/sim/work" ]; then
	rm -rf ${BASEDIR}/sim/work
fi

mkdir ${BASEDIR}/sim/work

cd ${BASEDIR}/sim/work

start=`date +%s`
${VERILATOR} -sc -I${BASEDIR}/verilog/src/lzc ${BASEDIR}/verilog/src/lzc/lzc_4.sv
${VERILATOR} -sc -I${BASEDIR}/verilog/src/lzc ${BASEDIR}/verilog/src/lzc/lzc_8.sv
${VERILATOR} -sc -I${BASEDIR}/verilog/src/lzc ${BASEDIR}/verilog/src/lzc/lzc_16.sv
${VERILATOR} -sc -I${BASEDIR}/verilog/src/lzc ${BASEDIR}/verilog/src/lzc/lzc_32.sv
${VERILATOR} -sc -I${BASEDIR}/verilog/src/lzc ${BASEDIR}/verilog/src/lzc/lzc_64.sv
${VERILATOR} -sc -I${BASEDIR}/verilog/src/lzc ${BASEDIR}/verilog/src/lzc/lzc_128.sv
${VERILATOR} -sc -I${BASEDIR}/verilog/src/lzc ${BASEDIR}/verilog/src/lzc/lzc_256.sv

${VERILATOR} -sc -I${BASEDIR}/verilog/src/lzc ${BASEDIR}/verilog/tb/test_lzc.sv --exe ${BASEDIR}/verilog/tb/test_lzc.cpp

make -s -j -C obj_dir/ -f Vtest_lzc.mk Vtest_lzc

obj_dir/Vtest_lzc 2> /dev/null

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
