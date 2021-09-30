#include <iostream>

#include <RAJA/RAJA.hpp>
#include <umpire/Allocator.hpp>
#include <umpire/ResourceManager.hpp>

using RAJA::forall;
using RAJA::RangeSegment;

#ifdef RAJA_CUDA_ACTIVE
  using exec_space = RAJA::cuda_exec<128>;
  #define LAMBDA [=]__device__
  static constexpr char mem_space[] = "UM";
#else
  using exec_space = RAJA::seq_exec;
  #define LAMBDA [=]
  static constexpr char mem_space[] = "HOST";
#endif

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
