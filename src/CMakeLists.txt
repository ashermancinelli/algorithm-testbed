
add_executable(dependency-check dependency-check.cpp)
target_link_libraries(dependency-check PUBLIC tpl)

install(TARGETS dependency-check RUNTIME DESTINATION bin)
