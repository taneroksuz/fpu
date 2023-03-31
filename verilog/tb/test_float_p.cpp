#include <stdlib.h>
#include <iostream>
#include <cstdlib>
#include <cstring>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtest_float_p.h"

vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env)
{
  Verilated::commandArgs(argc, argv);
  Vtest_float_p *dut = new Vtest_float_p;

#if VM_TRACE
  Verilated::traceEverOn(true);
  VerilatedVcdC *trace = new VerilatedVcdC;
  dut->trace(trace, 0);
  trace->open("fpu.vcd");
#endif

  bool finished = false;

  while (1)
  {
    if (sim_time < 10)
      dut->reset = 0;
    else
      dut->reset = 1;

    dut->clock ^= 1;

    dut->eval();

#if VM_TRACE
    trace->dump(sim_time);
#endif

    sim_time++;

    if (Verilated::gotFinish())
    {
      finished = true;
      break;
    }
  }

  if (!finished)
  {
    std::cout << "\033[33m";
    std::cout << "TEST STOPPED" << std::endl;
    std::cout << "\033[0m";
  }

  std::cout << "simulation finished @" << sim_time << "ps" << std::endl;

#if VM_TRACE
  trace->close();
#endif

  delete dut;
  exit(EXIT_SUCCESS);
}