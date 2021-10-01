#pragma once

#include <vector>
#include <string>
#include <array>
#include <algorithm>
#include <numeric>
#include <iterator>
#include <iostream>
#include <tuple>
#include <limits>

#include <RAJA/RAJA.hpp>
#include <umpire/Allocator.hpp>
#include <umpire/ResourceManager.hpp>

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

template<typename Container>
auto print_container(Container& c) {
  std::cout << "⟨ ";
  std::copy(c.begin(), c.end(),
            std::ostream_iterator<int>(std::cout, " "));
  std::cout << "⟩\n";
}

template<typename Iterator>
auto print_container(Iterator begin, Iterator end) {
  std::cout << "⟨ ";
  while (begin < end)
    std::cout << *begin++ << " ";
  std::cout << "⟩\n";
}
