add_example(NAME "lc-valid-sudoku"
  SRC lc-valid-sudoku.cpp
  )
add_example(NAME "lc-valid-sudoku-mpi"
  DEPENDS_ON HAS_MPI
  SRC lc-valid-sudoku-mpi.cpp
  LINK_LIBRARIES mpi-tpl
  )
add_example(NAME "ranges-examples"
  DEPENDS_ON HAS_RANGEV3
  SRC ranges-examples.cpp
  LINK_LIBRARIES rangev3-tpl
  )
