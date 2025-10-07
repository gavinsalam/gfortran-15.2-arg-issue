# GFortran 15.2 C-binding argument-passing bug. 

This repo provides an example of an argument-passing but with gfortran.
Seen in gfortran 15.2.0 on linux aarch64, and also a range of other
systems (intel and arm) and older gfortran versions.

This bug report has been prepared by Arnd Behring and Gavin Salam.

It has a C++ [function](example-stub-cpp.cpp)

```c++
double simple_function(int iarg1, double arg2, double arg3, double arg4)
```
with `extern "C"` binding. 

[run_example.f90](run_example.f90?plain=1#L35) calls the function twice
```f90
      val1 = simple_function(iarg1, arg2, arg3, arg4)
      val2 = simple_function(iarg1, arg2, arg3, arg4)
```
The two return values should be identical, but instead come out different. The printout is

```
[debug] simple_function called: iarg1=2 arg2=10 arg3=3 arg4=0.1
[debug] simple_function returning: 15.1
[debug] simple_function called: iarg1=1731463972 arg2=15.1 arg3=6.92383e-310 arg4=2.12196e-314
[debug] simple_function returning: 1.73146e+09
 mismatch between val1 and val2:    15.100000000000000      /=   1731463987.0999999      
```
with the last line showing the mismatch between `val1` and `val2`.
Inspecting the arguments seen by C++ it looks like the the return value from the first call (15.1) is incorrectly being passed as the `arg2` argument in the second call.
In addition, the other arguments in the second call appear to contain contents of uninitialised memory (on some systems they change on every run of the earg4ecutable).

The arguments are passed by "value". The interface is defined at [run_example.f90 line 9](run_example.f90?plain=1#L9), which should match the C interface given above.
```f90
  abstract interface
    function simple_interface(iarg1, arg2, arg3, arg4) bind(C) result(res)
      import c_double, c_int
      integer(c_int), value, intent(in) :: iarg1
      real(c_double), value, intent(in) :: arg2, arg3, arg4
      real(c_double) :: res
    end function
  end interface 
  procedure(simple_interface),     bind(C, name="simple_function"  ) :: simple_function
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
gfortran -c run_example.f90 && c++ -std=c++17 -c example-stub-cpp.cpp && gfortran run_example.o example-stub-cpp.o -o reproduce -lc++ && ./reproduce
```

Build and run this on linux (using gcc for C++)
```
gfortran -c run_example.f90 && g++ -std=c++17 -c example-stub-cpp.cpp && gfortran run_example.o example-stub-cpp.o -o reproduce -lstdc++ && ./reproduce
```

## Swapping C++ for C

The same behaviour also occurs if I swap out the C++ code for plain C code, see [example-stub-c.c](example-stub-c.c), compiled with GCC.
```
gfortran -c run_example.f90 && gcc -c example-stub-c.c && gfortran run_example.o example-stub-c.o -o reproduce-c && ./reproduce-c
```
