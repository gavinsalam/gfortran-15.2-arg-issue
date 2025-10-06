#include <stdio.h>

double ome_AqqQNSEven_reg_coeff_as(int order_as, double LM, double NF, double x)
{
  // Debug: print incoming arguments and the available range
  printf("[debug] ome_AqqQNSEven_reg_coeff_as called: order_as=%d LM=%f NF=%f x=%f\n", order_as, LM, NF, x);
  double val = (double)order_as + LM + NF + x;
  printf("[debug] ome_AqqQNSEven_reg_coeff_as returning: %f\n", val);
  return(val);
}
