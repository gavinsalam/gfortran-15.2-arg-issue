Build and run this on mac with

```
gfortran -c run_libome.f90 && c++ -std=c++17 -c libome-fork/src/ome/AqqQNSEven.cpp -I libome-fork/src/ && gfortran *.o -o reproduce -lc++ && ./reproduce
```

Build and run this on linux 


```
gfortran -c run_libome.f90 && g++ -std=c++17 -c libome-fork/src/ome/AqqQNSEven.cpp -I libome-fork/src/ && gfortran *.o -o reproduce -lstdc++ && ./reproduce
```