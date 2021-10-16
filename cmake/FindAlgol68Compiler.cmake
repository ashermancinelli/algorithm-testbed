
set(HAS_ALGOL68 OFF)

find_program(_ALGOL68_COMPILER
  NAMES a68g
  DOC "Path to Algol 68 compiler"
  )

if(${_ALGOL68_COMPILER} STREQUAL "ALGOL68_COMPILER-NOTFOUND")
  message(STATUS "No Algol 68 compiler could be found. "
    "Algol 68 examples will not be built.")
else()
  set(HAS_ALGOL68 ON)
  set(ALGOL68_COMPILER ${_ALGOL68_COMPILER} CACHE PATH "Path to Algol 68 compiler")
  message(STATUS "Found Algol 68 compiler: ${ALGOL68_COMPILER}")
endif()
