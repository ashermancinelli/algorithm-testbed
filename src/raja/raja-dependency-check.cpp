#include <iostream>
#include "raja-config.hpp"

int main(int, char **) {

  static constexpr std::size_t N = 100;

  auto &rm = umpire::ResourceManager::getInstance();
  umpire::Allocator alloc = rm.getAllocator(mem_space);

  auto *arr = static_cast<double *>(alloc.allocate(N * sizeof(double)));

  std::cout << "Running dependency sanity check.\n";
  forall<exec_space>(
      RangeSegment(0, N), LAMBDA(const int i) { arr[i] = 1.; });

  alloc.deallocate(arr);
  return 0;
}
