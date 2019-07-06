#include "Vtest_lzc.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env)
{
  int i;
  Verilated::commandArgs(argc, argv);
  
  Vtest_lzc* top = new Vtest_lzc;
  
  Verilated::traceEverOn(true);
  VerilatedVcdC* vcd = new VerilatedVcdC;
  top->trace (vcd, 99);
  vcd->open ("test_lzc.vcd");
  
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
  }
  
  vcd->close();
  exit(0);
}