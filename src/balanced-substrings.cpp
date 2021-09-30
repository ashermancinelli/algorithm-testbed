#include <iostream>
#include <string>
#include <tuple>
#include <vector>

#include <RAJA/RAJA.hpp>
#include <umpire/Allocator.hpp>
#include <umpire/ResourceManager.hpp>

using std::string;
using std::tuple;
using std::vector;

using RAJA::forall;
using RAJA::inclusive_scan_inplace;
using RAJA::RangeSegment;

#ifdef RAJA_CUDA_ACTIVE
using exec_space = RAJA::cuda_exec<128>;
using reduce_pol = RAJA::cuda_reduce;
#define LAMBDA [=] __device__
static const char mem_space[] = "UM";
#else
using exec_space = RAJA::seq_exec;
using reduce_pol = RAJA::seq_reduce;
#define LAMBDA [=]
static const char mem_space[] = "HOST";
#endif

// bqn solution:
//
// {+´0=+`1-˜2×82=@-˜𝕩} ¨ "LLRRLRLRLR"‿"RLLLLRRRLR"‿"LLLLRRRR"‿"RLRRRLLRLL"

int main(int argc, char **argv) {

  auto &rm = umpire::ResourceManager::getInstance();
  umpire::Allocator alloc = rm.getAllocator(mem_space);
  vector<int> answers;
  vector<tuple<string, int>> testcases{
      {
          {"LLRRLRLRLR"},
          4,
      },
      {
          {"RLLLLRRRLR"},
          3,
      },
      {
          {"LLLLRRRR"},
          1,
      },
      {
          {"RLRRRLLRLL"},
          2,
      },
  };

  // allocate a workspace array larger than the largest test case
  auto *arr = static_cast<int *>(alloc.allocate(1e3 * sizeof(int)));

  for (const auto &[testcase, solution] : testcases) {

    const auto &N = testcase.size();

    // Fill the device array with the values from the input problem, and backpad
    // with the null character. We're using UVM if cuda/hip are enabled, so
    // we don't need an explicit memcpy
    for (int i = 0; i < N; i++) {
      arr[i] = testcase[i];
    }

    // Apply the transform to -1s and 1s
    // bqn) {1-˜2×82=@-˜𝕩}
    forall<exec_space>(
        RangeSegment(0, N),
        LAMBDA(const int i) { arr[i] = (arr[i] == 'R') ? 1 : -1; });

    // Perform the prefix sum. Default operation is RAJA::operators::plus which
    // is what we want. This is the same as +´
    // bqn) {+´𝕩}
    inclusive_scan_inplace<exec_space>(RAJA::make_span(arr, N));

    // Sum the 0s
    // bqn) {+`0=𝕩}
    RAJA::ReduceSum<reduce_pol, int> sum0s(0);
    forall<exec_space>(
        RangeSegment(0, N),
        LAMBDA(const int i) { sum0s += static_cast<int>(arr[i] == 0); });

    answers.push_back(sum0s.get());
  }

  std::cout << "⟨ ";
  std::copy(
      answers.begin(), answers.end(),
      std::ostream_iterator<int>(std::cout, " "));
  std::cout << "⟩\n";

  alloc.deallocate(arr);
  return 0;
}
