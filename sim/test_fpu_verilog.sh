#!/bin/bash
set -e

export SYSTEMC_LIBDIR=$SYSTEMC/lib-linux64/
export SYSTEMC_INCLUDE=$SYSTEMC/include/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SYSTEMC/lib-linux64/

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
	{
		${VERILATOR} --sc -Wno-UNOPTFLAT -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float_s --exe ${BASEDIR}/verilog/tb/test_float_s.cpp
		make -s -j -C obj_dir/ -f Vtest_float_s.mk Vtest_float_s
		${VERILATOR} --sc -Wno-UNOPTFLAT -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float_p --exe ${BASEDIR}/verilog/tb/test_float_p.cpp
		make -s -j -C obj_dir/ -f Vtest_float_p.mk Vtest_float_p
		${VERILATOR} --sc -Wno-UNOPTFLAT -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float --exe ${BASEDIR}/verilog/tb/test_float.cpp
		make -s -j -C obj_dir/ -f Vtest_float.mk Vtest_float
	}
	for filename in ${BASEDIR}/tests/test_cases/*.dat; do
		cp $filename fpu.dat
		echo "${filename%.dat}"
		if [ `echo $filename | grep -c "div\|sqrt" ` -gt 0 ]
		then
			obj_dir/Vtest_float_s 2> /dev/null
		elif [ `echo $filename | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
		then
			obj_dir/Vtest_float_p 2> /dev/null
		else
			obj_dir/Vtest_float 2> /dev/null
		fi
	done
else
	echo "${TEST}"
    filename=${3##*/}
    filename=${filename%.dat}
	if [ `echo ${TEST} | grep -c "div\|sqrt" ` -gt 0 ]
	then
		${VERILATOR} --sc -Wno-UNOPTFLAT --trace -trace-max-array 128 --trace-structs -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float_s --exe ${BASEDIR}/verilog/tb/test_float_s.cpp
		make -s -j -C obj_dir/ -f Vtest_float_s.mk Vtest_float_s
		obj_dir/Vtest_float_s ${filename} 2> /dev/null
	elif [ `echo ${TEST} | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
	then
		${VERILATOR} --sc -Wno-UNOPTFLAT --trace -trace-max-array 128 --trace-structs -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float_p --exe ${BASEDIR}/verilog/tb/test_float_p.cpp
		make -s -j -C obj_dir/ -f Vtest_float_p.mk Vtest_float_p
		obj_dir/Vtest_float_p ${filename} 2> /dev/null
	else
		${VERILATOR} --sc -Wno-UNOPTFLAT --trace -trace-max-array 128 --trace-structs -f ${BASEDIR}/sim/files_fpu_verilog.f --top-module test_float --exe ${BASEDIR}/verilog/tb/test_float.cpp
		make -s -j -C obj_dir/ -f Vtest_float.mk Vtest_float
		obj_dir/Vtest_float ${filename} 2> /dev/null
	fi
fi
end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
