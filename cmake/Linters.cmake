set(HAS_FIND OFF)
set(HAS_CLANGFORMAT OFF)
set(HAS_CMAKEFORMAT OFF)

find_program(FIND_EXE "find")
find_program(CLANGFORMAT_EXE "clang-format")
find_program(CMAKEFORMAT_EXE "cmake-format")

if(${FIND_EXE} STREQUAL "FIND_EXE-NOTFOUND")
  message(STATUS "Find command could not be found. "
                 "No linting targets will be made available.")
else()
  if(${CLANGFORMAT_EXE} STREQUAL "CLANGFORMAT_EXE-NOTFOUND")
    message(STATUS "clang-format command could not be found. "
                   "No clang-format target will be made available.")
  else()
    message(STATUS "Adding target 'clang-format'")
    add_custom_target(
      clang-format
      COMMENT "Formatting C/C++ code"
      COMMAND
        "${FIND_EXE} ${PROJECT_SOURCE_DIR}/src ${PROJECT_SOURCE_DIR}/include -name '*.c' -or -name '*.cpp' -or -name '*.h' -or name '*.hpp' -exec ${CLANGFORMAT_EXE} -i {} ';'"
    )
  endif()

  if(${CMAKEFORMAT_EXE} STREQUAL "CMAKEFORMAT_EXE-NOTFOUND")
    message(STATUS "cmake-format command could not be found. "
      "No cmake-format target will be made available.")
  else()
    message(STATUS "Adding target 'cmake-format'")
    add_custom_target(
      cmake-format
      COMMENT "Formatting CMake code"
      COMMAND "${CMAKEFORMAT_EXE} -i ${PROJECT_SOURCE_DIR}/CMakeLists.txt"
      COMMAND "${FIND_EXE} src include cmake -name CMakeLists.txt -o -name '*.cmake' -exec ${CMAKEFORMAT_EXE} -i ${PROJECT_SOURCE_DIR}/CMakeLists.txt ';'"
    )
  endif()
endif()
