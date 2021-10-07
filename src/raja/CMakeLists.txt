set(EXAMPLES
  lc-first-missing-pos
  raja-dependency-check
  balanced-substrings
  )

foreach(SRC ${EXAMPLES})
  if(HAS_RAJA_CUDA)
    set_source_files_properties(${SRC} PROPERTIES LANGUAGE CUDA)
  endif()

  message(STATUS "Adding RAJA example: ${SRC}")
  add_executable(${SRC} ${SRC}.cpp)
  target_link_libraries(${SRC} PUBLIC raja-tpl)

  if(HAS_RAJA_CUDA)
    set_target_properties(${SRC} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
  endif()

  install(TARGETS ${SRC} RUNTIME DESTINATION bin)
  add_test(NAME "TEST_${SRC}" COMMAND $<TARGET_FILE:${SRC}>)
endforeach()
