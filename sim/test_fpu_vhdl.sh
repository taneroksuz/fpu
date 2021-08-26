#!/bin/bash

ghdl=${1}

if [ -d "sim/work" ]; then
	rm -rf sim/work
fi

mkdir sim/work

if [ ! -z "$2" ]
then
	if [ ! "$2" = 'all' ]
	then
		cp tests/test_cases/$2.dat sim/work/fpu.dat
	fi
fi

cd sim/work

start=`date +%s`
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_wire.vhd

${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_cons.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_wire.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_func.vhd

${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_lib.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_4.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_8.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_16.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_32.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_64.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_128.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_256.vhd

${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_lib.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_ext.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_cmp.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_max.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_sgnj.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_cvt.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_rnd.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_fma.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_mac.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_fdiv.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_exe.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/float/fp_unit.vhd

${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/tb/test_float.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/tb/test_float_s.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/tb/test_float_p.vhd

if [ "$2" = 'all' ]
then
	for filename in ../../tests/test_cases/*.dat; do
		cp $filename fpu.dat
		echo "${filename%.dat}"
		if [ `echo $filename | grep -c "div\|sqrt" ` -gt 0 ]
		then
			${ghdl} -e --std=08 --ieee=synopsys test_float_s
			${ghdl} -r --std=08 --ieee=synopsys test_float_s --ieee-asserts=disable-at-0
		elif [ `echo $filename | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
		then
			${ghdl} -e --std=08 --ieee=synopsys test_float_p
			${ghdl} -r --std=08 --ieee=synopsys test_float_p --ieee-asserts=disable-at-0
		else
			${ghdl} -e --std=08 --ieee=synopsys test_float
			${ghdl} -r --std=08 --ieee=synopsys test_float --ieee-asserts=disable-at-0
		fi
	done
else
	echo "$2"
	if [ `echo $2 | grep -c "div\|sqrt" ` -gt 0 ]
	then
		${ghdl} -e --std=08 --ieee=synopsys test_float_s
		${ghdl} -r --std=08 --ieee=synopsys test_float_s --ieee-asserts=disable-at-0 --wave=output.ghw
	elif [ `echo $2 | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
	then
		${ghdl} -e --std=08 --ieee=synopsys test_float_p
		${ghdl} -r --std=08 --ieee=synopsys test_float_p --ieee-asserts=disable-at-0 --wave=output.ghw
	else
		${ghdl} -e --std=08 --ieee=synopsys test_float
		${ghdl} -r --std=08 --ieee=synopsys test_float --ieee-asserts=disable-at-0 --wave=output.ghw
	fi
fi
end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
