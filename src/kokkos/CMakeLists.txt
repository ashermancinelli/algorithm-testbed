add_example(NAME "kokkos-dependency-check"
  DEPENDS_ON HAS_KOKKOS
  SRC kokkos-dependency-check.cpp
  LINK_LIBRARIES kokkos-tpl
  )
add_example(NAME "dice-histogram"
  DEPENDS_ON HAS_KOKKOS
  SRC dice-histogram
  LINK_LIBRARIES kokkos-tpl
  )
