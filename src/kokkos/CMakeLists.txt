set(EXAMPLES
  kokkos-dependency-check
  dice-histogram
  )

foreach(SRC ${EXAMPLES})
  message(STATUS "Adding Kokkos example: ${SRC}")
  add_executable(${SRC} ${SRC}.cpp)
  target_link_libraries(${SRC} PUBLIC kokkos-tpl)
  install(TARGETS ${SRC} RUNTIME DESTINATION bin)

  if(HAS_KOKKOS_CUDA)
    set(KOKKOS_TEST_COMMAND " \
      CUDA_MANAGED_FORCE_DEVICE_ALLOC=1 \
      CUDA_LAUNCH_BLOCKING=1 \
      $<TARGET_FILE:${SRC}> \
      ")
  else()
    set(KOKKOS_TEST_COMMAND $<TARGET_FILE:${SRC}>)
  endif()

  add_test(
    NAME "test-${SRC}"
    COMMAND bash -c ${KOKKOS_TEST_COMMAND}
    )
endforeach()
