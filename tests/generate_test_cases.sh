#!/bin/bash

TESTFLOAT=${2}
PYTHON=${3}

SCRIPT=${1}/generate_test_cases.py

if [ -d "${1}/test_cases" ]; then
  rm -rf ${1}/test_cases
fi

mkdir ${1}/test_cases

${PYTHON} ${SCRIPT} "f32_mulAdd"   ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_add"      ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_sub"      ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_mul"      ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_div"      ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_sqrt"     ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_mulAdd"   ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_add"      ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_sub"      ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_mul"      ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_div"      ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_sqrt"     ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_le"       ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_lt"       ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_eq"       ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_le"       ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_lt"       ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_eq"       ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_to_f64"   ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_to_f32"   ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "i32_to_f32"   ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "ui32_to_f32"  ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "i64_to_f32"   ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "ui64_to_f32"  ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "i32_to_f64"   ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "ui32_to_f64"  ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "i64_to_f64"   ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "ui64_to_f64"  ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_to_i32"   ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_to_ui32"  ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_to_i64"   ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_to_ui64"  ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_to_i32"   ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_to_ui32"  ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_to_i64"   ${1}/test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_to_ui64"  ${1}/test_cases/ ${TESTFLOAT}
