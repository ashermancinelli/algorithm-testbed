cmake_minimum_required (VERSION 3.18)

project(portable-alg-testbed CXX)

include(cmake/GlobalVars.cmake)

include(cmake/FindAlgol68Compiler.cmake)

include(CheckLanguage)
check_language(Fortran)
set(HAS_FORTRAN OFF)
if(CMAKE_Fortran_COMPILER)
  set(HAS_FORTRAN ON)
  enable_language(Fortran)
  message(STATUS "Found Fortran compiler")
  set(CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/include)
else()
  message(STATUS "Could not find Fortran compiler")
endif()

set(HAS_MPI OFF)
set(HAS_MPIF OFF)
add_library(mpi-tpl INTERFACE)
find_package(MPI QUIET)
if(MPI_FOUND)
  message(STATUS "Found MPI")
  set(HAS_MPI ON)
  target_link_libraries(mpi-tpl INTERFACE MPI::MPI_CXX)
  if(MPI_Fortran_FOUND)
    set(HAS_MPIF ON)
    target_link_libraries(mpi-tpl INTERFACE MPI::MPI_Fortran)
  endif()
else()
  message(STATUS "No MPI provider could be found. "
    "MPI examples will not be built")
endif()

set(HAS_OPENMP OFF)
find_package(OpenMP QUIET)
if(OpenMP_FOUND)
  set(HAS_OPENMP ON)
  message(STATUS "Found OpenMP")
  add_library(omp-tpl INTERFACE)
  target_link_libraries(omp-tpl
    INTERFACE
    OpenMP::OpenMP_CXX
    OpenMP::OpenMP_Fortran
    warnings
    )
else()
  message(STATUS "Could not find OpenMP")
endif()

set(HAS_RAJA OFF)
set(HAS_RAJA_CUDA OFF)
find_package(RAJA QUIET)
if(TARGET RAJA)
  message(STATUS "Found RAJA")
  set(HAS_RAJA ON)
  add_library(raja-tpl INTERFACE)
  if(APPLE)
    set(CMAKE_THREAD_LIBS_INIT "-lpthread")
    set(CMAKE_HAVE_THREADS_LIBRARY 1)
    set(CMAKE_USE_WIN32_THREADS_INIT 0)
    set(CMAKE_USE_PTHREADS_INIT 1)
    set(THREADS_PREFER_PTHREAD_FLAG ON)
  else()
    find_package(Threads REQUIRED)
    target_link_libraries(raja-tpl INTERFACE Threads::Threads)
  endif()
  find_package(umpire REQUIRED)
  if(TARGET RAJA::cuda)
    set(HAS_RAJA_CUDA ON)
    message(STATUS "Found CUDA targets for RAJA")
    enable_language(CUDA)
  else()
    message(STATUS "Could not find CUDA targets for RAJA")
  endif()

  target_link_libraries(raja-tpl
    INTERFACE
    RAJA
    umpire
    mpi-tpl
    warnings
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
    mpi-tpl
    warnings
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
    mpi-tpl
    warnings
    )
else()
  message(STATUS "Could not find Thrust. "
    "Thrust examples will not be built.")
endif()

set(HAS_RANGEV3 OFF)
find_package(range-v3 QUIET)
if(TARGET range-v3)
  set(HAS_RANGEV3 ON)
  add_library(rangev3-tpl INTERFACE)
  target_link_libraries(rangev3-tpl
    INTERFACE
    range-v3
    mpi-tpl
    warnings
    )
else()
  message(STATUS "Could not find range-v3 library. "
    "Range v3 examples will not be built.")
endif()

set(HAS_PYTHON OFF)
find_package(Python COMPONENTS Interpreter QUIET)
if(TARGET Python::Interpreter
    AND ${Python_VERSION} VERSION_GREATER "3.4")
  message(STATUS "Found Python: ${Python_EXECUTABLE}")
  set(HAS_PYTHON ON)
else()
  message(STATUS "Python could not be found. "
    "Python examples will not be built")
endif()


add_subdirectory(include)

include(cmake/AddExample.cmake)
print_example_header()
add_subdirectory(src)

file(GLOB MODULE_FILES ${PROJECT_BINARY_DIR}/include/*.mod)
install(FILES ${MODULE_FILES} DESTINATION include)
