if(HAS_ALGOL68)
  add_test(
    NAME algol68-dependency-check
    COMMAND ${ALGOL68_COMPILER} test.al
    )
  message(STATUS "   + algol68-dependency-check")
else()
  message(STATUS "   ~ algol68-dependency-check")
endif()
