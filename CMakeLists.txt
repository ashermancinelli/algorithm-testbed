cmake_minimum_required(VERSION 3.18)

project(portable-alg-testbed CXX)

include(cmake/GlobalVars.cmake)
include(cmake/Linters.cmake)

include(cmake/CheckAlgol68.cmake)
include(cmake/CheckFortran.cmake)
include(cmake/CheckMPI.cmake)
include(cmake/CheckOpenMP.cmake)
include(cmake/CheckRAJA.cmake)
include(cmake/CheckKokkos.cmake)
include(cmake/CheckRangeV3.cmake)
include(cmake/CheckPython.cmake)
include(cmake/CheckThrust.cmake)
include(cmake/CheckCobol.cmake)

add_subdirectory(include)

include(cmake/AddExample.cmake)
print_example_header()
add_subdirectory(src)
