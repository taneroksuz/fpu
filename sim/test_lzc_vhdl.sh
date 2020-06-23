#!/bin/bash

ghdl=${1}

if [ -d "sim/work" ]; then
	rm -rf sim/work
fi

mkdir sim/work

cd sim/work

start=`date +%s`
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_wire.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_lib.vhd

${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_4.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_8.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_16.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_32.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_64.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_128.vhd
${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_256.vhd

${ghdl} -a --std=08 --ieee=synopsys ../../vhdl/tb/test_lzc.vhd

${ghdl} -e --std=08 --ieee=synopsys test_lzc
${ghdl} -r --std=08 --ieee=synopsys test_lzc

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
