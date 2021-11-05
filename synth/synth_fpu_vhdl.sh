#!/bin/bash

if [ -d "synth/vhdl" ]; then
  rm -rf synth/vhdl
fi

mkdir synth/vhdl

ghdl=$1

cd synth/vhdl

${ghdl} --synth -fsynopsys \
              ../../vhdl/src/lzc/lzc_wire.vhd \
              ../../vhdl/src/float/fp_cons.vhd \
              ../../vhdl/src/float/fp_wire.vhd \
              ../../vhdl/src/float/fp_func.vhd \
              ../../vhdl/src/lzc/lzc_lib.vhd \
              ../../vhdl/src/lzc/lzc_4.vhd \
              ../../vhdl/src/lzc/lzc_8.vhd \
              ../../vhdl/src/lzc/lzc_16.vhd \
              ../../vhdl/src/lzc/lzc_32.vhd \
              ../../vhdl/src/lzc/lzc_64.vhd \
              ../../vhdl/src/lzc/lzc_128.vhd \
              ../../vhdl/src/lzc/lzc_256.vhd \
              ../../vhdl/src/float/fp_lib.vhd \
              ../../vhdl/src/float/fp_ext.vhd \
              ../../vhdl/src/float/fp_cmp.vhd \
              ../../vhdl/src/float/fp_max.vhd \
              ../../vhdl/src/float/fp_sgnj.vhd \
              ../../vhdl/src/float/fp_cvt.vhd \
              ../../vhdl/src/float/fp_rnd.vhd \
              ../../vhdl/src/float/fp_fma.vhd \
              ../../vhdl/src/float/fp_mac.vhd \
              ../../vhdl/src/float/fp_fdiv.vhd \
              ../../vhdl/src/float/fp_exe.vhd \
              ../../vhdl/src/float/fp_unit.vhd \
              -e fp_unit > fp_unit.vhd

cp ../../vhdl/src/lzc/lzc_wire.vhd .
cp ../../vhdl/src/lzc/lzc_lib.vhd .
cp ../../vhdl/src/float/fp_cons.vhd .
cp ../../vhdl/src/float/fp_wire.vhd .
cp ../../vhdl/src/float/fp_lib.vhd .
