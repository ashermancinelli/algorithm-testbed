#include <iostream>

#include <RAJA/RAJA.hpp>
#include <umpire/Allocator.hpp>
#include <umpire/ResourceManager.hpp>

using RAJA::forall;
using RAJA::RangeSegment;

#ifdef RAJA_CUDA_ACTIVE
  using exec_space = RAJA::cuda_exec<128>;
  #define LAMBDA [=]__device__
  static const char mem_space[] = "UM";
#else
  using exec_space = RAJA::seq_exec;
  #define LAMBDA [=]
  static const char mem_space[] = "HOST";
#endif

// BQN solution:
// {+´0=+`1-˜2×82=@-˜𝕩}
int main(int argc, char **argv) {

  static constexpr std::size_t N = 100;

  auto &rm = umpire::ResourceManager::getInstance();
  umpire::Allocator alloc = rm.getAllocator(mem_space);

  auto *arr = static_cast<int*>(alloc.allocate(N * sizeof(int)));
  std::string hostarr{"LLRRLRLRLR"};

  // Fill the device array with the values from the input problem, and backpad
  // with the null character
  for (int i=0; i < N; i++) {
    arr[i] = i < N ? hostarr[i] : '\0';
  }

  std::cout << "Running balanced substring solution\n";
  forall<exec_space>(
      RangeSegment(0, N), LAMBDA(const int i) { arr[i] = 1.; });

  std::cout << "Results:\n";
  for (int i=0; i<N; i++)
    std::cout << arr[i] << " ";
  std::cout << "\n";

  alloc.deallocate(arr);
  return 0;
}
