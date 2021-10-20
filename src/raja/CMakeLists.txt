set(EXAMPLES lc-first-missing-pos raja-dependency-check balanced-substrings)

foreach(SOURCES ${EXAMPLES})
  if(HAS_RAJA_CUDA)
    set_source_files_properties(${SOURCES} PROPERTIES LANGUAGE CUDA)
  endif()

  add_example(
    NAME
    "${SOURCES}"
    DEPENDS
    HAS_RAJA
    SOURCES
    ${SOURCES}.cpp
    LINK_LIBRARIES
    raja-tpl
  )

  if(HAS_RAJA_CUDA)
    set_target_properties(${SOURCES} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
  endif()
endforeach()
