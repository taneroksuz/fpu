#!/bin/bash

if [ -d "$1/sim/work" ]; then
	rm -rf $1/sim/work
fi

mkdir $1/sim/work

cd $1/sim/work

ghdl -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_wire.vhd
ghdl -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_lib.vhd

ghdl -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_4.vhd
ghdl -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_8.vhd
ghdl -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_16.vhd
ghdl -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_32.vhd
ghdl -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_64.vhd
ghdl -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_128.vhd
ghdl -a --std=08 --ieee=synopsys ../../vhdl/src/lzc/lzc_256.vhd

ghdl -a --std=08 --ieee=synopsys ../../vhdl/tb/test_lzc.vhd

ghdl -e --std=08 --ieee=synopsys test_lzc
ghdl -r --std=08 --ieee=synopsys test_lzc
