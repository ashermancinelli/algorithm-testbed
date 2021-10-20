set(HAS_SCHEME OFF)
find_program(SCHEME_EXE "scheme")
if(${SCHEME_EXE} STREQUAL "SCHEME_EXE-NOTFOUND")
  message(STATUS "No Scheme compiler could be found. "
                 "Scheme examples will not be built."
  )
else()
  set(HAS_SCHEME ON)
  message(STATUS "Found Scheme compiler: ${SCHEME_EXE}")
endif()

macro(add_scheme_executable)
  set(OPTIONS)
  set(SVARGS NAME)
  set(MVARGS SOURCES)
  cmake_parse_arguments(
    ADD_SCHEME_EXECUTABLE "${OPTIONS}" "${SVARGS}" "${MVARGS}" ${ARGN}
  )

  list(LENGTH ADD_SCHEME_EXECUTABLE_SOURCES len)
  if(${len} GREATER 1)
    message(FATAL_ERROR "I don't have a great way to build multi-source scheme "
                        "programs at the moment."
    )
  endif()

  list(TRANSFORM ADD_SCHEME_EXECUTABLE_SOURCES
       PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/"
  )

  add_custom_target(
    ${ADD_SCHEME_EXECUTABLE_NAME} ALL
    DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${ADD_SCHEME_EXECUTABLE_NAME}"
  )

  add_custom_command(
    COMMENT "Building SCHEME target ${ADD_SCHEME_EXECUTABLE_NAME}"
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${ADD_SCHEME_EXECUTABLE_NAME}
    COMMAND ${SCHEME_EXE} ${ADD_SCHEME_EXECUTABLE_SOURCES} -x
            ${CMAKE_CURRENT_BINARY_DIR}/${ADD_SCHEME_EXECUTABLE_NAME}
  )
endmacro()
