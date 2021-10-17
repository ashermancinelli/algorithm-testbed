set(HAS_FIND OFF)
set(HAS_CLANGFORMAT OFF)
set(HAS_CMAKEFORMAT OFF)

find_program(FIND_EXE "find")
find_program(CLANGFORMAT_EXE "clang-format")
find_program(CMAKEFORMAT_EXE "cmake-format")
find_program(PY_FORMAT "black")

if(${FIND_EXE} STREQUAL "FIND_EXE-NOTFOUND")
  message(STATUS "Find command could not be found. "
                 "No linting targets will be made available.")
else()

  set(ALL_FORMAT_TARGETS )

  if(${CLANGFORMAT_EXE} STREQUAL "CLANGFORMAT_EXE-NOTFOUND")
    message(STATUS "clang-format command could not be found. "
                   "No clang-format target will be made available.")
  else()
    list(APPEND ALL_FORMAT_TARGETS clang-format)
    message(STATUS "Adding target 'clang-format'")
    add_custom_target(
      clang-format
      COMMENT "Formatting C/C++ code"
      COMMAND
        ${FIND_EXE} src include -name '*.c' -o -name '*.cu' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' -exec ${CLANGFORMAT_EXE} -i {} \'\;\'
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    )
  endif()

  if(${CMAKEFORMAT_EXE} STREQUAL "CMAKEFORMAT_EXE-NOTFOUND")
    message(STATUS "cmake-format command could not be found. "
      "No cmake-format target will be made available.")
  else()
    list(APPEND ALL_FORMAT_TARGETS cmake-format)
    message(STATUS "Adding target 'cmake-format'")
    add_custom_target(
      cmake-format
      COMMENT "Formatting CMake code"
      COMMAND ${CMAKEFORMAT_EXE} -i ${PROJECT_SOURCE_DIR}/CMakeLists.txt
      COMMAND ${FIND_EXE} src include cmake -name CMakeLists.txt -o -name '*.cmake' -exec ${CMAKEFORMAT_EXE} -i CMakeLists.txt \'\;\'
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    )
  endif()

  if(${PY_FORMAT} STREQUAL "PY_FORMAT-NOTFOUND")
    message(STATUS "No 'black' executable could be found. "
      "Python formatting target will not be created.")
  else()
    list(APPEND ALL_FORMAT_TARGETS py-format)
    message(STATUS "Adding target 'py-format'")
    add_custom_target(
      py-format
      COMMENT "Formatting Python code"
      COMMAND ${FIND_EXE} src -name '*.py' -exec ${PY_FORMAT} {} \'\;\'
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    )
  endif()

  set(FORMAT_STR "")
  foreach(TGT ${ALL_FORMAT_TARGETS})
    set(FORMAT_STR "${FORMAT_STR}
    COMMAND \$\{CMAKE_COMMAND\} --build . --target ${TGT}
    ")
  endforeach()
  cmake_language(EVAL CODE "
    add_custom_target(
      format
      COMMENT \"Calling all available formatting targets\"
      WORKING_DIRECTORY \${PROJECT_BINARY_DIR}
      ${FORMAT_STR}
      )
  ")
endif()
