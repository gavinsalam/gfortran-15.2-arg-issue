#include <iostream>

extern "C" {
double ome_AqqQNSEven_reg_coeff_as(int order_as, double LM, double NF, double x)
{
  // Debug: print incoming arguments and the available range
  std::cerr << "[debug] ome_AqqQNSEven_reg_coeff_as called: order_as=" << order_as
            << " LM=" << LM << " NF=" << NF << " x=" << x << std::endl;
  double val = static_cast<double>(order_as) + LM + NF + x;
  std::cerr << "[debug] ome_AqqQNSEven_reg_coeff_as returning: " << val << std::endl;
  return(val);
}
}
