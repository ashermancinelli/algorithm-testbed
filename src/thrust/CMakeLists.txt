add_example(NAME "lc-valid-sudoku-thrust"
  DEPENDS_ON HAS_THRUST
  SRC lc-valid-sudoku.cu
  LINK_LIBRARIES thrust-tpl
  )
add_example(NAME "lc-longest-valid-parens"
  DEPENDS_ON HAS_THRUST
  SRC lc-longest-valid-parens.cu
  LINK_LIBRARIES thrust-tpl
  )
