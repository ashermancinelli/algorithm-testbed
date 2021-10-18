set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CUDA_STANDARD 14)
set(CMAKE_CUDA_STANDARD_REQUIRED TRUE)

message(STATUS "Enabling tests globally")
enable_testing()

# Workaround for gcc8 and cuda10
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU"
    AND "${CMAKE_CXX_COMPILER_VERSION}" VERSION_GREATER_EQUAL "8.0.0"
    AND "${CMAKE_CXX_COMPILER_VERSION}" VERSION_LESS "9.0.0")
  message(STATUS "Applying workaround for GCC and CUDA 10 ieee")
  set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -Xcompiler -mno-float128")
endif()

if("${CMAKE_CUDA_ARCHITECTURES}" STREQUAL "")
  set(CA 60)
  message(STATUS "Defaulting CUDA architectures to ${CA}")
  set(CMAKE_CUDA_ARCHITECTURES ${CA} CACHE STRING "")
endif()

# If cuda is enabled in any of the dependencies, we want extended lambda
set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} --extended-lambda --expt-relaxed-constexpr")

add_library(warnings INTERFACE)
target_compile_options(warnings INTERFACE
  -Wall
  -Wextra
  )

include_directories(include)
include_directories(${PROJECT_BINARY_DIR}/include)
