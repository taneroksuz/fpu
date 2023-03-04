#!/bin/bash

SCRIPT=${BASEDIR}/tests/generate_test_cases.py

if [ -d "${BASEDIR}/tests/test_cases" ]; then
  rm -rf ${BASEDIR}/tests/test_cases
fi

mkdir ${BASEDIR}/tests/test_cases

${PYTHON} ${SCRIPT} "f32_mulAdd"   ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_add"      ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_sub"      ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_mul"      ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_div"      ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_sqrt"     ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_mulAdd"   ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_add"      ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_sub"      ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_mul"      ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_div"      ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_sqrt"     ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_le"       ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_lt"       ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_eq"       ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_le"       ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_lt"       ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_eq"       ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_to_f64"   ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_to_f32"   ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "i32_to_f32"   ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "ui32_to_f32"  ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "i64_to_f32"   ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "ui64_to_f32"  ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "i32_to_f64"   ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "ui32_to_f64"  ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "i64_to_f64"   ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "ui64_to_f64"  ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_to_i32"   ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_to_ui32"  ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_to_i64"   ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_to_ui64"  ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_to_i32"   ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_to_ui32"  ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_to_i64"   ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_to_ui64"  ${ROUND} ${BASEDIR}/tests/test_cases/ ${TESTFLOAT} &

wait
