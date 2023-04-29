#!/bin/bash
set -e

if [ -d "${BASEDIR}/sim/work" ]; then
	rm -rf ${BASEDIR}/sim/work
fi

mkdir ${BASEDIR}/sim/work

cd ${BASEDIR}/sim/work

cp ${BASEDIR}/tests/test_cases/*.hex ${BASEDIR}/sim/work

start=`date +%s`

${VERILATOR} --cc --timing -Wno-UNOPTFLAT -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float_s --exe ${BASEDIR}/verilog/tb/test_float_s.cpp 2>&1 > /dev/null
make -s -j -C obj_dir/ -f Vtest_float_s.mk Vtest_float_s
${VERILATOR} --cc --timing -Wno-UNOPTFLAT -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float_p --exe ${BASEDIR}/verilog/tb/test_float_p.cpp 2>&1 > /dev/null
make -s -j -C obj_dir/ -f Vtest_float_p.mk Vtest_float_p
${VERILATOR} --cc --timing -Wno-UNOPTFLAT -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float --exe ${BASEDIR}/verilog/tb/test_float.cpp 2>&1 > /dev/null
make -s -j -C obj_dir/ -f Vtest_float.mk Vtest_float
obj_dir/Vtest_float_s
obj_dir/Vtest_float_p
obj_dir/Vtest_float

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
