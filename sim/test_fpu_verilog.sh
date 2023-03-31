#!/bin/bash
set -e

if [ -d "${BASEDIR}/sim/work" ]; then
	rm -rf ${BASEDIR}/sim/work
fi

mkdir ${BASEDIR}/sim/work

if [ ! -z "${TEST}" ]
then
	if [ ! "${TEST}" = 'all' ]
	then
		cp ${BASEDIR}/tests/test_cases/${TEST}.dat ${BASEDIR}/sim/work/fpu.dat
	fi
fi

cd ${BASEDIR}/sim/work

start=`date +%s`
if [ "${TEST}" = 'all' ]
then
	${VERILATOR} --cc -Wno-UNOPTFLAT -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float_s --exe ${BASEDIR}/verilog/tb/test_float_s.cpp 2>&1 > /dev/null
	make -s -j -C obj_dir/ -f Vtest_float_s.mk Vtest_float_s
	${VERILATOR} --cc -Wno-UNOPTFLAT -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float_p --exe ${BASEDIR}/verilog/tb/test_float_p.cpp 2>&1 > /dev/null
	make -s -j -C obj_dir/ -f Vtest_float_p.mk Vtest_float_p
	${VERILATOR} --cc -Wno-UNOPTFLAT -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float --exe ${BASEDIR}/verilog/tb/test_float.cpp 2>&1 > /dev/null
	make -s -j -C obj_dir/ -f Vtest_float.mk Vtest_float
	for filename in ${BASEDIR}/tests/test_cases/*.dat; do
		cp $filename fpu.dat
		filename=$(basename $filename .dat) 
		echo $filename
		if [ `echo $filename | grep -c "div\|sqrt" ` -gt 0 ]
		then
			obj_dir/Vtest_float_s
		elif [ `echo $filename | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
		then
			obj_dir/Vtest_float_p
		else
			obj_dir/Vtest_float
		fi
	done
else
	echo "${TEST}"
	filename=${3##*/}
	filename=${filename%.dat}
	${VERILATOR} --cc -Wno-UNOPTFLAT --trace -trace-max-array 128 --trace-structs -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float_s --exe ${BASEDIR}/verilog/tb/test_float_s.cpp 2>&1 > /dev/null
	make -s -j -C obj_dir/ -f Vtest_float_s.mk Vtest_float_s
	${VERILATOR} --cc -Wno-UNOPTFLAT --trace -trace-max-array 128 --trace-structs -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float_p --exe ${BASEDIR}/verilog/tb/test_float_p.cpp 2>&1 > /dev/null
	make -s -j -C obj_dir/ -f Vtest_float_p.mk Vtest_float_p
	${VERILATOR} --cc -Wno-UNOPTFLAT --trace -trace-max-array 128 --trace-structs -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float --exe ${BASEDIR}/verilog/tb/test_float.cpp 2>&1 > /dev/null
	make -s -j -C obj_dir/ -f Vtest_float.mk Vtest_float
	if [ `echo ${TEST} | grep -c "div\|sqrt" ` -gt 0 ]
	then
		obj_dir/Vtest_float_s
	elif [ `echo ${TEST} | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
	then
		obj_dir/Vtest_float_p
	else
		obj_dir/Vtest_float
	fi
fi
end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
