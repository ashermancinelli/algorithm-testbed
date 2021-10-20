configure_file(defines.h.in ${PROJECT_BINARY_DIR}/include/defines.h)
install(FILES ${PROJECT_BINARY_DIR}/include/defines.h DESTINATION include)

install(FILES common-config.hpp host-config.hpp kokkos-config.hpp
              raja-config.hpp thrust-config.hpp DESTINATION include
)
