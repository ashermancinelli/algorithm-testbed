
set(HAS_PYTHON OFF)
find_package(
  Python
  COMPONENTS Interpreter
  QUIET)
if(TARGET Python::Interpreter AND ${Python_VERSION} VERSION_GREATER "3.4")
  message(STATUS "Found Python: ${Python_EXECUTABLE}")
  set(HAS_PYTHON ON)
  include(cmake/SetupPythonEnv.cmake)
else()
  message(STATUS "Python could not be found. "
                 "Python examples will not be built")
endif()
