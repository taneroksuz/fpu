#!/bin/bash

if [ -d "synth/verilog" ]; then
  rm -rf synth/verilog
fi

mkdir synth/verilog

sv2v=$1

cd synth/verilog

${sv2v} ../../verilog/src/lzc/lzc_wire.sv \
              ../../verilog/src/lzc/lzc_4.sv \
              ../../verilog/src/lzc/lzc_8.sv \
              ../../verilog/src/lzc/lzc_16.sv \
              ../../verilog/src/lzc/lzc_32.sv \
              ../../verilog/src/lzc/lzc_64.sv \
              ../../verilog/src/lzc/lzc_128.sv \
              ../../verilog/src/lzc/lzc_256.sv \
              ../../verilog/src/float/fp_wire.sv \
              ../../verilog/src/float/fp_cons.sv \
              ../../verilog/src/float/fp_ext.sv \
              ../../verilog/src/float/fp_cmp.sv \
              ../../verilog/src/float/fp_max.sv \
              ../../verilog/src/float/fp_sgnj.sv \
              ../../verilog/src/float/fp_cvt.sv \
              ../../verilog/src/float/fp_fma.sv \
              ../../verilog/src/float/fp_mac.sv \
              ../../verilog/src/float/fp_fdiv.sv \
              ../../verilog/src/float/fp_rnd.sv \
              ../../verilog/src/float/fp_exe.sv \
              ../../verilog/src/float/fp_unit.sv \
              > fp_unit.v
