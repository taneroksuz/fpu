# RISCV FPU Single and Double Precision #

This floating point unit is conform to IEEE 754-2008 standards. Supported operations are **compare**, **min-max**, **conversions**, **addition**, **subtruction**, **multiplication**, **fused multiply add**, **square root** and **division** in single and double precisions. Except **square root** and **division** all operations are pipelined.

This unit uses canonical **nan** (not a number) form, if it generates any **nan** as output. E.g. 0x7FC00000 for single precision and 0x7FF8000000000000 for double precision. Therefore extra conditions are added in order compare outputs with testfloat data correctly by **nan** generation.

**Square root** and **division** calculations are using same subunit but different path (algorithm). This subunit has a generic variable **_performance_**. For functional iterations which are fast please use **1** and fixed point iterations which are slow use **0**. This unit has also own multiplier.

## LATENCY ##

### Single and Double Precision ###

| comp | max | conv | add | sub | mul | fma |
|:----:|:---:|:----:|:---:|:---:|:---:|:---:|
| 1    | 1   | 1    | 5   | 5   | 5   | 5   |

### Single Precision ###

|performance| division | square root |
|:---------:|:--------:|:-----------:|
| 0         | 29       | 28          |
| 1         | 14       | 17          |

### Double Precision ###

|performance| division | square root |
|:---------:|:--------:|:-----------:|
| 0         | 58       | 57          |
| 1         | 14       | 17          |

## TOOLS ##

The installation scripts of necessary tools are located in directory **tools**. These scripts need **root** permission in order to install packages and tools for simulation and testcase generation. Please run these scripts in directory **tools** locally.

## GENERATE ##

To generate test cases you could use following command:

```console
make generate
```

## SIMULATION ##

To simulate the design together with generated test cases you could run following command:

```console
make simulation
```

This command require three options **LANGUAGE**, **DESIGN** and **TEST**. The possible settings of these options can be found in the makefile.

An example execution of this command looks like as follows:

```console
make simulation LANGUAGE=verilog DESIGN=fpu TEST=all
```

## SYNTHESIS ##

To generate synthesizable code of the design you could execute following command:

```console
make synthesis
```

This command creates **vhdl** and **verilog** codes in directory **synth**.

## SINGLE PRECISION ##

[Link for floating point unit with only single precision format.](https://github.com/taneroksuz/riscv-sfpu.git)
