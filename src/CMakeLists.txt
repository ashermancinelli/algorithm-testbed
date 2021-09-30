set(EXAMPLE_PROBLEMS dependency-check balanced-substrings)

foreach(SRC ${EXAMPLE_PROBLEMS})

  if(ENABLE_CUDA)
    set_source_files_properties(${SRC} LANGUAGE CUDA)
  endif()

  message(STATUS "Adding example: ${SRC}")
  add_executable(${SRC} ${SRC}.cpp)
  target_link_libraries(${SRC} PUBLIC tpl)

  install(TARGETS ${SRC} RUNTIME DESTINATION bin)

endforeach()
