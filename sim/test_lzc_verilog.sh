#!/bin/bash
set -e

if [ -d "${BASEDIR}/sim/work" ]; then
	rm -rf ${BASEDIR}/sim/work
fi

mkdir ${BASEDIR}/sim/work

cd ${BASEDIR}/sim/work

start=`date +%s`

${VERILATOR} --binary -f ${BASEDIR}/sim/files_lzc_verilog.f --top-module test_lzc 2>&1 > /dev/null
make -s -j -C obj_dir/ -f Vtest_lzc.mk Vtest_lzc
obj_dir/Vtest_lzc

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
