
# Keeping these variables separate in case we want to break this into multiple
# variables for rocthrust, thrust with omp, tbb, or whatever
set(HAS_THRUST OFF)
set(HAS_THRUST_CUDA OFF)
find_package(CUDAToolkit QUIET)
if(TARGET CUDA::cudart)
  enable_language(CUDA)
  set(HAS_THRUST ON)
  set(HAS_THRUST_CUDA ON)
  message(STATUS "Found Thrust")
  add_library(thrust-tpl INTERFACE)
  target_link_libraries(thrust-tpl INTERFACE CUDA::cudart mpi-tpl warnings)
else()
  message(STATUS "Could not find Thrust. " "Thrust examples will not be built.")
endif()
