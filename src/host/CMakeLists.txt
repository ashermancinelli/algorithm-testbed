set(EXAMPLES
  )

foreach(SRC ${EXAMPLES})
  message(STATUS "Adding host example: ${SRC}")
  add_executable(${SRC} ${SRC}.cpp)
  target_link_libraries(${SRC} PUBLIC host-tpl)
  install(TARGETS ${SRC} RUNTIME DESTINATION bin)
  add_test(NAME "TEST_${SRC}" COMMAND $<TARGET_FILE:${SRC}>)
endforeach()
