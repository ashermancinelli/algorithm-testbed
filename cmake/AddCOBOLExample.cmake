macro(add_cobol_example)
  set(OPTIONS)
  set(SVARGS NAME)
  set(MVARGS SOURCES)
  cmake_parse_arguments(
    ADD_COBOL_EXAMPLE "${OPTIONS}" "${SVARGS}" "${MVARGS}" ${ARGN}
  )

  list(LENGTH ADD_COBOL_EXAMPLE_SOURCES len)
  if(${len} GREATER 1)
    message(FATAL_ERROR "I don't have a great way to build multi-source cobol "
                        "programs at the moment."
    )
  endif()

  list(TRANSFORM ADD_COBOL_EXAMPLE_SOURCES
       PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/"
  )

  add_custom_target(
    ${ADD_COBOL_EXAMPLE_NAME} ALL
    DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${ADD_COBOL_EXAMPLE_NAME}"
  )

  add_custom_command(
    COMMENT "Building COBOL target ${ADD_COBOL_EXAMPLE_NAME}"
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${ADD_COBOL_EXAMPLE_NAME}
    DEPENDS ${ADD_COBOL_EXAMPLE_SOURCES}
    COMMAND ${COBC_EXE} -x ${ADD_COBOL_EXAMPLE_SOURCES} -o
    ${CMAKE_CURRENT_BINARY_DIR}/${ADD_COBOL_EXAMPLE_NAME}
    -Wall -Wextra -Wno-dialect
  )
endmacro()
