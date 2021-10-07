set(EXAMPLES
  kokkos-dependency-check
  dice-histogram
  )

foreach(SRC ${EXAMPLES})
  message(STATUS "Adding Kokkos example: ${SRC}")
  add_executable(${SRC} ${SRC}.cpp)
  target_link_libraries(${SRC} PUBLIC kokkos-tpl)
  install(TARGETS ${SRC} RUNTIME DESTINATION bin)
  add_test(NAME "TEST_${SRC}" COMMAND $<TARGET_FILE:${SRC}>)
endforeach()
