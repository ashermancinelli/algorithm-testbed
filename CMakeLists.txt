cmake_minimum_required (VERSION 3.18)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(bqn-raja-ex CXX)

message(STATUS "Enabling tests globally")
enable_testing()

include_directories(include)

set(HAS_RAJA OFF)
set(HAS_RAJA_CUDA OFF)
find_package(RAJA REQUIRED)
if(TARGET RAJA)
  message(STATUS "Found RAJA")
  set(HAS_RAJA ON)
  find_package(Threads REQUIRED)
  find_package(umpire REQUIRED)
  if(TARGET RAJA::cuda)
    set(HAS_RAJA_CUDA ON)
    message(STATUS "Found CUDA targets for RAJA")
    enable_language(CUDA)
    list(APPEND CMAKE_CUDA_FLAGS "--extended-lambda")
  else()
    message(STATUS "Could not find CUDA targets for RAJA")
  endif()

  add_library(raja-tpl INTERFACE)
  target_link_libraries(raja-tpl
    INTERFACE
    RAJA
    umpire
    Threads::Threads
    )
endif()

set(HAS_KOKKOS OFF)
find_package(Kokkos)
if(TARGET Kokkos::kokkos)
  set(HAS_KOKKOS ON)
  message(STATUS "Found Kokkos")
  add_library(kokkos-tpl INTERFACE)
  target_link_libraries(kokkos-tpl
    INTERFACE
    Kokkos::kokkos
    )
endif()

set(HAS_HOST OFF)
find_package(range-v3)
if(TARGET range-v3)
  set(HAS_HOST ON)
  add_library(host-tpl INTERFACE)
  target_link_libraries(host-tpl
    INTERFACE
    Threads::Threads
    ranges-v3
    )
endif()

add_subdirectory(src)
