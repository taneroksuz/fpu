#!/bin/bash

TESTFLOAT=${3}
PYTHON=${4}

SCRIPT=${1}/generate_test_cases.py
ROUND=${2}

if [ -d "${1}/test_cases" ]; then
  rm -rf ${1}/test_cases
fi

mkdir ${1}/test_cases

${PYTHON} ${SCRIPT} "f32_mulAdd"   ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_add"      ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_sub"      ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_mul"      ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_div"      ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_sqrt"     ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_mulAdd"   ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_add"      ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_sub"      ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_mul"      ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_div"      ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_sqrt"     ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_le"       ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_lt"       ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_eq"       ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_le"       ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_lt"       ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_eq"       ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_to_f64"   ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_to_f32"   ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "i32_to_f32"   ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "ui32_to_f32"  ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "i64_to_f32"   ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "ui64_to_f32"  ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "i32_to_f64"   ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "ui32_to_f64"  ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "i64_to_f64"   ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "ui64_to_f64"  ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_to_i32"   ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_to_ui32"  ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_to_i64"   ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f32_to_ui64"  ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_to_i32"   ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_to_ui32"  ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_to_i64"   ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &
${PYTHON} ${SCRIPT} "f64_to_ui64"  ${ROUND} ${1}/test_cases/ ${TESTFLOAT} &

wait
