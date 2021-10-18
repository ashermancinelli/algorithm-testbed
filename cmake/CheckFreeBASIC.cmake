
set(HAS_FREEBASIC OFF)
find_program(FBC_EXE "fbc")
if(${FBC_EXE} STREQUAL "FBC_EXE-NOTFOUND")
  message(STATUS "No FreeBASIC compiler could be found. "
    "FreeBASIC examples will not be built.")
else()
  set(HAS_FREEBASIC ON)
  message(STATUS "Found FreeBASIC compiler: ${FBC_EXE}")
endif()

macro(add_freebasic_executable)
  set(OPTIONS )
  set(SVARGS NAME)
  set(MVARGS SOURCES)
  cmake_parse_arguments(ADD_FREEBASIC_EXECUTABLE
    "${OPTIONS}"
    "${SVARGS}"
    "${MVARGS}"
    ${ARGN}
    )

  list(LENGTH ADD_FREEBASIC_EXECUTABLE_SOURCES len)
  if(${len} GREATER 1)
    message(FATAL_ERROR "I don't have a great way to build multi-source freebasic "
      "programs at the moment.")
  endif()

  list(
    TRANSFORM ADD_FREEBASIC_EXECUTABLE_SOURCES
    PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/"
    )

  add_custom_target(${ADD_FREEBASIC_EXECUTABLE_NAME} ALL
    DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${ADD_FREEBASIC_EXECUTABLE_NAME}"
    )

  add_custom_command(
    COMMENT "Building FREEBASIC target ${ADD_FREEBASIC_EXECUTABLE_NAME}"
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${ADD_FREEBASIC_EXECUTABLE_NAME}
    COMMAND
    ${FBC_EXE} ${ADD_FREEBASIC_EXECUTABLE_SOURCES}
    -x ${CMAKE_CURRENT_BINARY_DIR}/${ADD_FREEBASIC_EXECUTABLE_NAME}
    )
endmacro()
