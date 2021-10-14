add_example(NAME "lc-valid-sudoku"
  DEPENDS_ON HAS_HOST
  SRC lc-valid-sudoku.cpp
  LINK_LIBRARIES host-tpl
  )
add_example(NAME "lc-valid-sudoku-mpi"
  DEPENDS_ON HAS_HOST HAS_MPI
  SRC lc-valid-sudoku-mpi.cpp
  LINK_LIBRARIES host-tpl mpi-tpl
  )

add_example(NAME "lc-valid-sudoku-ftn"
  DEPENDS_ON HAS_HOST HAS_FORTRAN
  LINK_LIBRARIES mpi-tpl futils
  SRC lc-valid-sudoku.F90
  )
add_example(NAME "mpif-test"
  DEPENDS_ON HAS_HOST HAS_FORTRAN HAS_MPI HAS_MPIF
  LINK_LIBRARIES mpi-tpl futils
  SRC mpif-test.F90
  )

add_example(NAME "lc-valid-sudoku-ftn-mpi"
  DEPENDS_ON HAS_HOST HAS_FORTRAN HAS_MPI HAS_MPIF
  LINK_LIBRARIES omp-tpl mpi-tpl futils
  SRC lc-valid-sudoku-mpi.F90
  )

if(HAS_MPI AND HAS_MPIF)
  foreach(nproc 2 4 6 8)
    add_test(
      NAME "test-${nproc}proc-lc-valid-sudoku-ftn-mpi"
      COMMAND
      ${MPIEXEC_EXECUTABLE}
      ${MPIEXEC_NUMPROC_FLAG}
      ${nproc}
      --hostfile
      ${PROJECT_SOURCE_DIR}/share/hostfile
      $<TARGET_FILE:lc-valid-sudoku-ftn-mpi>
      )
  endforeach()
endif()

add_example(NAME "ranges-examples"
  DEPENDS_ON HAS_HOST
  SRC ranges-examples.cpp
  LINK_LIBRARIES host-tpl
  )
