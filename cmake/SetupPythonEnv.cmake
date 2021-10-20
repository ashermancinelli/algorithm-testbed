find_program(BASH_EXE "bash")
if(${BASH_EXE} STREQUAL "BASH_EXE-NOTFOUND")
  message(STATUS "Bash command could not be found. "
                 "Target 'setup-py' will not be created."
  )
else()
  message(STATUS "Adding target 'setup-py'")
  add_custom_target(
    setup-py
    COMMENT "Creaing Python environment in ${PROJECT_BINARY_DIR}"
    COMMAND ${BASH_EXE} -c '
    ${Python_EXECUTABLE} -m venv ${PROJECT_BINARY_DIR}
    '
    COMMAND
      ${BASH_EXE} -c
      '
    ${PROJECT_BINARY_DIR}/venv/bin/pip install -r ${PROJECT_SOURCE_DIR}/requirements.txt
    '
  )
endif()
