#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]
then
	echo "1. option: ghdl, xsim"
	echo "2. option: floating point operation <e.g. f32_mulAdd>"
	exit
fi

if [ ! -d "work" ]; then
	mkdir work
fi

if [ "$1" = 'ghdl' ]
then
	SYNTAX="ghdl -s --std=08 --ieee=synopsys"
	ANALYS="ghdl -a --std=08 --ieee=synopsys"
elif [ "$1" = 'xsim' ]
then
	SYNTAX="echo"
	ANALYS="xvhdl --2008"
fi

if [ ! -z "$2" ]
then
	if [ ! "$2" = 'all' ]
	then
		cp $2 work/fpu.dat
	fi
fi

cd work

if [ "$1" = 'ghdl' ] || [ "$1" = 'xsim' ]
then
	$SYNTAX ../vhdl/src/lzc/lzc_wire.vhd
	$ANALYS ../vhdl/src/lzc/lzc_wire.vhd

	$SYNTAX ../vhdl/src/float/fp_cons.vhd
	$ANALYS ../vhdl/src/float/fp_cons.vhd
	$SYNTAX ../vhdl/src/float/fp_wire.vhd
	$ANALYS ../vhdl/src/float/fp_wire.vhd

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

	$SYNTAX ../vhdl/src/float/fp_lib.vhd
	$ANALYS ../vhdl/src/float/fp_lib.vhd
	$SYNTAX ../vhdl/src/float/fp_ext.vhd
	$ANALYS ../vhdl/src/float/fp_ext.vhd
	$SYNTAX ../vhdl/src/float/fp_cmp.vhd
	$ANALYS ../vhdl/src/float/fp_cmp.vhd
	$SYNTAX ../vhdl/src/float/fp_max.vhd
	$ANALYS ../vhdl/src/float/fp_max.vhd
	$SYNTAX ../vhdl/src/float/fp_sgnj.vhd
	$ANALYS ../vhdl/src/float/fp_sgnj.vhd
	$SYNTAX ../vhdl/src/float/fp_cvt.vhd
	$ANALYS ../vhdl/src/float/fp_cvt.vhd
	$SYNTAX ../vhdl/src/float/fp_rnd.vhd
	$ANALYS ../vhdl/src/float/fp_rnd.vhd
	$SYNTAX ../vhdl/src/float/fp_fma.vhd
	$ANALYS ../vhdl/src/float/fp_fma.vhd
	$SYNTAX ../vhdl/src/float/fp_mac.vhd
	$ANALYS ../vhdl/src/float/fp_mac.vhd
	$SYNTAX ../vhdl/src/float/fp_fdiv.vhd
	$ANALYS ../vhdl/src/float/fp_fdiv.vhd
	$SYNTAX ../vhdl/src/float/fp_exe.vhd
	$ANALYS ../vhdl/src/float/fp_exe.vhd
	$SYNTAX ../vhdl/src/float/fp_unit.vhd
	$ANALYS ../vhdl/src/float/fp_unit.vhd

	$SYNTAX ../vhdl/tb/test_float.vhd
	$ANALYS ../vhdl/tb/test_float.vhd
	$SYNTAX ../vhdl/tb/test_float_s.vhd
	$ANALYS ../vhdl/tb/test_float_s.vhd
	$SYNTAX ../vhdl/tb/test_float_p.vhd
	$ANALYS ../vhdl/tb/test_float_p.vhd
fi

if [ "$1" = 'ghdl' ]
then
	start=`date +%s`
	if [ "$2" = 'all' ]
	then
		for filename in ../test_cases/*.dat; do
			cp $filename fpu.dat
			echo "${filename%.dat}"
			if [ `echo $filename | grep -c "div\|sqrt" ` -gt 0 ]
			then
				ghdl -e --std=08 --ieee=synopsys test_float_s
				ghdl -r --std=08 --ieee=synopsys test_float_s --ieee-asserts=disable-at-0
			elif [ `echo $filename | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
			then
				ghdl -e --std=08 --ieee=synopsys test_float_p
				ghdl -r --std=08 --ieee=synopsys test_float_p --ieee-asserts=disable-at-0
			else
				ghdl -e --std=08 --ieee=synopsys test_float
				ghdl -r --std=08 --ieee=synopsys test_float --ieee-asserts=disable-at-0
			fi
		done
	else
		echo "$2"
		if [ `echo $2 | grep -c "div\|sqrt" ` -gt 0 ]
		then
			ghdl -e --std=08 --ieee=synopsys test_float_s
			ghdl -r --std=08 --ieee=synopsys test_float_s --ieee-asserts=disable-at-0 --wave=output.ghw
		elif [ `echo $2 | grep -c "mulAdd\|mul\|add\|sub" ` -gt 0 ]
		then
			ghdl -e --std=08 --ieee=synopsys test_float_p
			ghdl -r --std=08 --ieee=synopsys test_float_p --ieee-asserts=disable-at-0 --wave=output.ghw
		else
			ghdl -e --std=08 --ieee=synopsys test_float
			ghdl -r --std=08 --ieee=synopsys test_float --ieee-asserts=disable-at-0 --wave=output.ghw
		fi
	fi
	end=`date +%s`
	echo Execution time was `expr $end - $start` seconds.
elif [ "$1" = 'xsim' ]
then
	xelab -debug typical test_float -s test_float_sim
	xsim test_float_sim -ieeewarnings -wdb output.wdb -R
fi
