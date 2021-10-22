macro(add_scheme_example)
  set(OPTIONS)
  set(SVARGS NAME)
  set(MVARGS SOURCES)
  cmake_parse_arguments(
    ADD_SCHEME_EXAMPLE "${OPTIONS}" "${SVARGS}" "${MVARGS}" ${ARGN}
  )

  list(LENGTH ADD_SCHEME_EXAMPLE_SOURCES len)
  if(${len} GREATER 1)
    message(FATAL_ERROR "I don't have a great way to build multi-source scheme "
                        "programs at the moment."
    )
  endif()

  list(TRANSFORM ADD_SCHEME_EXAMPLE_SOURCES
       PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/"
  )

  add_test(
    NAME "test-${ADD_SCHEME_EXAMPLE_NAME}"
    COMMAND ${SCHEME_EXE} < ${ADD_SCHEME_EXAMPLE_SOURCES}
    )
endmacro()
