#include "Vtest_float_s.h"
#include <verilated.h>
#include <verilated_vcd_sc.h>

#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

using namespace std;

int sc_main(int argc, char* argv[])
{
  Verilated::commandArgs(argc, argv);

  string filename;
  char *p;
  const char *dumpfile;

  if (argc>1)
  {
    filename = string(argv[1]);
    filename = filename + ".vcd";
    dumpfile = filename.c_str();
  }

  sc_clock clock ("clock", 2,SC_NS, 1, 1,SC_NS, false);
  sc_signal<bool> reset;

  Vtest_float_s* top = new Vtest_float_s("test_float_s");

  top->clock (clock);
  top->reset (reset);

#if VM_TRACE
  Verilated::traceEverOn(true);
#endif

#if VM_TRACE
  VerilatedVcdSc* dump = new VerilatedVcdSc;
  sc_start(sc_core::SC_ZERO_TIME);
  top->trace(dump, 99);
  dump->open(dumpfile);
#endif
  
  while (!Verilated::gotFinish())
  {
#if VM_TRACE
    if (dump) dump->flush();
#endif
    if (VL_TIME_Q() > 0 && VL_TIME_Q() < 10)
    {
      reset = !1;
    }
    else if (VL_TIME_Q() > 0)
    {
      reset = !0;
    }
    sc_start(1,SC_NS);
  }

  cout << "End of simulation is " << sc_time_stamp() << endl;

  top->final();

#if VM_TRACE
  if (dump)
  {
    dump->close();
    dump = NULL;
  }
#endif

  delete top;
  top = NULL;

  return 0;
}

