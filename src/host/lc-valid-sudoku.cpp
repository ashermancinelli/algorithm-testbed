#include "sudoku-9x9.hpp"
#include <host-config.hpp>

using sudoku_boards::blksz;
using sudoku_boards::Board;
using sudoku_boards::idx2;
using sudoku_boards::idx3;
using sudoku_boards::shape;
using sudoku_boards::tl;
namespace sb = sudoku_boards;

// cartesian product iota
auto cpi = [](const int x, const int y) {
  auto v = vector<pair<int, int>>(x * y, make_pair(0, 0));
  for (int i = 0; i < x; i++)
    for (int j = 0; j < y; j++)
      v[i * x + j] = std::make_pair(i, j);
  return v;
};

// https://leetcode.com/problems/valid-sudoku/discuss/1487300/C%2B%2B-EASY-TO-UNDERSTAND
auto isgood(const Board &board) -> bool {
  const auto indices = cpi(shape, shape);
  const auto block_offsets = cpi(blksz, blksz);

  // shape, for all possible values. shape for index in type. 3 for the types
  auto bits = vector<int>(shape * shape * 3, 0);

  auto chkcell = [=, &board, &bits](const int r, const int c) {
    const auto value = board[idx2(r, c)];
    if (0 == value)
      return;
    for (std::size_t i = 0; i < shape; i++)
      bits[idx3(r, c, 0)] += static_cast<int>(value == board[idx2(r, i)]);
    for (std::size_t i = 0; i < shape; i++)
      bits[idx3(r, c, 1)] += static_cast<int>(value == board[idx2(i, c)]);
    for (const auto &[dx, dy] : block_offsets)
      bits[idx3(r, c, 2)] +=
          static_cast<int>(value == board[idx2(tl(r) + dy, tl(c) + dx)]);
  };

  for (const auto &[r, c] : indices)
    chkcell(r, c);

  const auto m = std::accumulate(bits.begin(), bits.end(), -1, sb::max) - 1;
  return 1 > m;
}

int main(int argc, char **argv) {

  (void)argc;
  (void)argv;

  auto bool2str = [](bool b) { return b ? "true" : "false"; };

  for (const auto &board : sudoku_boards::all_boards) {
    bool ret = isgood(board);
    std::cout << bool2str(ret) << "\n";
  }

  return EXIT_SUCCESS;
}
