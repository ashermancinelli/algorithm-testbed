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
add_example(NAME "ranges-examples"
  DEPENDS_ON HAS_HOST
  SRC ranges-examples.cpp
  LINK_LIBRARIES host-tpl
  )
