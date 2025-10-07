#include <iostream>

extern "C" {
double simple_function(int iarg1, double arg2, double arg3, double arg4)
{
  // Debug: print incoming arguments and the available range
  std::cerr << "[debug] simple_function called: iarg1=" << iarg1
            << " arg2=" << arg2 << " arg3=" << arg3 << " arg4=" << arg4 << std::endl;
  double val = static_cast<double>(iarg1) + arg2 + arg3 + arg4;
  std::cerr << "[debug] simple_function returning: " << val << std::endl;
  return(val);
}
}
