#include "defines.h"

module futils

#if defined(HAS_MPI)
  use mpi
#endif

  implicit none

  public :: check, report

contains

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
