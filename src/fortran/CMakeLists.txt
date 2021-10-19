add_library(sudoku-utils STATIC sudoku-utils.F90)
target_link_libraries(sudoku-utils PUBLIC mpi-tpl)

add_example(NAME "lc-valid-sudoku-ftn"
  DEPENDS HAS_FORTRAN
  LINK_LIBRARIES mpi-tpl sudoku-utils
  SOURCES lc-valid-sudoku.F90
  )
add_example(NAME "mpif-test"
  DEPENDS HAS_FORTRAN HAS_MPI HAS_MPIF
  LINK_LIBRARIES mpi-tpl sudoku-utils
  SOURCES mpif-test.F90
  )

add_example(NAME "lc-valid-sudoku-ftn-mpi"
  DEPENDS HAS_FORTRAN HAS_MPI HAS_MPIF
  LINK_LIBRARIES omp-tpl mpi-tpl sudoku-utils
  SOURCES lc-valid-sudoku-mpi.F90
  )

add_example(NAME "lc-peak-element-ftn"
  DEPENDS HAS_FORTRAN
  SOURCES lc-peak-element.f
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
