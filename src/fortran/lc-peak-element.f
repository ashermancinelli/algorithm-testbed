
c     Comments require a 'c'in the first column, just like the
c     punchcards!
      program main
        integer :: ret
        integer :: i0(4)
        integer :: i1(7)

c       First Problem
        i0(1) = 1
        i0(2) = 2
        i0(3) = 3
        i0(4) = 1

c       Second Problem
        i1(1) = 1
        i1(2) = 2
        i1(3) = 1
        i1(4) = 2
        i1(5) = 4
        i1(6) = 2
        i1(7) = 1

        ret = -1

        call solve(i0, 4, ret)
        print*,ret

        call solve(i1, 7, ret)
        print*,ret

      end program

      subroutine solve(input, len, ret)
        integer :: input(len)
        integer :: len
        integer :: ret

        integer :: vals(len+2)
        integer :: i

        vals(1) = -99999
        vals(len) = -99999

        do i = 2, len
          vals(i) = input(i+1)
        end do

        do i = 2, len
          if (vals(i) > vals(i+1) .and. vals(i) > vals(i-1)) then
            ret = i-1
            return
          endif
        enddo

      end subroutine
