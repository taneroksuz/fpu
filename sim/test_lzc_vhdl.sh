#!/bin/bash
set -e

if [ -d "${BASEDIR}/sim/work" ]; then
	rm -rf ${BASEDIR}/sim/work
fi

mkdir ${BASEDIR}/sim/work

cd ${BASEDIR}/sim/work

start=`date +%s`
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_wire.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_lib.vhd

${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_4.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_8.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_16.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_32.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_64.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_128.vhd
${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_256.vhd

${GHDL} -a --std=08 ${BASEDIR}/vhdl/tb/test_lzc.vhd

${GHDL} -e --std=08 test_lzc
${GHDL} -r test_lzc --asserts=disable-at-0

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
