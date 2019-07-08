# README #

WAISENKIND-FPU should be conform to IEEE-754-2008 Standards. Supported Operations are COMPARE, MIN-MAX, CONVERSION, ADDITION, SUBTRACTION, MULTIPLY, FUSED-MULTIPLY-ADD, SQUARE-ROOT and DIVISION in single and double precisions. Except SQRT and DIV all operations are pipelined. Only COMP, MIN-MAX, CONV are executed in same cycle. 

SQRT and DIV calculations are using same subunit but different path (algorithm). This subunit has a generic variable "PERFORMANCE". For functional iterations (LOW LATENCY, LARGE SIZE) please use "1" and fixed point iterations (HIGH LATENCY, SMALL SIZE) use "0". This unit has also own multiply unit seperate from fma unit.

This documentation will be extended in the future.

The installation-scripts need "SUDO" permission in order to install packages and tools for simulation and testcase generation.
