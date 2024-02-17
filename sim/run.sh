#!/bin/bash
set -e

if [ -d "${BASEDIR}/sim/work" ]; then
	rm -rf ${BASEDIR}/sim/work
fi

mkdir ${BASEDIR}/sim/work

cd ${BASEDIR}/sim/work

ln -s ${BASEDIR}/tests/test_cases/*.hex ${BASEDIR}/sim/work/.

if [ "${VERILOG}" == "1" ]
then

  start=`date +%s`

  ${VERILATOR} --cc --timing -Wno-UNOPTFLAT -f ${BASEDIR}/sim/files_verilog.f --top-module test_float_s --exe ${BASEDIR}/verilog/tb/test_float_s.cpp 2>&1 > /dev/null
  make -s -j -C obj_dir/ -f Vtest_float_s.mk Vtest_float_s
  ${VERILATOR} --cc --timing -Wno-UNOPTFLAT -f ${BASEDIR}/sim/files_verilog.f --top-module test_float_p --exe ${BASEDIR}/verilog/tb/test_float_p.cpp 2>&1 > /dev/null
  make -s -j -C obj_dir/ -f Vtest_float_p.mk Vtest_float_p
  ${VERILATOR} --cc --timing -Wno-UNOPTFLAT -f ${BASEDIR}/sim/files_verilog.f --top-module test_float --exe ${BASEDIR}/verilog/tb/test_float.cpp 2>&1 > /dev/null
  make -s -j -C obj_dir/ -f Vtest_float.mk Vtest_float
  obj_dir/Vtest_float_s
  obj_dir/Vtest_float_p
  obj_dir/Vtest_float

  end=`date +%s`
  echo Execution time was `expr $end - $start` seconds.

fi

if [ "${VHDL}" == "1" ]
then

  start=`date +%s`

  ${GHDL} -a --std=08 ${BASEDIR}/vhdl/src/lzc/lzc_wire.vhd

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

  ${GHDL} -a --std=08 ${BASEDIR}/vhdl/tb/test_float.vhd
  ${GHDL} -a --std=08 ${BASEDIR}/vhdl/tb/test_float_s.vhd
  ${GHDL} -a --std=08 ${BASEDIR}/vhdl/tb/test_float_p.vhd

  ${GHDL} -e --std=08 test_float_s
  ${GHDL} -r test_float_s --asserts=disable-at-0
  ${GHDL} -e --std=08 test_float_p
  ${GHDL} -r test_float_p --asserts=disable-at-0
  ${GHDL} -e --std=08 test_float
  ${GHDL} -r test_float --asserts=disable-at-0

  end=`date +%s`
  echo Execution time was `expr $end - $start` seconds.

fi