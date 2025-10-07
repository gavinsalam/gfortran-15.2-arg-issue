module test_libome
  use, intrinsic :: iso_c_binding
  implicit none


  integer, parameter  :: dp = kind(1.0d0)

  abstract interface
    function simple_interface(iarg1, arg2, arg3, arg4) bind(C) result(res)
      import c_double, c_int
      integer(c_int), value, intent(in) :: iarg1
      real(c_double), value, intent(in) :: arg2, arg3, arg4
      real(c_double) :: res
    end function
  end interface 

  procedure(simple_interface),     bind(C, name="simple_function"  ) :: simple_function    

contains
  subroutine test_libome_interface
    implicit none
    real(c_double) :: arg2, arg3, arg4
    character(len=*), parameter :: red=char(27)//"[31m", reset=char(27)//"[0m"
    integer(c_int) :: iarg1
    real(c_double) :: val1, val2

    ! Example values for testing
    arg2    = 10._dp
    arg3    = 3.0_dp
    arg4     = 0.1_dp

    ! request coefficients relative to min_power (0 -> first non-zero term)
    iarg1 = 2
    val1 = simple_function(iarg1, arg2, arg3, arg4)
    val2 = simple_function(iarg1, arg2, arg3, arg4)
    if (val1 /= val2) then
      print *, red//"mismatch between val1 and val2: ", val1, "/=", val2,reset
    end if

  end subroutine test_libome_interface    
end module test_libome

program tester
  use test_libome
  implicit none

  call test_libome_interface()

end program tester