#!/bin/bash
set -e

if [ "${LANGUAGE}" == "verilog" ]
then
  if [ "${DESIGN}" == "fpu" ]
  then
    . ${BASEDIR}/sim/test_fpu_verilog.sh
  elif [ "${DESIGN}" == "lzc" ]
  then
    . ${BASEDIR}/sim/test_lzc_verilog.sh
  fi
elif [ "${LANGUAGE}" == "vhdl" ]
then
  if [ "${DESIGN}" == "fpu" ]
  then
    . ${BASEDIR}/sim/test_fpu_vhdl.sh
  elif [ "${DESIGN}" == "lzc" ]
  then
    . ${BASEDIR}/sim/test_lzc_vhdl.sh
  fi
fi