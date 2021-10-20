example_str(NAME "lc-valid-sudoku-cmake" ENABLED)
add_test(NAME lc-valid-sudoku-cmake
         COMMAND ${CMAKE_COMMAND} -P
                 ${CMAKE_CURRENT_SOURCE_DIR}/lc-valid-sudoku.cmake
)
