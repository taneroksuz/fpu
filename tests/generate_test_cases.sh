#!/bin/bash

TESTFLOAT=${1}
PYTHON=${2}

if [ -d "tests/test_cases" ]; then
  rm -rf tests/test_cases
fi

mkdir tests/test_cases

${PYTHON} tests/generate_test_cases.py "f32_mulAdd"   tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f32_add"      tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f32_sub"      tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f32_mul"      tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f32_div"      tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f32_sqrt"     tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_mulAdd"   tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_add"      tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_sub"      tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_mul"      tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_div"      tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_sqrt"     tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f32_le"       tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f32_lt"       tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f32_eq"       tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_le"       tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_lt"       tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_eq"       tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f32_to_f64"   tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_to_f32"   tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "i32_to_f32"   tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "ui32_to_f32"  tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "i64_to_f32"   tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "ui64_to_f32"  tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "i32_to_f64"   tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "ui32_to_f64"  tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "i64_to_f64"   tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "ui64_to_f64"  tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f32_to_i32"   tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f32_to_ui32"  tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f32_to_i64"   tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f32_to_ui64"  tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_to_i32"   tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_to_ui32"  tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_to_i64"   tests/test_cases/ ${TESTFLOAT}
${PYTHON} tests/generate_test_cases.py "f64_to_ui64"  tests/test_cases/ ${TESTFLOAT}
