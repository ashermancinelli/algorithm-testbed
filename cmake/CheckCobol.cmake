set(HAS_COBOL OFF)
find_program(COBC_EXE "cobc")
if(${COBC_EXE} STREQUAL "COBC_EXE-NOTFOUND")
  message(STATUS "No Cobol compiler could be found. "
                 "Cobol examples will not be built."
  )
else()
  set(HAS_COBOL ON)
  message(STATUS "Found Cobol compiler: ${COBC_EXE}")
endif()
