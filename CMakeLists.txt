cmake_minimum_required (VERSION 3.18)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

project(bqn-raja-ex CXX CUDA)

find_package(Threads REQUIRED)
find_package(RAJA REQUIRED)
find_package(umpire REQUIRED)

add_library(tpl INTERFACE)
target_link_libraries(tpl INTERFACE RAJA umpire Threads::Threads)

add_subdirectory(src)
