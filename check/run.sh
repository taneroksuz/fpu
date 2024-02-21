#!/bin/bash
set -e

if [ "${VERILOG}" == "1" ]
then

  start=`date +%s`

  ${SLANG} ${BASEDIR}/verilog/src/float/fp_unit.sv \
          -v ${BASEDIR}/verilog/src/lzc/lzc_wire.sv \
          -v ${BASEDIR}/verilog/src/lzc/lzc_4.sv \
          -v ${BASEDIR}/verilog/src/lzc/lzc_8.sv \
          -v ${BASEDIR}/verilog/src/lzc/lzc_16.sv \
          -v ${BASEDIR}/verilog/src/lzc/lzc_32.sv \
          -v ${BASEDIR}/verilog/src/lzc/lzc_64.sv \
          -v ${BASEDIR}/verilog/src/lzc/lzc_128.sv \
          -v ${BASEDIR}/verilog/src/lzc/lzc_256.sv \
          -v ${BASEDIR}/verilog/src/float/fp_wire.sv \
          -v ${BASEDIR}/verilog/src/float/fp_ext.sv \
          -v ${BASEDIR}/verilog/src/float/fp_cmp.sv \
          -v ${BASEDIR}/verilog/src/float/fp_max.sv \
          -v ${BASEDIR}/verilog/src/float/fp_sgnj.sv \
          -v ${BASEDIR}/verilog/src/float/fp_cvt.sv \
          -v ${BASEDIR}/verilog/src/float/fp_fma.sv \
          -v ${BASEDIR}/verilog/src/float/fp_mac.sv \
          -v ${BASEDIR}/verilog/src/float/fp_fdiv.sv \
          -v ${BASEDIR}/verilog/src/float/fp_rnd.sv \
          -v ${BASEDIR}/verilog/src/float/fp_exe.sv

  end=`date +%s`
  echo Execution time was `expr $end - $start` seconds.

fi

if [ "${VHDL}" == "1" ]
then

  start=`date +%s`

  end=`date +%s`
  echo Execution time was `expr $end - $start` seconds.

fi