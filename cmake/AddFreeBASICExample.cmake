macro(add_freebasic_example)
  set(OPTIONS)
  set(SVARGS NAME)
  set(MVARGS SOURCES)
  cmake_parse_arguments(
    ADD_FREEBASIC_EXAMPLE "${OPTIONS}" "${SVARGS}" "${MVARGS}" ${ARGN}
  )

  list(LENGTH ADD_FREEBASIC_EXAMPLE_SOURCES len)
  if(${len} GREATER 1)
    message(FATAL_ERROR "I don't have a great way to build multi-source freebasic "
                        "programs at the moment."
    )
  endif()

  list(TRANSFORM ADD_FREEBASIC_EXAMPLE_SOURCES
       PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/"
  )

  # For some reason I can't specify the output file with the `-o <file>` option
  # when invoking fbc so I have to copy the file to the new location after
  # building with the default output name
  string(REGEX REPLACE "\\.[^.]*$" "" INTERMEDIATE_PATH ${ADD_FREEBASIC_EXAMPLE_SOURCES})
  set(FINAL_PATH ${CMAKE_CURRENT_BINARY_DIR}/${ADD_FREEBASIC_EXAMPLE_NAME})

  add_custom_target(
    ${ADD_FREEBASIC_EXAMPLE_NAME} ALL
    DEPENDS ${FINAL_PATH}
  )

  add_custom_command(
    COMMENT "Building FreeBASIC target ${ADD_FREEBASIC_EXAMPLE_NAME}"
    OUTPUT ${INTERMEDIATE_PATH}
    DEPENDS ${ADD_FREEBASIC_EXAMPLE_SOURCES}
    COMMAND ${FBC_EXE} -lang fb ${ADD_FREEBASIC_EXAMPLE_SOURCES}
  )

  add_custom_command(
    COMMENT "Moving FreeBASIC target to ${ADD_FREEBASIC_EXAMPLE_NAME} build directory"
    OUTPUT ${FINAL_PATH}
    DEPENDS ${INTERMEDIATE_PATH} ${ADD_FREEBASIC_EXAMPLE_SOURCES}
    COMMAND ${CMAKE_COMMAND} -E touch ${FINAL_PATH}
    COMMAND ${CMAKE_COMMAND} -E rm -f ${FINAL_PATH}
    COMMAND ${CMAKE_COMMAND} -E copy ${INTERMEDIATE_PATH} ${FINAL_PATH}
    COMMAND ${CMAKE_COMMAND} -E rm -f ${INTERMEDIATE_PATH}
    )
endmacro()
