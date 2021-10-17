if(HAS_PYTHON)
  example_str(NAME "lc-valid-sudoku-py" ENABLED)
  add_test(
    NAME "lc-valid-sudoku-py"
    COMMAND
    ${Python_EXECUTABLE}
    ${CMAKE_CURRENT_SOURCE_DIR}/lc-valid-sudoku.py
    )
else()
  example_str(NAME "lc-valid-sudoku-py")
endif()

if(HAS_PYTHON AND HAS_MPI)
  example_str(NAME "lc-valid-sudoku-mpi-py" ENABLED)
  foreach(nproc 1 2 4 6 8)
    add_test(
      NAME "lc-valid-sudoku-mpi-py-${nproc}proc"
      COMMAND
      ${MPIEXEC_EXECUTABLE}
      ${MPIEXEC_NUMPROC_FLAG}
      ${nproc}
      --hostfile
      ${PROJECT_SOURCE_DIR}/share/hostfile
      ${Python_EXECUTABLE}
      ${CMAKE_CURRENT_SOURCE_DIR}/lc-valid-sudoku-mpi.py
      )
  endforeach()
else()
  example_str(NAME "lc-valid-sudoku-mpi-py")
endif()
