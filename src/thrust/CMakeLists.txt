add_example(NAME "lc-valid-sudoku-thrust"
  DEPENDS HAS_THRUST
  SOURCES lc-valid-sudoku.cu
  LINK_LIBRARIES thrust-tpl
  )
add_example(NAME "lc-valid-sudoku-mpi-thrust"
  DEPENDS HAS_THRUST HAS_MPI
  SOURCES lc-valid-sudoku-mpi.cu
  LINK_LIBRARIES thrust-tpl mpi-tpl
  )
add_example(NAME "lc-longest-valid-parens"
  DEPENDS HAS_THRUST
  SOURCES lc-longest-valid-parens.cu
  LINK_LIBRARIES thrust-tpl
  )

if(HAS_MPI AND HAS_THRUST)
  foreach(nproc 2 4 6 8)
    add_test(
      NAME "test-${nproc}proc-lc-valid-sudoku-mpi-thrust"
      COMMAND
      ${MPIEXEC_EXECUTABLE}
      ${MPIEXEC_NUMPROC_FLAG}
      ${nproc}
      --hostfile
      ${PROJECT_SOURCE_DIR}/share/hostfile
      $<TARGET_FILE:lc-valid-sudoku-mpi-thrust>
      )
  endforeach()
endif()
