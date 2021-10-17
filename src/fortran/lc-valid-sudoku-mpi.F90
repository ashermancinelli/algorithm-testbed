
module sudoku

  !include 'mpif.h'
  use mpi
  implicit none

  integer, parameter :: shape = 9
  integer, parameter :: blksz = 3

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


contains

  pure function idx2(r, c)
    implicit none
    integer, intent(in) :: r, c
    integer :: idx2
    idx2 = ((r*shape)+c)
  end function

  pure function idx3(r, c, t)
    implicit none
    integer, intent(in) :: r, c, t
    integer :: idx3
    idx3 = ((r*shape+c)*3+t)
  end function

  ! "top-left"
  pure function tl(r)
    implicit none
    integer, intent(in) :: r
    integer :: tl
    tl = r - mod(r, blksz)
  end function

  ! "plus equals"
  subroutine pe(a, b)
    implicit none
    integer, intent(inout) :: a
    logical, intent(in) :: b
    if (b) a = a + 1
  end subroutine

  subroutine job(board, bits, row, col)
    implicit none
    integer, dimension(0:(shape*shape)-1), intent(in) :: board
    integer, dimension(shape * shape * 3), intent(inout) :: bits
    integer, intent(in) :: row, col
    integer :: v, i, j, dx, dy

    v = board(idx2(row, col))
    if (v .eq. 0) return
    j = 0
    do i = 0, shape-1
      if(v .eq. board(idx2(row, i))) then
        bits(1+idx3(row, col, j)) = bits(1+idx3(row, col, j)) + 1
      end if
    end do
    j = 1
    do i = 0, shape-1
      if (v .eq. board(idx2(i, col))) then
        bits(1+idx3(row, col, j)) = bits(1+idx3(row, col, j)) + 1
      end if
    end do
    j = 2
    do dx = 0, blksz-1
      do dy = 0, blksz-1
        if (v .eq. board(idx2(tl(row) + dy, tl(col) + dx))) then
          bits(1+idx3(row, col, j)) = bits(1+idx3(row, col, j)) + 1
        end if
      end do
    end do
  end subroutine job

  subroutine isgood(board, ret)
    implicit none
    integer, dimension(0:(shape*shape)-1), intent(in) :: board
    logical, intent(out) :: ret

    integer, dimension(shape * shape * 3) :: bits
    integer, dimension(shape * shape * 3) :: gbits
    integer, dimension(0:(shape * shape)-1) :: rows, cols
    integer :: v, row, col, i, chunk, rank, size, ierr

    bits = 0
    gbits = 0

    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    do row = 0, shape-1
      do col = 0, shape-1
        rows(idx2(row, col)) = row
        cols(idx2(row, col)) = col
      end do
    end do

    chunk = ((shape*shape) + size - 1) / size

    ! if(0 .eq. rank) print *, 'Chunk size:', chunk

    do i = rank*chunk, (rank*chunk)+chunk-1
      row = rows(i)
      col = cols(i)
      if (i .ge. (shape*shape)) exit
      call job(board, bits, row, col)
    end do
    
    call MPI_Reduce(bits, gbits, shape*shape, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD, ierr)

    if (0 .eq. rank) then
      v = maxval(bits) - 1
      ret = (v .lt. 1)
    else
      ret = .false.
    end if

  end subroutine isgood

end module sudoku

program main
  use sudoku
  use futils, only : check, report
  implicit none
  
  integer :: ierr, rank, size
  logical :: ret

  call MPI_Init(ierr)

  call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
  call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

  if (size .gt. 8) then
    if (0 .eq. rank) print *, 'World size greater than 8 is not supported'
    call MPI_Abort(MPI_COMM_WORLD, 1, ierr)
    stop 1
  end if
  if (0 .eq. rank) print *, "Running with world size of", size

  call isgood(good_online, ret)
  call report(ret)
  call check(ret, .true.)

  call isgood(good, ret)
  call report(ret)
  call check(ret, .true.)

  call isgood(bad_online, ret)
  call report(ret)
  call check(ret, .false.)

  call isgood(bad, ret)
  call report(ret)
  call check(ret, .false.)

  call MPI_Finalize(ierr)

end program
