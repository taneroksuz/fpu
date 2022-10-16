#!/bin/bash
set -e

xsim=${1}
xvhdl=${2}
xelab=${3}

if [ -d "sim/work" ]; then
	rm -rf sim/work
fi

mkdir sim/work

cd sim/work

start=`date +%s`
${xvhdl} ../../vhdl/src/lzc/lzc_wire.vhd > /dev/null
${xvhdl} ../../vhdl/src/lzc/lzc_lib.vhd > /dev/null

${xvhdl} ../../vhdl/src/lzc/lzc_4.vhd > /dev/null
${xvhdl} ../../vhdl/src/lzc/lzc_8.vhd > /dev/null
${xvhdl} ../../vhdl/src/lzc/lzc_16.vhd > /dev/null
${xvhdl} ../../vhdl/src/lzc/lzc_32.vhd > /dev/null
${xvhdl} ../../vhdl/src/lzc/lzc_64.vhd > /dev/null
${xvhdl} ../../vhdl/src/lzc/lzc_128.vhd > /dev/null
${xvhdl} ../../vhdl/src/lzc/lzc_256.vhd > /dev/null

${xvhdl} ../../vhdl/tb/test_lzc.vhd > /dev/null

${xelab} test_lzc > /dev/null
${xsim} -runall test_lzc

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
