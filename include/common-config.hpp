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
