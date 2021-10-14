module valid_sudoku

  implicit none

  integer, parameter :: shape = 9
  integer, parameter :: blksz = 3

  public :: idx2, idx3, tl, isgood

contains

  pure function idx2(r, c)
    integer, intent(in) :: r, c
    integer :: idx2
    idx2 = ((r*shape)+c)
  end function

  pure function idx3(r, c, t)
    integer, intent(in) :: r, c, t
    integer :: idx3
    idx3 = ((r*shape+c)*3+t)
  end function

  ! "top-left"
  pure function tl(r)
    integer, intent(in) :: r
    integer :: tl
    tl = r - mod(r, blksz)
  end function

  ! "plus equals"
  subroutine pe(a, b)
    integer, intent(inout) :: a
    logical, intent(in) :: b
    if (b) a = a + 1
  end subroutine

  subroutine isgood(board, ret)
    integer, dimension(0:(shape*shape)-1), intent(in) :: board
    logical, intent(out) :: ret

    integer, dimension(0:(shape * shape * 3)-1) :: bits
    integer :: v, row, col, i, j, dx, dy

    bits = 0

    do row = 0, shape-1
      do col = 0, shape-1
        v = board(idx2(row, col))
        if (v .eq. 0) cycle
        j = 0
        do i = 0, shape-1
          call pe(bits(idx3(row, col, j)), (v .eq. board(idx2(row, i))))
        end do
        j = 1
        do i = 0, shape-1
          call pe(bits(idx3(row, col, j)), (v .eq. board(idx2(i, col))))
        end do
        j = 2
        do dx = 0, blksz-1
          do dy = 0, blksz-1
            call pe(bits(idx3(row, col, j)), (v .eq. board(idx2(tl(row) + dy, tl(col) + dx))))
          end do
        end do
      end do
    end do
    
    v = maxval(bits) - 1

    ret = (v .lt. 1)

  end subroutine isgood

end module valid_sudoku

program main
  use futils
  use valid_sudoku
  implicit none

  integer, dimension(0:80) :: good_online = (/2, 9, 4,  8, 6, 3,  5, 1, 7, &
                                              7, 1, 5,  4, 2, 9,  6, 3, 8, &
                                              8, 6, 3,  7, 5, 1,  4, 9, 2, &
                                              
                                              1, 5, 2,  9, 4, 7,  8, 6, 3, &
                                              4, 7, 9,  3, 8, 6,  2, 5, 1, &
                                              6, 3, 8,  5, 1, 2,  9, 7, 4, &

                                              9, 8, 6,  1, 3, 4,  7, 2, 5, &
                                              5, 2, 1,  6, 7, 8,  3, 4, 9, &
                                              3, 4, 7,  2, 9, 5,  1, 8, 6/)

  integer, dimension(0:80) :: bad_online = (/2, 9, 4,  8, 6, 3,  5, 1, 7, &
                                             7, 1, 5,  4, 2, 9,  6, 3, 8, &
                                             8, 6, 3,  7, 5, 1,  4, 9, 2, &

                                             1, 5, 2,  9, 4, 7,  8, 6, 3, &
                                             4, 7, 9,  3, 8, 6,  2, 5, 1, &
                                             6, 3, 8,  5, 1, 2,  9, 7, 4, &

                                             9, 8, 6,  1, 3, 4,  7, 2, 5, &
                                             5, 2, 1,  6, 7, 8,  3, 4, 9, &
                                             3, 1, 7,  2, 9, 5,  1, 8, 6/)

  integer, dimension(0:80) :: good = (/5, 3, 0,  0, 7, 0,  0, 0, 0, &
                                       6, 0, 0,  1, 9, 5,  0, 0, 0, &
                                       0, 9, 8,  0, 0, 0,  0, 6, 0, &
      
                                       8, 0, 0,  0, 6, 0,  0, 0, 3, &
                                       4, 0, 0,  8, 0, 3,  0, 0, 1, &
                                       7, 0, 0,  0, 2, 0,  0, 0, 6, &
      
                                       0, 6, 0,  0, 0, 0,  2, 8, 0, &
                                       0, 0, 0,  4, 1, 9,  0, 0, 5, &
                                       0, 0, 0,  0, 8, 0,  0, 7, 9/)

  integer, dimension(0:80) :: bad = (/8, 3, 0,  0, 7, 0,  0, 0, 0, &
                                      6, 0, 0,  1, 9, 5,  0, 0, 0, &
                                      0, 9, 8,  0, 0, 0,  0, 6, 0, &
                                      
                                      8, 0, 0,  0, 6, 0,  0, 0, 3, &
                                      4, 0, 0,  8, 0, 3,  0, 0, 1, &
                                      7, 0, 0,  0, 2, 0,  0, 0, 6, &
                                      
                                      0, 6, 0,  0, 0, 0,  2, 8, 0, &
                                      0, 0, 0,  4, 1, 9,  0, 0, 5, &
                                      0, 0, 0,  0, 8, 0,  0, 7, 9/)

  logical :: ret
  ret = .false.

  call isgood(good_online, ret)
  if (ret) then
    print *, "true"
  else
    print *, "false"
  end if

  call isgood(good, ret)
  if (ret) then
    print *, "true"
  else
    print *, "false"
  end if

  call isgood(bad_online, ret)
  if (ret) then
    print *, "true"
  else
    print *, "false"
  end if

  call isgood(bad, ret)
  if (ret) then
    print *, "true"
  else
    print *, "false"
  end if

end program main
