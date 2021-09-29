
add_executable(dependency-check dependency-check.cu)
target_link_libraries(dependency-check PUBLIC tpl)

install(TARGETS dependency-check RUNTIME DESTINATION bin)
