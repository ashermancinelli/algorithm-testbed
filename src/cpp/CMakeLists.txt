add_example(NAME "lc-valid-sudoku"
  SOURCES lc-valid-sudoku.cpp
  )
add_example(NAME "lc-valid-sudoku-mpi"
  DEPENDS HAS_MPI
  SOURCES lc-valid-sudoku-mpi.cpp
  LINK_LIBRARIES mpi-tpl
  )
add_example(NAME "ranges-examples"
  DEPENDS HAS_RANGEV3
  SOURCES ranges-examples.cpp
  LINK_LIBRARIES rangev3-tpl
  )
