include(cmake/AddAsmExample.cmake)
include(cmake/AddCOBOLExample.cmake)

macro(example_str)
  set(OPTIONS ENABLED)
  set(SVARGS NAME)
  set(MVARGS)
  cmake_parse_arguments(
    EXAMPLE_STR "${OPTIONS}" "${SVARGS}" "${MVARGS}" ${ARGN}
  )
  if(${EXAMPLE_STR_ENABLED})
    message(STATUS "   + ${EXAMPLE_STR_NAME}")
  else()
    message(STATUS "   ~ ${EXAMPLE_STR_NAME}")
  endif()
endmacro()

macro(add_special_example)
  set(OPTIONS)
  set(SVARGS NAME TYPE)
  set(MVARGS SOURCES)
  cmake_parse_arguments(
    ADD_SPECIAL_EXAMPLE "${OPTIONS}" "${SVARGS}" "${MVARGS}" ${ARGN}
  )
  if("${ADD_SPECIAL_EXAMPLE_TYPE}" STREQUAL "ASM")
    add_asm_example(
      NAME ${ADD_SPECIAL_EXAMPLE_NAME} SOURCES ${ADD_SPECIAL_EXAMPLE_SOURCES}
    )
  elseif("${ADD_SPECIAL_EXAMPLE_TYPE}" STREQUAL "COBOL")
    add_cobol_example(
      NAME ${ADD_SPECIAL_EXAMPLE_NAME} SOURCES ${ADD_SPECIAL_EXAMPLE_SOURCES}
    )
  else()
    message(
      FATAL_ERROR
        "Tried to add special example \"${ADD_SPECIAL_EXAMPLE_NAME}\","
        " but there is no available example of type \"${ADD_SPECIAL_EXAMPLE_TYPE}\"!"
    )
  endif()
endmacro()

macro(add_example)
  set(OPTIONS)
  set(SVARGS NAME TYPE)
  set(MVARGS DEPENDS SOURCES LINK_LIBRARIES)
  cmake_parse_arguments(
    ADD_EXAMPLE "${OPTIONS}" "${SVARGS}" "${MVARGS}" ${ARGN}
  )
  set(EVALSTR "if(1")
  foreach(D ${ADD_EXAMPLE_DEPENDS})
    set(EVALSTR "${EVALSTR} AND ${D}")
  endforeach()
  set(EVALSTR
      "${EVALSTR})
    set(ADD_EX ON)
  else()
    set(ADD_EX OFF)
  endif()"
  )
  cmake_language(EVAL CODE ${EVALSTR})

  if(ADD_EX)
    example_str(NAME ${ADD_EXAMPLE_NAME} ENABLED)
    if(DEFINED ADD_EXAMPLE_TYPE)
      add_special_example(
        NAME ${ADD_EXAMPLE_NAME} TYPE ${ADD_EXAMPLE_TYPE} SOURCES
        ${ADD_EXAMPLE_SOURCES}
      )
    else()
      add_executable(${ADD_EXAMPLE_NAME} ${ADD_EXAMPLE_SOURCES})
      target_link_libraries(
        ${ADD_EXAMPLE_NAME} PUBLIC ${ADD_EXAMPLE_LINK_LIBRARIES}
      )
      install(TARGETS ${ADD_EXAMPLE_NAME} RUNTIME DESTINATION bin)
      add_test(NAME "test-${ADD_EXAMPLE_NAME}"
               COMMAND $<TARGET_FILE:${ADD_EXAMPLE_NAME}>
      )
    endif()

  else()
    example_str(NAME ${ADD_EXAMPLE_NAME})
  endif()

endmacro()

macro(print_example_header)
  message(STATUS "")
  message(STATUS " Example Name (+enabled, ~disabled)")
  message(
    STATUS
      "--------------------------------------------------------------------------------"
  )
endmacro()
