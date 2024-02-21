#!/bin/bash
set -e

if [ "${VERILOG}" == "1" ]
then

  start=`date +%s`

  ${SLANG} ${BASEDIR}/verilog/src/float/fp_unit.sv -I ${BASEDIR}/verilog/src/fpu -I ${BASEDIR}/verilog/src/lzc

  end=`date +%s`
  echo Execution time was `expr $end - $start` seconds.

fi

if [ "${VHDL}" == "1" ]
then

  start=`date +%s`

  end=`date +%s`
  echo Execution time was `expr $end - $start` seconds.

fi