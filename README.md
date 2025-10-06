# GFortran 15.2 C-binding argument-passing bug. 

This repo provides an example of an argument-passing but with gfortran.
Seen in gfortran 15.2.0 on linux aarch64, and also a range of other
systems (intel and arm) and older gfortran versions.

This bug report has been prepared by Arnd Behring and Gavin Salam.

It has a C++ [function](libome-stub-cpp.cpp)

```c++
double ome_AqqQNSEven_reg_coeff_as(int order_as, double LM, double NF, double x)
```
with `extern "C"` binding. 

[run_libome.f90](run_libome.f90?plain=1#L35) calls the function twice
```f90
      val1 = ome_AqqQNSEven_reg_coeff_as(iorder, LM, NF, x)
      val2 = ome_AqqQNSEven_reg_coeff_as(iorder, LM, NF, x)
```
The two return values should be identical, but instead come out different. The printout is

```
[debug] ome_AqqQNSEven_reg_coeff_as called: order_as=2 LM=10 NF=3 x=0.1
[debug] ome_AqqQNSEven_reg_coeff_as returning: 15.1
[debug] ome_AqqQNSEven_reg_coeff_as called: order_as=1731463972 LM=15.1 NF=6.92383e-310 x=2.12196e-314
[debug] ome_AqqQNSEven_reg_coeff_as returning: 1.73146e+09
 mismatch between val1 and val2:    15.100000000000000      /=   1731463987.0999999      
```
with the last line showing the mismatch between `val1` and `val2`.
Inspecting the arguments seen by C++ it looks like the the return value from the first call (15.1) is incorrectly being passed as the `LM` argument in the second call.
In addition, the other arguments in the second call appear to contain contents of uninitialised memory (on some systems they change on every run of the executable).

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

Running through valgrind shows no errors, and it probably isn't the C++
code that is causing trouble. The example runs fine with ifx 2025.2.1 on
intel linux (with g++-11.4.0 for the C++) and flang 21.1.2 on mac (with
apple clang 17.0.0 for the C++ part).

## Reproducing the bug
To reproduce
```
git clone https://github.com/gavinsalam/gfortran-15.2-arg-issue.git
```

Build and run this on mac (using apple clang for C++) with
```
gfortran -c run_libome.f90 && c++ -std=c++17 -c libome-stub-cpp.cpp && gfortran run_libome.o libome-stub-cpp.o -o reproduce -lc++ && ./reproduce
```

Build and run this on linux (using gcc for C++)
```
gfortran -c run_libome.f90 && g++ -std=c++17 -c libome-stub-cpp.cpp && gfortran run_libome.o libome-stub-cpp.o -o reproduce -lstdc++ && ./reproduce
```

## Swapping C++ for C

The same behaviour also occurs if I swap out the C++ code for plain C code, see [libome-stub-c.c](libome-stub-c.c), compiled with GCC.
```
gfortran -c run_libome.f90 && gcc -c libome-stub-c.c && gfortran run_libome.o libome-stub-c.o -o reproduce-c && ./reproduce-c
```
