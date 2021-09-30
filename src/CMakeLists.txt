set(EXAMPLE_PROBLEMS dependency-check balanced-substrings)

foreach(SRC ${EXAMPLE_PROBLEMS})

  if(HAS_CUDA)
    set_source_files_properties(${SRC} PROPERTIES LANGUAGE CUDA)
  endif()

  message(STATUS "Adding example: ${SRC}")
  add_executable(${SRC} ${SRC}.cpp)
  target_link_libraries(${SRC} PUBLIC tpl)

  if(HAS_CUDA)
    set_target_properties(${SRC} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
  endif()

  install(TARGETS ${SRC} RUNTIME DESTINATION bin)

endforeach()
