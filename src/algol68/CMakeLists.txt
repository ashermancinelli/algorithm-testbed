if(HAS_ALGOL68)
  add_test(
    NAME algol68-dependency-check
    COMMAND ${ALGOL68_COMPILER} ${CMAKE_CURRENT_SOURCE_DIR}/test.al
    )
  example_str(NAME "algol68-dependency-check" ENABLED)
else()
  example_str(NAME "algol68-dependency-check")
endif()
