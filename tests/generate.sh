#!/bin/bash

if [ -d "${BASEDIR}/tests/test_cases" ]; then
  rm -rf ${BASEDIR}/tests/test_cases
fi

mkdir ${BASEDIR}/tests/test_cases

chmod +x ${TESTFLOAT}

OPERATION="f32_mulAdd f32_add f32_sub f32_mul f32_div f32_sqrt \
           f64_mulAdd f64_add f64_sub f64_mul f64_div f64_sqrt \
           f32_to_f64 f64_to_f32 \
           i32_to_f32 ui32_to_f32 i64_to_f32 ui64_to_f32 \
           i32_to_f64 ui32_to_f64 i64_to_f64 ui64_to_f64 \
           f32_to_i32 f32_to_ui32 f32_to_i64 f32_to_ui64 \
           f64_to_i32 f64_to_ui32 f64_to_i64 f64_to_ui64"
COMPARISON="f32_le f32_lt f32_eq f64_le f64_lt f64_eq"
ROUNDING="rne rtz rdn rup rmm"

declare -A MODE=(["rne"]="-rnear_even" ["rtz"]="-rminMag" ["rdn"]="-rmin" ["rup"]="-rmax" ["rmm"]="-rnear_maxMag")

for OP in $OPERATION; do
  for ROUND in $ROUNDING; do
    ${TESTFLOAT} ${OP} ${MODE[${ROUND}]} -exact > ${BASEDIR}/tests/test_cases/${OP}_${ROUND}.hex &
  done
done

for COMP in $COMPARISON; do
  ${TESTFLOAT} ${COMP} -exact > ${BASEDIR}/tests/test_cases/${COMP}.hex &
done

wait
