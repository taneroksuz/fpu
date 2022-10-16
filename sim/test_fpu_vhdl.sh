#!/bin/bash
set -e

xsim=${1}
xvhdl=${2}
xelab=${3}

if [ -d "sim/work" ]; then
	rm -rf sim/work
fi

mkdir sim/work

if [ ! -z "$4" ]
then
	if [ ! "$4" = 'all' ]
	then
		cp tests/test_cases/$4.dat sim/work/fpu.dat
	fi
fi

cd sim/work

start=`date +%s`
${xvhdl} ../../vhdl/src/lzc/lzc_wire.vhd > /dev/null

${xvhdl} ../../vhdl/src/float/fp_cons.vhd > /dev/null
${xvhdl} ../../vhdl/src/float/fp_wire.vhd > /dev/null
${xvhdl} ../../vhdl/src/float/fp_func.vhd > /dev/null

${xvhdl} ../../vhdl/src/lzc/lzc_lib.vhd > /dev/null
${xvhdl} ../../vhdl/src/lzc/lzc_4.vhd > /dev/null
${xvhdl} ../../vhdl/src/lzc/lzc_8.vhd > /dev/null
${xvhdl} ../../vhdl/src/lzc/lzc_16.vhd > /dev/null
${xvhdl} ../../vhdl/src/lzc/lzc_32.vhd > /dev/null
${xvhdl} ../../vhdl/src/lzc/lzc_64.vhd > /dev/null
${xvhdl} ../../vhdl/src/lzc/lzc_128.vhd > /dev/null

${xvhdl} ../../vhdl/src/float/fp_lib.vhd > /dev/null
${xvhdl} ../../vhdl/src/float/fp_ext.vhd > /dev/null
${xvhdl} ../../vhdl/src/float/fp_cmp.vhd > /dev/null
${xvhdl} ../../vhdl/src/float/fp_max.vhd > /dev/null
${xvhdl} ../../vhdl/src/float/fp_sgnj.vhd > /dev/null
${xvhdl} ../../vhdl/src/float/fp_cvt.vhd > /dev/null
${xvhdl} ../../vhdl/src/float/fp_rnd.vhd > /dev/null
${xvhdl} ../../vhdl/src/float/fp_fma.vhd > /dev/null
${xvhdl} ../../vhdl/src/float/fp_mac.vhd > /dev/null
${xvhdl} ../../vhdl/src/float/fp_fdiv.vhd > /dev/null
${xvhdl} ../../vhdl/src/float/fp_exe.vhd > /dev/null
${xvhdl} ../../vhdl/src/float/fp_unit.vhd > /dev/null

${xvhdl} -2008 ../../vhdl/tb/test_float.vhd > /dev/null
${xvhdl} -2008 ../../vhdl/tb/test_float_s.vhd > /dev/null
${xvhdl} -2008 ../../vhdl/tb/test_float_p.vhd > /dev/null

if [ "$4" = 'all' ]
then
	for filename in ../../tests/test_cases/*.dat; do
		cp $filename fpu.dat
		echo "${filename%.dat}"
		if [ `echo $filename | grep -c "div\|sqrt" ` -gt 0 ]
		then
			${xelab} test_float_s > /dev/null
			${xsim} -runall test_float_s
		elif [ `echo $filename | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
		then
			${xelab} test_float_p > /dev/null
			${xsim} -runall test_float_p
		else
			${xelab} test_float > /dev/null
			${xsim} -runall test_float
		fi
	done
else
	echo "$4"
	echo "log_wave -recursive *" > wave.tcl
	echo "run -all" >> wave.tcl
	echo "exit" >> wave.tcl
	if [ `echo $4 | grep -c "div\|sqrt" ` -gt 0 ]
	then
		${xelab} -debug all test_float_s > /dev/null
		${xsim} -wdb output.wdb -tclbatch wave.tcl test_float_s
	elif [ `echo $4 | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
	then
		${xelab} -debug all test_float_p > /dev/null
		${xsim} -wdb output.wdb -tclbatch wave.tcl test_float_p
	else
		${xelab} -debug all test_float > /dev/null
		${xsim} -wdb output.wdb -tclbatch wave.tcl test_float
	fi
fi
end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
