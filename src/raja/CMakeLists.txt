set(EXAMPLES
  lc-first-missing-pos
  raja-dependency-check
  balanced-substrings
  )

foreach(SRC ${EXAMPLES})
  if(HAS_RAJA_CUDA)
    set_source_files_properties(${SRC} PROPERTIES LANGUAGE CUDA)
  endif()

  add_example(NAME "${SRC}"
    DEPENDS_ON HAS_RAJA
    SRC ${SRC}.cpp
    LINK_LIBRARIES raja-tpl
    )

  if(HAS_RAJA_CUDA)
    set_target_properties(${SRC} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
  endif()
endforeach()
