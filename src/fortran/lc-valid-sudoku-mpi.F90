
program main
   use mpi
   use sudoku_utils
   implicit none

   integer :: ierr, rank, size
   logical :: ret

   call MPI_Init(ierr)

   call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
   call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

   if (size .gt. 8) then
      if (0 .eq. rank) print *, &
         'World size greater than 8 is not supported'
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

subroutine isgood(board, ret)
   use sudoku_utils
   use mpi
   implicit none
   integer, dimension(shape*shape), intent(in) :: board
   logical, intent(out) :: ret
   integer, dimension(shape*shape*3) :: ar, gar
   integer, dimension(shape*shape) :: rows, cols
   integer :: v, row, col, i, chunk, rank, size, ierr

   ar = 0
   gar = 0

   call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
   call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

   do row = 0, shape - 1
      do col = 0, shape - 1
         rows(1 + idx2(row, col)) = row
         cols(1 + idx2(row, col)) = col
      end do
   end do

   chunk = ((shape*shape) + size - 1)/size

   do i = 1 + (rank*chunk), (rank*chunk) + chunk
      if (i .gt. (shape*shape)) exit
      row = rows(i)
      col = cols(i)
      v = board(1 + idx2(row, col))
      if (v .eq. 0) cycle
      ar(idx3(row, v - 1, 0) + 1) = ar(idx3(row, v - 1, 0) + 1) + 1
      ar(idx3(col, v - 1, 1) + 1) = ar(idx3(col, v - 1, 1) + 1) + 1
      ar(idx3(bi(row, col), v - 1, 2) + 1) = &
         ar(idx3(bi(row, col), v - 1, 2) + 1) + 1
   end do

   call MPI_Reduce(ar, gar, 3*shape*shape, &
                   MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD, ierr)
   call MPI_Barrier(MPI_COMM_WORLD, ierr)

   if (0 .eq. rank) then
      v = maxval(gar) - 1
      ret = (v .lt. 1)
   else
      ret = .false.
   end if

end subroutine isgood
