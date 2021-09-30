cmake_minimum_required (VERSION 3.18)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(bqn-raja-ex CXX)

option(ENABLE_CUDA ON)

find_package(Threads REQUIRED)
find_package(RAJA REQUIRED)
find_package(umpire REQUIRED)

list(APPEND CMAKE_CUDA_FLAGS "--extended-lambda")

add_library(tpl INTERFACE)
target_link_libraries(tpl INTERFACE RAJA umpire Threads::Threads)

add_subdirectory(src)
