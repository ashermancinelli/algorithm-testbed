
#include <iostream>
#include <string>

#include <RAJA/RAJA.hpp>
#include <cuda.h>
#include <umpire/Allocator.hpp>
#include <umpire/ResourceManager.hpp>

using RAJA::atomicAdd;
using RAJA::forall;
using RAJA::RangeSegment;

int main(int, char **) {

  static constexpr std::size_t N = 10;
  using exec_space = RAJA::policy::cuda::cuda_exec<128>;

  auto &rm = umpire::ResourceManager::getInstance();
  umpire::Allocator alloc = rm.getAllocator("UM");

  auto *arr = static_cast<double *>(alloc.allocate(N * sizeof(double)));
  std::string hostarr{"abcabcbbbb"};

  // Fill the device array with the values from the input problem, and backpad
  // with the null character
  for (int i = 0; i < N; i++) {
    arr[i] = i < N ? hostarr[i] : '\0';
  }

  // 256 bins for all the ascii characters
  auto *bins = static_cast<double *>(alloc.allocate(256 * sizeof(double)));

  // Increment the value in the bin for each value encountered
  forall<exec_space>(RangeSegment(0, N), [=] __device__(const int i) {
    RAJA::atomicAdd<RAJA::cuda_atomic>(&bins[array[i]], 1);
  });

  alloc.deallocate(arr);
  alloc.deallocate(bins);
  return 0;
}
