if(HAS_COBOL)
  example_str(NAME "cobol-dependency-check" ENABLED)
  add_cobol_executable(
    NAME dep-check-cobol
    SOURCES dep-check.cob
    )
else()
  example_str(NAME "cobol-dependency-check")
endif()
