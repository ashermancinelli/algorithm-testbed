#include "config.hpp"

using std::string;
using std::tuple;
using std::vector;

#if 0
answers ⇐ 3‿2‿1
input ⇐ ⟨⟨1, 2, 0⟩, ⟨3, 4, -1, 1⟩, ⟨7, 8, 9, 11, 12⟩⟩
FirstMissing ⇐ { 𝕊𝕩:
  in ← {0<𝕩}⊸/∧𝕩 # Sort the input and take only the range >0
  iota ← (↕≠in)+⊏in
  diff ← in-iota
  out ← («diff)/in
  
  {0=≠in}◶{
    {1<⊑in}◶{
      {0=+´diff}◶{
        1+˜⊑𝕩
      }‿{
        # If the input is the iota, use the len of the positive input
        1+≠in
      } out
    }‿{
      # If the first sorted element >1, use 1
      1
    } @
  }‿{
    1
  } @
}

•Show ("Expected: "‿answers)≍("Actual: "‿(FirstMissing ¨ input))
#endif

int main(int argc, char **argv) {

  auto &rm = umpire::ResourceManager::getInstance();
  umpire::Allocator alloc = rm.getAllocator(mem_space);
  vector<int> answers;
  vector<vector<int>> testcases{
      {1, 2, 0},
      {3, 4, -1, 1},
      {7, 8, 9, 11, 12},
  };

  for (const auto &testcase : testcases) {

    auto N = testcase.size();
    auto *arr = static_cast<int *>(alloc.allocate(N * sizeof(int)));

    std::copy_n(testcase.begin(), N, arr);

    RAJA::sort<exec_space>(RAJA::make_span(arr, N));

    // Same as std::copy_if with predicate >0, but on device
    {
      // Create bitmap from predicate 0<
      auto *bm = static_cast<int *>(alloc.allocate(N * sizeof(int)));
      RAJA::ReduceSum<reduce_pol, int> new_size_(0);
      RAJA::forall<exec_space>(
          RangeSegment(0, N), LAMBDA(const int i) {
            new_size_ += bm[i] = static_cast<int>(arr[i] > 0);
          });

      // Use scan to find destination indices
      auto *indices = static_cast<int *>(alloc.allocate(N * sizeof(int)));
      RAJA::inclusive_scan<exec_space>(RAJA::make_span(bm, N),
                                       RAJA::make_span(indices, N));

      // Copy to indices calculated with previous step
      RAJA::forall<exec_space>(
          RangeSegment(0, N), LAMBDA(const int i) {
            if (bm[i])
              arr[indices[i] - 1] = arr[i];
          });

      // If there are negative numbers to filter out, this will correctly set
      // our new size
      N = new_size_.get();

      alloc.deallocate(indices);
      alloc.deallocate(bm);
    }

    // If everything was filtered out, it's just 1
    if (0 == N || arr[0] > 1) {
      answers.push_back(1);
      continue;
    }

    // Find the difference between the iota and the filtered array
    auto *diff = static_cast<int *>(alloc.allocate(N * sizeof(int)));
    forall<exec_space>(
        RangeSegment(0, N),
        LAMBDA(const int i) { diff[i] = (arr[i] - i) - 1; });

    RAJA::ReduceSum<reduce_pol, int> diffsum(0);
    forall<exec_space>(
        RangeSegment(0, N), LAMBDA(const int i) { diffsum += diff[i]; });

    // If there is no difference, it's just the next natural number, or N+1
    if (0 == diffsum.get()) {
      answers.push_back(N+1);
      continue;
    }

    const auto &inf = std::numeric_limits<int>::max();

    // Otherwise, find the first missing number
    RAJA::ReduceMin<reduce_pol, int> mindiff(inf);

    forall<exec_space>(
        RangeSegment(0, N),
        LAMBDA(const int i) { mindiff.min(diff[i] == 0 ? inf : arr[i-1]); });

    // One less than the first number different from the iota
    answers.push_back(mindiff.get()+1);

    alloc.deallocate(diff);
    alloc.deallocate(arr);
  }

  print_container(answers);
  return 0;
}
