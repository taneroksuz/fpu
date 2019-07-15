# README #

WAISENKIND-FPU should be conform to IEEE-754-2008 standards. Supported operations are COMPARE, MIN-MAX, CONVERSION, ADDITION, SUBTRACTION, MULTIPLY, FUSED-MULTIPLY-ADD, SQUARE-ROOT and DIVISION in single and double precisions. Except SQRT and DIV all operations are pipelined. Only COMP, MIN-MAX, CONV are executed in same cycle. 

This unit uses canonical NAN form, if it generates any NAN as output. E.g. 0x7FC00000 for single precision and 0x7FF8000000000000 for double precision. Therefore extra conditions are added in order compare outputs with testfloat data correctly by NAN generation.

SQRT and DIV calculations are using same subunit but different path (algorithm). This subunit has a generic variable "PERFORMANCE". For functional iterations (LOW LATENCY, LARGE SIZE) please use "1" and fixed point iterations (HIGH LATENCY, SMALL SIZE) use "0". This unit has also own multiply unit seperate from fma unit.

This documentation will be extended in the future.

The installation scripts need root permission in order to install packages and tools for simulation and testcase generation.
