# README #

WAISENKIND-FPU should be conform to IEEE-754-2008 Standards. Supported Operations are CONVERSIONS, ADDITION, SUBTRACTION, MULTIPLY, FUSED-MULTIPLY-ADD, SQUARE-ROOT and DIVISION. Both Single and Double-Precision Calculations can be run with this unit. Except SQRT and DIV all operations are pipelined. Only CONVERSIONS are executed in same cycle. 

SQRT and DIV calculations are using same subunit but different path (algorithm). This subunit has a generic variable "PERFORMANCE". For functional iterations (LOW LATENCY, LARGE SIZE) please use "1" and fixed point iterations (HIGH LATENCY, SMALL SIZE) use "0". This unit has also own multiply unit seperate from fma unit.

This documentation will be extended in the future.
