#include <iostream>

#include <cuda.h>
#include <RAJA/RAJA.hpp>
#include <umpire/Allocator.hpp>
#include <umpire/ResourceManager.hpp>

using RAJA::forall;
using RAJA::RangeSegment;

int main(int, char **) {

  static constexpr std::size_t N = 100;
  using exec_space = RAJA::policy::cuda::cuda_exec<128>;

  auto &rm = umpire::ResourceManager::getInstance();
  umpire::Allocator alloc = rm.getAllocator("UM");

  auto *arr = static_cast<double *>(alloc.allocate(N * sizeof(double)));

  forall<exec_space>(
      RangeSegment(0, N), [=]__device__(const int i) { arr[i] = 1.; });

  std::cout << "Running dependency sanity check.\n";
  return 0;
}
