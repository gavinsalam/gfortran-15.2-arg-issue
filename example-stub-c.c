#include <stdio.h>

double simple_function(int iarg1, double arg2, double arg3, double arg4)
{
  // Debug: print incoming arguments and the available range
  printf("[debug] simple_function called: iarg1=%d arg2=%f arg3=%f arg4=%f\n", iarg1, arg2, arg3, arg4);
  double val = (double)iarg1 + arg2 + arg3 + arg4;
  printf("[debug] simple_function returning: %f\n", val);
  return(val);
}
