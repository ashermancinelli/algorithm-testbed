set(EXAMPLES
  lc-longest-valid-parens
  lc-valid-sudoku
  )

foreach(SRC ${EXAMPLES})
  add_executable(${SRC} ${SRC}.cu)
  message(STATUS "Adding Thrust example ${SRC}")
  install(TARGETS ${SRC} DESTINATION bin)
  add_test(NAME "test-${SRC}" COMMAND $<TARGET_FILE:${SRC}>)
endforeach()
