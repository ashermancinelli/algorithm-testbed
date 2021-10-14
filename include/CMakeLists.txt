
configure_file(
  defines.h.in
  ${PROJECT_BINARY_DIR}/include/defines.h
  )
install(
  FILES
  ${PROJECT_BINARY_DIR}/include/defines.h
  DESTINATION
  include
  )

install(
  FILES
  common-config.hpp futils.F90 host-config.hpp kokkos-config.hpp raja-config.hpp thrust-config.hpp
  DESTINATION
  include
  )

if(HAS_FORTRAN)
  add_library(futils STATIC)
  target_sources(futils PUBLIC futils.F90)
  target_link_libraries(futils PUBLIC mpi-tpl)
  install(
    TARGETS
    futils
    DESTINATION
    lib
    )
endif()
