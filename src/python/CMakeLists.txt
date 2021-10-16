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
  add_test(
    NAME "lc-valid-sudoku-mpi-py"
    COMMAND
    ${Python_EXECUTABLE}
    ${CMAKE_CURRENT_SOURCE_DIR}/lc-valid-sudoku-mpi.py
    )
else()
  example_str(NAME "lc-valid-sudoku-mpi-py")
endif()
