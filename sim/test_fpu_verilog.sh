#!/bin/bash

verilator=$1
test=$2

if [ -d "sim/work" ]; then
	rm -rf sim/work
fi

mkdir sim/work

if [ ! -z "${test}" ]
then
	if [ ! "${test}" = 'all' ]
	then
		cp tests/test_cases/${test}.dat sim/work/fpu.dat
	fi
fi

cd sim/work

start=`date +%s`
if [ "${test}" = 'all' ]
then
	{
		${verilator} --cc -Wno-UNOPTFLAT -Wno-WIDTH -f ../files_fpu_verilog.f --top-module test_float_s --exe ../../verilog/tb/test_float_s.cpp
		make -s -j -C obj_dir/ -f Vtest_float_s.mk Vtest_float_s
		${verilator} --cc -Wno-UNOPTFLAT -Wno-WIDTH -f ../files_fpu_verilog.f --top-module test_float_p --exe ../../verilog/tb/test_float_p.cpp
		make -s -j -C obj_dir/ -f Vtest_float_p.mk Vtest_float_p
		${verilator} --cc -Wno-UNOPTFLAT -Wno-WIDTH -f ../files_fpu_verilog.f --top-module test_float --exe ../../verilog/tb/test_float.cpp
		make -s -j -C obj_dir/ -f Vtest_float.mk Vtest_float
	}
	for filename in ../../tests/test_cases/*.dat; do
		cp $filename fpu.dat
		echo "${filename%.dat}"
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
	echo "${test}"
	if [ `echo ${test} | grep -c "div\|sqrt" ` -gt 0 ]
	then
		${verilator} --cc -Wno-UNOPTFLAT -Wno-WIDTH --trace -trace-max-array 128 --trace-structs -f ../files_fpu_verilog.f --top-module test_float_s --exe ../../verilog/tb/test_float_s_trace.cpp
		make -s -j -C obj_dir/ -f Vtest_float_s.mk Vtest_float_s
		obj_dir/Vtest_float_s
	elif [ `echo ${test} | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
	then
		${verilator} --cc -Wno-UNOPTFLAT -Wno-WIDTH --trace -trace-max-array 128 --trace-structs -f ../files_fpu_verilog.f --top-module test_float_p --exe ../../verilog/tb/test_float_p_trace.cpp
		make -s -j -C obj_dir/ -f Vtest_float_p.mk Vtest_float_p
		obj_dir/Vtest_float_p
	else
		${verilator} --cc -Wno-UNOPTFLAT -Wno-WIDTH --trace -trace-max-array 128 --trace-structs -f ../files_fpu_verilog.f --top-module test_float --exe ../../verilog/tb/test_float_trace.cpp
		make -s -j -C obj_dir/ -f Vtest_float.mk Vtest_float
		obj_dir/Vtest_float
	fi
fi
end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
