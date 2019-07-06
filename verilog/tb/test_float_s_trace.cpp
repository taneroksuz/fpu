#include "Vtest_float_s.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

vluint64_t main_time = 0;

double sc_time_stamp()
{
  return main_time;
}

int main(int argc, char **argv, char **env)
{
  int i;
  Verilated::commandArgs(argc, argv);

  Vtest_float_s* top = new Vtest_float_s;

  Verilated::traceEverOn(true);
  VerilatedVcdC* vcd = new VerilatedVcdC;
  top->trace (vcd, 99);
  vcd->open ("test_float_s.vcd");

  top->clock = 0;
  top->reset = 0;

  i = 0;
  while (1)
  {
    vcd->dump (i);
    top->reset = (i > 10);
    top->clock = !top->clock;
    top->eval ();
    if (Verilated::gotFinish())
    {
      exit(0);
    }
    i++;
    main_time++;
  }

  vcd->close();
  exit(0);
}
