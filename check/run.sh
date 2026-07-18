#!/bin/bash
set -e

if [ "${VERILOG}" == "1" ]
then

  start=`date +%s`

  ${VERIBLE}-verilog-format --inplace ${BASEDIR}/verilog/src/float/fp_unit.sv \
                                      ${BASEDIR}/verilog/src/lzc/lzc_wire.sv \
                                      ${BASEDIR}/verilog/src/lzc/lzc_4.sv \
                                      ${BASEDIR}/verilog/src/lzc/lzc_8.sv \
                                      ${BASEDIR}/verilog/src/lzc/lzc_16.sv \
                                      ${BASEDIR}/verilog/src/lzc/lzc_32.sv \
                                      ${BASEDIR}/verilog/src/lzc/lzc_64.sv \
                                      ${BASEDIR}/verilog/src/lzc/lzc_128.sv \
                                      ${BASEDIR}/verilog/src/lzc/lzc_256.sv \
                                      ${BASEDIR}/verilog/src/float/fp_wire.sv \
                                      ${BASEDIR}/verilog/src/float/fp_ext.sv \
                                      ${BASEDIR}/verilog/src/float/fp_cmp.sv \
                                      ${BASEDIR}/verilog/src/float/fp_max.sv \
                                      ${BASEDIR}/verilog/src/float/fp_sgnj.sv \
                                      ${BASEDIR}/verilog/src/float/fp_cvt.sv \
                                      ${BASEDIR}/verilog/src/float/fp_fma.sv \
                                      ${BASEDIR}/verilog/src/float/fp_mac.sv \
                                      ${BASEDIR}/verilog/src/float/fp_fdiv.sv \
                                      ${BASEDIR}/verilog/src/float/fp_rnd.sv \
                                      ${BASEDIR}/verilog/src/float/fp_exe.sv

  end=`date +%s`
  echo Execution time was `expr $end - $start` seconds.

fi

if [ "${VHDL}" == "1" ]
then

  start=`date +%s`

  ${VSG} -f ${BASEDIR}/vhdl/src/float/fp_unit.vhd \
            ${BASEDIR}/vhdl/src/lzc/lzc_wire.vhd \
            ${BASEDIR}/vhdl/src/lzc/lzc_lib.vhd \
            ${BASEDIR}/vhdl/src/lzc/lzc_4.vhd \
            ${BASEDIR}/vhdl/src/lzc/lzc_8.vhd \
            ${BASEDIR}/vhdl/src/lzc/lzc_16.vhd \
            ${BASEDIR}/vhdl/src/lzc/lzc_32.vhd \
            ${BASEDIR}/vhdl/src/lzc/lzc_64.vhd \
            ${BASEDIR}/vhdl/src/lzc/lzc_128.vhd \
            ${BASEDIR}/vhdl/src/lzc/lzc_256.vhd \
            ${BASEDIR}/vhdl/src/float/fp_wire.vhd \
            ${BASEDIR}/vhdl/src/float/fp_lib.vhd \
            ${BASEDIR}/vhdl/src/float/fp_ext.vhd \
            ${BASEDIR}/vhdl/src/float/fp_cmp.vhd \
            ${BASEDIR}/vhdl/src/float/fp_max.vhd \
            ${BASEDIR}/vhdl/src/float/fp_sgnj.vhd \
            ${BASEDIR}/vhdl/src/float/fp_cvt.vhd \
            ${BASEDIR}/vhdl/src/float/fp_fma.vhd \
            ${BASEDIR}/vhdl/src/float/fp_mac.vhd \
            ${BASEDIR}/vhdl/src/float/fp_fdiv.vhd \
            ${BASEDIR}/vhdl/src/float/fp_rnd.vhd \
            ${BASEDIR}/vhdl/src/float/fp_exe.vhd --fix

  end=`date +%s`
  echo Execution time was `expr $end - $start` seconds.

fi