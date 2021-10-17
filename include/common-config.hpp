// vi: ft=cpp
#pragma once

#include <defines.h>

#include <algorithm>
#include <array>
#include <iostream>
#include <iterator>
#include <limits>
#include <numeric>
#include <string>
#include <tuple>
#include <vector>

using std::array;
using std::make_pair;
using std::pair;
using std::string;
using std::tuple;
using std::vector;

template <typename Container> auto print_container(Container &c) {
  std::cout << "⟨ ";
  std::copy(c.begin(), c.end(), std::ostream_iterator<int>(std::cout, " "));
  std::cout << "⟩\n";
}

template <typename Iterator>
auto print_container(Iterator begin, Iterator end) {
  std::cout << "⟨ ";
  while (begin < end)
    std::cout << *begin++ << " ";
  std::cout << "⟩\n";
}
