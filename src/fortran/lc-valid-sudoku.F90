
program main
   use sudoku_utils
   implicit none

   logical :: ret
   ret = .false.

   call isgood(good_online, ret)
   print *, ret

   call isgood(good, ret)
   print *, ret

   call isgood(bad_online, ret)
   print *, ret

   call isgood(bad, ret)
   print *, ret

end program main

subroutine isgood(board, ret)
   use sudoku_utils
   implicit none
   integer, dimension(0:(shape*shape) - 1), intent(in) :: board
   logical, intent(out) :: ret

   integer, dimension(0:(shape*shape*3) - 1) :: ar
   integer :: v, row, col, i, bx, by

   ar = 0

   do row = 0, shape - 1
      do col = 0, shape - 1
         v = board(idx2(row, col))
         if (v .eq. 0) cycle
         ar(idx3(row, v - 1, 0)) = ar(idx3(row, v - 1, 0)) + 1
         ar(idx3(col, v - 1, 1)) = ar(idx3(col, v - 1, 1)) + 1
         ar(idx3(bi(row, col), v - 1, 2)) = ar(idx3(bi(row, col), v - 1, 2)) + 1
      end do
   end do

   v = maxval(ar) - 1

   ret = (v .lt. 1)

end subroutine isgood
