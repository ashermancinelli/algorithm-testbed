#pragma once
#include <array>
#include <cmath>
#include <vector>

#ifdef HAS_CUDA
#define HOST_DEVICE_ATTRS __host__ __device__
#else
#define HOST_DEVICE_ATTRS
#endif

namespace sudoku_boards {

static constexpr std::size_t shape = 9;
using Board = std::array<int, shape * shape>;

const auto blksz = static_cast<int>(std::sqrt(shape));
const auto idx2 = [] HOST_DEVICE_ATTRS(int r, int c) {
  return (r * shape) + c;
};
const auto idx3 = [] HOST_DEVICE_ATTRS(int r, int c, int t) {
  return (r * shape + c) * 3 + t;
};
const auto tl = [] HOST_DEVICE_ATTRS(const int r) { return r - r % blksz; };
const auto max = [](int a, int b) { return std::max(a, b); };

// clang-format off

const auto good_online = Board{2, 9, 4,  8, 6, 3,  5, 1, 7,
                               7, 1, 5,  4, 2, 9,  6, 3, 8,
                               8, 6, 3,  7, 5, 1,  4, 9, 2,
      
                               1, 5, 2,  9, 4, 7,  8, 6, 3,
                               4, 7, 9,  3, 8, 6,  2, 5, 1,
                               6, 3, 8,  5, 1, 2,  9, 7, 4,
      
                               9, 8, 6,  1, 3, 4,  7, 2, 5,
                               5, 2, 1,  6, 7, 8,  3, 4, 9,
                               3, 4, 7,  2, 9, 5,  1, 8, 6,};

const auto bad_online = Board{2, 9, 4,  8, 6, 3,  5, 1, 7,
                              7, 1, 5,  4, 2, 9,  6, 3, 8,
                              8, 6, 3,  7, 5, 1,  4, 9, 2,
      
                              1, 5, 2,  9, 4, 7,  8, 6, 3,
                              4, 7, 9,  3, 8, 6,  2, 5, 1,
                              6, 3, 8,  5, 1, 2,  9, 7, 4,
      
                              9, 8, 6,  1, 3, 4,  7, 2, 5,
                              5, 2, 1,  6, 7, 8,  3, 4, 9,
                              3, 1, 7,  2, 9, 5,  1, 8, 6,};

const auto good = Board{5, 3, 0,  0, 7, 0,  0, 0, 0,
                        6, 0, 0,  1, 9, 5,  0, 0, 0,
                        0, 9, 8,  0, 0, 0,  0, 6, 0,
      
                        8, 0, 0,  0, 6, 0,  0, 0, 3,
                        4, 0, 0,  8, 0, 3,  0, 0, 1,
                        7, 0, 0,  0, 2, 0,  0, 0, 6,
      
                        0, 6, 0,  0, 0, 0,  2, 8, 0,
                        0, 0, 0,  4, 1, 9,  0, 0, 5,
                        0, 0, 0,  0, 8, 0,  0, 7, 9};

const auto bad = Board{8, 3, 0,  0, 7, 0,  0, 0, 0,
                       6, 0, 0,  1, 9, 5,  0, 0, 0,
                       0, 9, 8,  0, 0, 0,  0, 6, 0,
      
                       8, 0, 0,  0, 6, 0,  0, 0, 3,
                       4, 0, 0,  8, 0, 3,  0, 0, 1,
                       7, 0, 0,  0, 2, 0,  0, 0, 6,
      
                       0, 6, 0,  0, 0, 0,  2, 8, 0,
                       0, 0, 0,  4, 1, 9,  0, 0, 5,
                       0, 0, 0,  0, 8, 0,  0, 7, 9};

// clang-format on

static const auto all_boards = std::vector<Board>{
    good_online,
    good,
    bad_online,
    bad,
};

} // namespace sudoku_boards
