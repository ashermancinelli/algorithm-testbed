if(HAS_ALGOL68)
  add_test(
    NAME algol68-dependency-check
    COMMAND ${ALGOL68_COMPILER} ${CMAKE_CURRENT_SOURCE_DIR}/test.al
    )
  example_str(NAME "algol68-dependency-check" ENABLED)
  add_test(
    NAME lc-peak-element-algol68
    COMMAND ${ALGOL68_COMPILER} ${CMAKE_CURRENT_SOURCE_DIR}/lc-peak-element.a68
    )
  example_str(NAME "lc-peak-element-algol68" ENABLED)
else()
  example_str(NAME "lc-peak-element-algol68")
  example_str(NAME "algol68-dependency-check")
endif()
