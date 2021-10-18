
set(HAS_COBOL OFF)
find_program(COBC_EXE "cobc")
if(${COBC_EXE} STREQUAL "COBC_EXE-NOTFOUND")
  message(STATUS "No Cobol compiler could be found. "
    "Cobol examples will not be built.")
else()
  set(HAS_COBOL ON)
endif()

macro(add_cobol_executable)
  set(OPTIONS )
  set(SVARGS NAME)
  set(MVARGS SOURCES)
  cmake_parse_arguments(ADD_COBOL_EXECUTABLE
    "${OPTIONS}"
    "${SVARGS}"
    "${MVARGS}"
    ${ARGN}
    )

  list(LENGTH ADD_COBOL_EXECUTABLE_SOURCES len)
  if(${len} GREATER 1)
    message(FATAL_ERROR "I don't have a great way to build multi-source cobol "
      "programs at the moment.")
  endif()

  list(
    TRANSFORM ADD_COBOL_EXECUTABLE_SOURCES
    PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/"
    )

  add_custom_target(${ADD_COBOL_EXECUTABLE_NAME} ALL
    DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${ADD_COBOL_EXECUTABLE_NAME}"
    )

  add_custom_command(
    COMMENT "Building COBOL target ${ADD_COBOL_EXECUTABLE_NAME}"
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${ADD_COBOL_EXECUTABLE_NAME}
    COMMAND
    ${COBC_EXE} -x ${ADD_COBOL_EXECUTABLE_SOURCES}
    -o ${CMAKE_CURRENT_BINARY_DIR}/${ADD_COBOL_EXECUTABLE_NAME}
    )
endmacro()
