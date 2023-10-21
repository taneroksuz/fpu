#!/bin/bash
set -e

if [ "${VERILOG}" == "1" ]
then

  if [ "${FPU}" == "1" ]
  then
    . ${BASEDIR}/sim/test_fpu_verilog.sh
  fi

  if [ "${LZC}" == "1" ]
  then
    . ${BASEDIR}/sim/test_lzc_verilog.sh
  fi

fi

if [ "${VHDL}" == "1" ]
then

  if [ "${FPU}" == "1" ]
  then
    . ${BASEDIR}/sim/test_fpu_vhdl.sh
  fi

  if [ "${LZC}" == "1" ]
  then
    . ${BASEDIR}/sim/test_lzc_vhdl.sh
  fi

fi