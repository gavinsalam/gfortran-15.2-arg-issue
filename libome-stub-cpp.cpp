#include <iostream>

extern "C" {
double simple_function(int order_as, double LM, double NF, double x)
{
  // Debug: print incoming arguments and the available range
  std::cerr << "[debug] simple_function called: order_as=" << order_as
            << " LM=" << LM << " NF=" << NF << " x=" << x << std::endl;
  double val = static_cast<double>(order_as) + LM + NF + x;
  std::cerr << "[debug] simple_function returning: " << val << std::endl;
  return(val);
}
}
