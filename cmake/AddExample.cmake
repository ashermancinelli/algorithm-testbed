
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
    message(STATUS \"   + ${ADD_EXAMPLE_NAME}\")
    set(ADD_EX ON)        
  else()                  
    set(ADD_EX OFF)       
    message(STATUS \"   ~ ${ADD_EXAMPLE_NAME}\")
  endif()")
  cmake_language(EVAL CODE ${EVALSTR})

  if(ADD_EX)
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
  endif()

endmacro()

macro(print_example_header)
  message(STATUS "")
  message(STATUS " Example Name (+enabled, ~disabled)")
  message(STATUS "--------------------------------------------------------------------------------")
endmacro()
