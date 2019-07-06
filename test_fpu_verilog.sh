#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]
then
	echo "1. option: verilator, xsim"
	echo "2. option: floating point operation <e.g. f32_mulAdd>"
	exit
fi

if [ -d "work" ]; then
	rm -rf work
fi

mkdir work

if [ ! -z "$2" ]
then
	if [ ! "$2" = 'all' ]
	then
		cp $2 work/fpu.dat
	fi
fi

cd work

if [ "$1" = 'verilator' ]
then
	start=`date +%s`
	if [ "$2" = 'all' ]
	then
		{
			verilator --cc -f ../files_fpu_verilog.f --top-module test_float_s --exe ../verilog/tb/test_float_s.cpp
			make -j -C obj_dir/ -f Vtest_float_s.mk Vtest_float_s
			verilator --cc -f ../files_fpu_verilog.f --top-module test_float_p --exe ../verilog/tb/test_float_p.cpp
			make -j -C obj_dir/ -f Vtest_float_p.mk Vtest_float_p
			verilator --cc -f ../files_fpu_verilog.f --top-module test_float --exe ../verilog/tb/test_float.cpp
			make -j -C obj_dir/ -f Vtest_float.mk Vtest_float
		}
		for filename in ../test_cases/*.dat; do
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
		echo "$2"
		if [ `echo $2 | grep -c "div\|sqrt" ` -gt 0 ]
		then
			verilator --cc --trace -trace-max-array 128 --trace-structs -f ../files_fpu_verilog.f --top-module test_float_s --exe ../verilog/tb/test_float_s_trace.cpp
			make -j -C obj_dir/ -f Vtest_float_s.mk Vtest_float_s
			obj_dir/Vtest_float_s
		elif [ `echo $2 | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
		then
			verilator --cc --trace -trace-max-array 128 --trace-structs -f ../files_fpu_verilog.f --top-module test_float_p --exe ../verilog/tb/test_float_p_trace.cpp
			make -j -C obj_dir/ -f Vtest_float_p.mk Vtest_float_p
			obj_dir/Vtest_float_p
		else
			verilator --cc --trace -trace-max-array 128 --trace-structs -f ../files_fpu_verilog.f --top-module test_float --exe ../verilog/tb/test_float_trace.cpp
			make -j -C obj_dir/ -f Vtest_float.mk Vtest_float
			obj_dir/Vtest_float
		fi
	fi
	end=`date +%s`
	echo Execution time was `expr $end - $start` seconds.
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

	xvlog ../verilog/src/float/fp_wire.sv
	xvlog ../verilog/src/float/fp_cons.sv
	xvlog ../verilog/src/float/fp_ext.sv
	xvlog ../verilog/src/float/fp_cmp.sv
	xvlog ../verilog/src/float/fp_max.sv
	xvlog ../verilog/src/float/fp_sgnj.sv
	xvlog ../verilog/src/float/fp_pipe.sv
	xvlog ../verilog/src/float/fp_unit.sv

	xvlog ../verilog/tb/test_float.sv
	xvlog ../verilog/tb/test_float_p.sv

	xelab -debug typical test_float -s test_float_sim
	xsim test_float_sim -ieeewarnings -R
fi
