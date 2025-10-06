# GFortran 15.2 C-binding argument-passing bug. 

This repo provides an example of an argument-passing but with gfortran. See in gfortran 15.2.0 on aarch64, and also a range of other systems and older gfortran versions, including gfortran 15.1.0


I have a C++ [function](https://gitlab.com/hoppet-code/libome-fork/-/blob/2025-10-gfortran-bug-report/src/ome/AqqQNSEven.cpp?ref_type=heads#L1335)

```c++
double ome_AqqQNSEven_reg_coeff_as(int order_as, double LM, double NF, double x)
```
with `extern "C"` binding. 

In [run_libome.f90](run_libome.f90?plain=1#L35) I call the function twice
```f90
      val1 = ome_AqqQNSEven_reg_coeff_as(iorder, LM, NF, x)
      val2 = ome_AqqQNSEven_reg_coeff_as(iorder, LM, NF, x)
```
The two return values should be identical, but instead come out different. The printout is

```
[debug] ome_AqqQNSEven_reg_coeff_as called: order_as=2 LM=10 NF=3 x=0.1 minp=2 maxp=3
[debug] ome_AqqQNSEven_reg_coeff_as returning: -148.752
[debug] ome_AqqQNSEven_reg_coeff_as called: order_as=1804198852 LM=-148.752 NF=2.2149e-10 x=0.5 minp=2 maxp=3
[debug] ome_AqqQNSEven_reg_coeff_as returning: 0
 mismatch between val1 and val2:   -148.75157177601164      /=   0.0000000000000000
```
with the last line showing the mismatch between `val1` and `val2`.
Inspecting the arguments seen by C++ it looks like the the return value from the first call (-148.752) is incorrectly being passed as the `LM` argument in the second call.

The arguments are passed by "value". The interface is defined at [run_libome.f90 line 9](run_libome.f90?plain=1#L9), which should match the C interface given above.
```f90
  abstract interface
    function ome_orderas_LM_NF_x(order_as, LM, NF, x) bind(C) result(res)
      import c_double, c_int
      integer(c_int), value, intent(in) :: order_as
      real(c_double), value, intent(in) :: LM, NF, x
      real(c_double) :: res
    end function
  end interface 
  procedure(ome_orderas_LM_NF_x),     bind(C, name="ome_AqqQNSEven_reg_coeff_as"  ) :: ome_AqqQNSEven_reg_coeff_as
```

Running through valgrind shows no errors, so it probably isn't the C++
code that is causing trouble. The example runs fine with ifx 2025.2.1 on
intel linux (with g++-11.4.0 for the C++) and flang 21.1.2 on mac (with
apple clang 17.0.0 for the C++ part).

## Reproducing the bug
To reproduce
```
git clone --recursive https://github.com/gavinsalam/gfortran-15.2-arg-issue.git
```

Build and run this on mac (using apple clang for C++) with
```
gfortran -c run_libome.f90 && c++ -std=c++17 -c libome-fork/src/ome/AqqQNSEven.cpp -I libome-fork/src/ && gfortran run_libome.o AqqQNSEven.o -o reproduce -lc++ && ./reproduce
```

Build and run this on linux (using gcc for C++)
```
gfortran -c run_libome.f90 && g++ -std=c++17 -c libome-fork/src/ome/AqqQNSEven.cpp -I libome-fork/src/ && gfortran run_libome.o AqqQNSEven.o -o reproduce -lstdc++ && ./reproduce
```