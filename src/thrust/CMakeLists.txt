add_example(NAME "lc-valid-sudoku-thrust"
  DEPENDS_ON HAS_THRUST
  SRC lc-valid-sudoku.cu
  LINK_LIBRARIES thrust-tpl
  )
add_example(NAME "lc-valid-sudoku-mpi-thrust"
  DEPENDS_ON HAS_THRUST HAS_MPI
  SRC lc-valid-sudoku-mpi.cu
  LINK_LIBRARIES thrust-tpl mpi-tpl
  )
add_example(NAME "lc-longest-valid-parens"
  DEPENDS_ON HAS_THRUST
  SRC lc-longest-valid-parens.cu
  LINK_LIBRARIES thrust-tpl
  )

if(HAS_MPI)
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
