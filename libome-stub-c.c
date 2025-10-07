#include <stdio.h>

double simple_function(int order_as, double LM, double NF, double x)
{
  // Debug: print incoming arguments and the available range
  printf("[debug] simple_function called: order_as=%d LM=%f NF=%f x=%f\n", order_as, LM, NF, x);
  double val = (double)order_as + LM + NF + x;
  printf("[debug] simple_function returning: %f\n", val);
  return(val);
}
