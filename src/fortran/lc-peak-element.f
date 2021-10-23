
c     Comments require a 'c'in the first column
      program main
        integer :: ret
        integer, dimension(4) :: i0 = (/1, 2, 3, 1/)
        integer, dimension(7) :: i1 = (/1,2,1,3,5,6,4/)
        ret = -1
        call solve(i0, size(i0), ret)
        print*,ret
        call solve(i1, size(i1), ret)
        print*,ret
      end program

      subroutine solve(input, len, ret)
        integer, intent(in) :: len
        integer, intent(out) :: ret
        integer, dimension(len) :: input

        integer :: i

        do i = 2, (len-1)
          if (input(i) > input(i+1) .and. input(i) > input(i-1)) then
            ret = i-1
            return
          endif
        enddo
      end subroutine
