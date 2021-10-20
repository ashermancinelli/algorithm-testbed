program main
   implicit none
   include 'mpif.h'
   integer :: ierr, rank, size
   call mpi_init(ierr)
   call mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)
   call mpi_comm_size(MPI_COMM_WORLD, size, ierr)
   print *, "(size, rank) = (", size, ", ", rank, ")"
   call mpi_finalize(ierr)
end program
