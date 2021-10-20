
macro(add_asm_example)
  enable_language(ASM)
  set(OPTIONS )
  set(SVARGS NAME TYPE)
  set(MVARGS SOURCES)
  cmake_parse_arguments(ADD_ASM_EXAMPLE
    "${OPTIONS}"
    "${SVARGS}"
    "${MVARGS}"
    ${ARGN}
    )

  list(TRANSFORM ADD_ASM_EXAMPLE_SOURCES PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")

  add_custom_command(
    COMMENT "Building mixed ASM target ${ADD_ASM_EXAMPLE_NAME}"
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${ADD_ASM_EXAMPLE_NAME}"
    DEPENDS ${ADD_ASM_EXAMPLE_SOURCES}
    COMMAND
    ${CMAKE_C_COMPILER} ${ADD_ASM_EXAMPLE_SOURCES} -o "${CMAKE_CURRENT_BINARY_DIR}/${ADD_ASM_EXAMPLE_NAME}"
    )

  add_custom_target(${ADD_ASM_EXAMPLE_NAME} ALL
    DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${ADD_ASM_EXAMPLE_NAME}"
    )
endmacro()
