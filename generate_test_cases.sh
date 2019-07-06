#!/bin/bash

TESTFLOAT=/opt/testfloat

PYTHON=/usr/bin/python
SCRIPT=generate_test_cases.py

if [ -d "test_cases" ]; then
  rm -rf test_cases
fi

mkdir test_cases

${PYTHON} ${SCRIPT} "f32_mulAdd"   test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_add"      test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_sub"      test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_mul"      test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_div"      test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_sqrt"     test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_mulAdd"   test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_add"      test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_sub"      test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_mul"      test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_div"      test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_sqrt"     test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_le"       test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_lt"       test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_eq"       test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_le"       test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_lt"       test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_eq"       test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_to_f64"   test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_to_f32"   test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "i32_to_f32"   test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "ui32_to_f32"  test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "i64_to_f32"   test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "ui64_to_f32"  test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "i32_to_f64"   test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "ui32_to_f64"  test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "i64_to_f64"   test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "ui64_to_f64"  test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_to_i32"   test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_to_ui32"  test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_to_i64"   test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f32_to_ui64"  test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_to_i32"   test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_to_ui32"  test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_to_i64"   test_cases/ ${TESTFLOAT}
${PYTHON} ${SCRIPT} "f64_to_ui64"  test_cases/ ${TESTFLOAT}