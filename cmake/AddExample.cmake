
macro(example_str)
  set(OPTIONS ENABLED)
  set(SVARGS NAME)
  set(MVARGS )
  cmake_parse_arguments(EXAMPLE_STR
    "${OPTIONS}"
    "${SVARGS}"
    "${MVARGS}"
    ${ARGN}
    )
  if(${EXAMPLE_STR_ENABLED})
    message(STATUS "   + ${EXAMPLE_STR_NAME}")
  else()
    message(STATUS "   ~ ${EXAMPLE_STR_NAME}")
  endif()
endmacro()

macro(add_example)
  set(OPTIONS)
  set(SVARGS NAME)
  set(MVARGS DEPENDS_ON SRC LINK_LIBRARIES)
  cmake_parse_arguments(ADD_EXAMPLE
    "${OPTIONS}"
    "${SVARGS}"
    "${MVARGS}"
    ${ARGN}
    )
  set(EVALSTR "if(1")
  foreach(D ${ADD_EXAMPLE_DEPENDS_ON})
    set(EVALSTR "${EVALSTR} AND ${D}")
  endforeach()
  set(EVALSTR "${EVALSTR})
    set(ADD_EX ON)        
  else()                  
    set(ADD_EX OFF)       
  endif()")
  cmake_language(EVAL CODE ${EVALSTR})

  if(ADD_EX)
    example_str(
      NAME ${ADD_EXAMPLE_NAME}
      ENABLED
      )
    add_executable(${ADD_EXAMPLE_NAME} ${ADD_EXAMPLE_SRC})
    target_link_libraries(${ADD_EXAMPLE_NAME}
      PUBLIC
      ${ADD_EXAMPLE_LINK_LIBRARIES}
      )
    install(TARGETS ${ADD_EXAMPLE_NAME} RUNTIME DESTINATION bin)
    add_test(
      NAME "test-${ADD_EXAMPLE_NAME}"
      COMMAND $<TARGET_FILE:${ADD_EXAMPLE_NAME}>
      )
  else()
    example_str(NAME ${ADD_EXAMPLE_NAME})
  endif()

endmacro()

macro(print_example_header)
  message(STATUS "")
  message(STATUS " Example Name (+enabled, ~disabled)")
  message(STATUS "--------------------------------------------------------------------------------")
endmacro()
