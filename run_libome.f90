module test_libome
  use, intrinsic :: iso_c_binding
  implicit none


  integer, parameter  :: dp = kind(1.0d0)

  abstract interface
    function ome_orderas_LM_NF_x(order_as, LM, NF, x) bind(C) result(res)
      import c_double, c_int
      integer(c_int), value, intent(in) :: order_as
      real(c_double), value, intent(in) :: LM, NF, x
      real(c_double) :: res
    end function
  end interface 

  procedure(ome_orderas_LM_NF_x),     bind(C, name="ome_AqqQNSEven_reg_coeff_as"  ) :: ome_AqqQNSEven_reg_coeff_as

contains
  subroutine test_libome_interface
    implicit none
    real(c_double) :: as4pi, LM, NF, x
    character(len=*), parameter :: red=char(27)//"[31m", reset=char(27)//"[0m"
    integer(c_int) :: iorder
    real(c_double) :: val1, val2

    ! Example values for testing
    as4pi = 0.1_dp
    LM    = 10._dp
    NF    = 3.0_dp
    x     = 0.1_dp

    ! request coefficients relative to min_power (0 -> first non-zero term)
    iorder = 2
    val1 = ome_AqqQNSEven_reg_coeff_as(iorder, LM, NF, x)
    val2 = ome_AqqQNSEven_reg_coeff_as(iorder, LM, NF, x)
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