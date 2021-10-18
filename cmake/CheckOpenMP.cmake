
set(HAS_OPENMP OFF)
find_package(OpenMP QUIET)
if(OpenMP_FOUND)
  set(HAS_OPENMP ON)
  message(STATUS "Found OpenMP")
  add_library(omp-tpl INTERFACE)
  target_link_libraries(omp-tpl INTERFACE OpenMP::OpenMP_CXX
                                          OpenMP::OpenMP_Fortran warnings)
else()
  message(STATUS "Could not find OpenMP")
endif()
