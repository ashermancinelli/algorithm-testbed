add_example(NAME "kokkos-dependency-check"
  DEPENDS HAS_KOKKOS
  SOURCES kokkos-dependency-check.cpp
  LINK_LIBRARIES kokkos-tpl
  )
add_example(NAME "dice-histogram"
  DEPENDS HAS_KOKKOS
  SOURCES dice-histogram
  LINK_LIBRARIES kokkos-tpl
  )
