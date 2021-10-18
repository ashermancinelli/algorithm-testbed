#include "defines.h"

module sudoku_utils

#if defined(HAS_MPI)
  use mpi
#endif

  implicit none

  integer, parameter :: shape = 9
  integer, parameter :: blksz = 3

  integer, dimension(0:80) :: good_online = (/ &
    2, 9, 4,  8, 6, 3,  5, 1, 7, &
    7, 1, 5,  4, 2, 9,  6, 3, 8, &
    8, 6, 3,  7, 5, 1,  4, 9, 2, &
    
    1, 5, 2,  9, 4, 7,  8, 6, 3, &
    4, 7, 9,  3, 8, 6,  2, 5, 1, &
    6, 3, 8,  5, 1, 2,  9, 7, 4, &

    9, 8, 6,  1, 3, 4,  7, 2, 5, &
    5, 2, 1,  6, 7, 8,  3, 4, 9, &
    3, 4, 7,  2, 9, 5,  1, 8, 6  &
    /)

  integer, dimension(0:80) :: bad_online = (/ &
    2, 9, 4,  8, 6, 3,  5, 1, 7, &
    7, 1, 5,  4, 2, 9,  6, 3, 8, &
    8, 6, 3,  7, 5, 1,  4, 9, 2, &

    1, 5, 2,  9, 4, 7,  8, 6, 3, &
    4, 7, 9,  3, 8, 6,  2, 5, 1, &
    6, 3, 8,  5, 1, 2,  9, 7, 4, &

    9, 8, 6,  1, 3, 4,  7, 2, 5, &
    5, 2, 1,  6, 7, 8,  3, 4, 9, &
    3, 1, 7,  2, 9, 5,  1, 8, 6  &
    /)

  integer, dimension(0:80) :: good = (/ &
    5, 3, 0,  0, 7, 0,  0, 0, 0, &
    6, 0, 0,  1, 9, 5,  0, 0, 0, &
    0, 9, 8,  0, 0, 0,  0, 6, 0, &
    
    8, 0, 0,  0, 6, 0,  0, 0, 3, &
    4, 0, 0,  8, 0, 3,  0, 0, 1, &
    7, 0, 0,  0, 2, 0,  0, 0, 6, &
    
    0, 6, 0,  0, 0, 0,  2, 8, 0, &
    0, 0, 0,  4, 1, 9,  0, 0, 5, &
    0, 0, 0,  0, 8, 0,  0, 7, 9  &
    /)

  integer, dimension(0:80) :: bad = (/ &
    8, 3, 0,  0, 7, 0,  0, 0, 0, &
    6, 0, 0,  1, 9, 5,  0, 0, 0, &
    0, 9, 8,  0, 0, 0,  0, 6, 0, &
    
    8, 0, 0,  0, 6, 0,  0, 0, 3, &
    4, 0, 0,  8, 0, 3,  0, 0, 1, &
    7, 0, 0,  0, 2, 0,  0, 0, 6, &
    
    0, 6, 0,  0, 0, 0,  2, 8, 0, &
    0, 0, 0,  4, 1, 9,  0, 0, 5, &
    0, 0, 0,  0, 8, 0,  0, 7, 9  &
    /)

  public :: check, report, idx2, idx3, tl, bi

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

  pure function tl(r)
    integer, intent(in) :: r
    integer :: tl
    tl = r - mod(r, blksz)
  end function

  pure function bi(r, c)
    integer, intent(in) :: r, c
    integer :: bi
    bi = (r / blksz) * blksz + (c / blksz)
  end function

  subroutine check(a, b)
    logical, intent(in) :: a, b
#if defined(HAS_MPI)
    integer :: ierr, rank, ec
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    if (0 .ne. rank) then
      return
    endif
#endif
    if (a .neqv. b) then
      print *, 'Failure observed!', a, b
#if defined(HAS_MPI)
      ec = 1
      call MPI_Abort(MPI_COMM_WORLD, ec, ierr)
#endif
      stop 1
    end if
  end subroutine

  subroutine report(ret)
    implicit none
    logical, intent(in) :: ret

#if defined(HAS_MPI)
    integer :: rank, ierr
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    if (0 .ne. rank) return
#endif

    print *, ret
  end subroutine

end module
