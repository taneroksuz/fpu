#!/bin/bash

if [ -z "$1" ]
then
	echo "1. option: ghdl, xsim"
	exit
fi

if [ ! -d "work" ]; then
	mkdir work
fi

if [ "$1" = 'ghdl' ]
then
	SYNTAX="ghdl -s --std=08 --ieee=synopsys"
	ANALYS="ghdl -a --std=08 --ieee=synopsys"
fi
if [ "$1" = 'xsim' ]
then
	SYNTAX="echo"
	ANALYS="xvhdl --2008"
fi

cd work

if [ "$1" = 'ghdl' ] || [ "$1" = 'xsim' ]
then
	$SYNTAX ../vhdl/src/lzc/lzc_wire.vhd
	$ANALYS ../vhdl/src/lzc/lzc_wire.vhd

	$SYNTAX ../vhdl/src/lzc/lzc_lib.vhd
	$ANALYS ../vhdl/src/lzc/lzc_lib.vhd

	$SYNTAX ../vhdl/src/lzc/lzc_4.vhd
	$ANALYS ../vhdl/src/lzc/lzc_4.vhd
	$SYNTAX ../vhdl/src/lzc/lzc_8.vhd
	$ANALYS ../vhdl/src/lzc/lzc_8.vhd
	$SYNTAX ../vhdl/src/lzc/lzc_16.vhd
	$ANALYS ../vhdl/src/lzc/lzc_16.vhd
	$SYNTAX ../vhdl/src/lzc/lzc_32.vhd
	$ANALYS ../vhdl/src/lzc/lzc_32.vhd
	$SYNTAX ../vhdl/src/lzc/lzc_64.vhd
	$ANALYS ../vhdl/src/lzc/lzc_64.vhd
	$SYNTAX ../vhdl/src/lzc/lzc_128.vhd
	$ANALYS ../vhdl/src/lzc/lzc_128.vhd
	$SYNTAX ../vhdl/src/lzc/lzc_256.vhd
	$ANALYS ../vhdl/src/lzc/lzc_256.vhd

	$SYNTAX ../vhdl/tb/test_lzc.vhd
	$ANALYS ../vhdl/tb/test_lzc.vhd
fi

if [ "$1" = 'ghdl' ]
then
	ghdl -e --std=08 --ieee=synopsys test_lzc
	ghdl -r --std=08 --ieee=synopsys test_lzc --wave=output.ghw
fi
if [ "$1" = 'xsim' ]
then
	xelab -debug typical test_lzc -s test_lzc_sim
	xsim test_lzc_sim -ieeewarnings -wdb output.wdb -R
fi
