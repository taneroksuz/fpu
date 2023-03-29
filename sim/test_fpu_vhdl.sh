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
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_wire.vhd

${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_cons.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_wire.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_func.vhd

${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_lib.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_4.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_8.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_16.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_32.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_64.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_128.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_256.vhd

${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_lib.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_ext.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_cmp.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_max.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_sgnj.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_cvt.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_rnd.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_fma.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_mac.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_fdiv.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_exe.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/float/fp_unit.vhd

${GHDL} -a --std=08 --std=08 ${BASEDIR}/vhdl/tb/test_float.vhd
${GHDL} -a --std=08 --std=08 ${BASEDIR}/vhdl/tb/test_float_s.vhd
${GHDL} -a --std=08 --std=08 ${BASEDIR}/vhdl/tb/test_float_p.vhd

if [ "${TEST}" = 'all' ]
then
	for filename in ${BASEDIR}/tests/test_cases/*.dat; do
		cp $filename fpu.dat
		filename=$(basename $filename .dat) 
		echo $filename
		if [ `echo $filename | grep -c "div\|sqrt" ` -gt 0 ]
		then
			${GHDL} -e --std=08 test_float_s
			${GHDL} -r test_float_s --asserts=disable-at-0
		elif [ `echo $filename | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
		then
			${GHDL} -e --std=08 test_float_p
			${GHDL} -r test_float_p --asserts=disable-at-0
		else
			${GHDL} -e --std=08 test_float
			${GHDL} -r test_float --asserts=disable-at-0
		fi
	done
else
	echo "${TEST}"
	if [ `echo ${TEST} | grep -c "div\|sqrt" ` -gt 0 ]
	then
		${GHDL} -e --std=08 test_float_s
		${GHDL} -r test_float_s --asserts=disable-at-0 --wave=fpu.ghw
	elif [ `echo ${TEST} | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
	then
		${GHDL} -e --std=08 test_float_p
		${GHDL} -r test_float_p --asserts=disable-at-0 --wave=fpu.ghw
	else
		${GHDL} -e --std=08 test_float
		${GHDL} -r test_float --asserts=disable-at-0 --wave=fpu.ghw
	fi
fi
end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
