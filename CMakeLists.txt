cmake_minimum_required (VERSION 3.18)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(bqn-raja-ex CXX)

set(HAS_CUDA OFF)

find_package(Threads REQUIRED)
find_package(RAJA REQUIRED)
find_package(umpire REQUIRED)
find_package(range-v3 REQUIRED)

if(TARGET RAJA::cuda)
  message(STATUS "Found CUDA")
  set(HAS_CUDA ON)
  enable_language(CUDA)
  list(APPEND CMAKE_CUDA_FLAGS "--extended-lambda")
endif()

add_library(tpl INTERFACE)
target_link_libraries(tpl
  INTERFACE
  RAJA
  umpire
  Threads::Threads
  range-v3
  )

add_subdirectory(src)
