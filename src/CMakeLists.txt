if(HAS_RAJA)
  add_subdirectory(raja)
endif()

if(HAS_HOST)
  add_subdirectory(host)
endif()

if(HAS_KOKKOS)
  add_subdirectory(kokkos)
endif()
