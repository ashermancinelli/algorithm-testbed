cmake_minimum_required (VERSION 3.18)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(bqn-raja-ex CXX)

message(STATUS "Enabling tests globally")
enable_testing()

# If cuda is enabled in any of the dependencies, we want extended lambda
list(APPEND CMAKE_CUDA_FLAGS "--extended-lambda")

include_directories(include)
include_directories(${PROJECT_BINARY_DIR}/include)

set(HAS_RAJA OFF)
set(HAS_RAJA_CUDA OFF)
find_package(RAJA QUIET)
if(TARGET RAJA)
  message(STATUS "Found RAJA")
  set(HAS_RAJA ON)
  find_package(Threads REQUIRED)
  find_package(umpire REQUIRED)
  if(TARGET RAJA::cuda)
    set(HAS_RAJA_CUDA ON)
    message(STATUS "Found CUDA targets for RAJA")
    enable_language(CUDA)
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
else()
  message(STATUS "Could not find RAJA. "
    "RAJA examples will not be built.")
endif()

set(HAS_KOKKOS OFF)
set(HAS_KOKKOS_CUDA OFF)
find_package(Kokkos QUIET)
if(TARGET Kokkos::kokkos)
  set(HAS_KOKKOS ON)
  message(STATUS "Found Kokkos")
  if(TARGET Kokkos::CUDA)
    set(HAS_KOKKOS_CUDA ON)
    message(STATUS "Found Kokkos CUDA")
  endif()
  add_library(kokkos-tpl INTERFACE)
  target_link_libraries(kokkos-tpl
    INTERFACE
    Kokkos::kokkos
    )
else()
  message(STATUS "Could not find Kokkos. "
    "Kokkos examples will not be built.")
endif()

# Keeping these variables separate in case we want to break this into
# multiple variables for rocthrust, thrust with omp, tbb, or whatever
set(HAS_THRUST OFF)
set(HAS_THRUST_CUDA OFF)
find_package(CUDAToolkit QUIET)
if(TARGET CUDA::cudart)
  enable_language(CUDA)
  set(HAS_THRUST ON)
  set(HAS_THRUST_CUDA ON)
  message(STATUS "Found Thrust")
  add_library(thrust-tpl INTERFACE)
  target_link_libraries(thrust-tpl
    INTERFACE
    CUDA::cudart
    )
else()
  message(STATUS "Could not find Thrust")
endif()

set(HAS_HOST OFF)
find_package(range-v3 QUIET)
if(TARGET range-v3)
  set(HAS_HOST ON)
  add_library(host-tpl INTERFACE)
  target_link_libraries(host-tpl
    INTERFACE
    Threads::Threads
    ranges-v3
    )
else()
  message(STATUS "Could not find range-v3 library. "
    "Host examples will not be built.")
endif()

configure_file(
  include/common-config.hpp.in
  ${PROJECT_BINARY_DIR}/include/common-config.hpp
  )
install(
  FILES
  ${PROJECT_BINARY_DIR}/include/common-config.hpp
  DESTINATION
  include
  )

add_subdirectory(src)
