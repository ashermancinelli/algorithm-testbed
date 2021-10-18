#include "sudoku-9x9.hpp"
#include <host-config.hpp>

using sudoku_boards::blksz;
using sudoku_boards::Board;
using sudoku_boards::idx2;
using sudoku_boards::idx3;
using sudoku_boards::shape;
using sudoku_boards::tl;
namespace sb = sudoku_boards;

// https://leetcode.com/problems/valid-sudoku/discuss/1487300/C%2B%2B-EASY-TO-UNDERSTAND
auto isgood(const Board &board) -> bool {
  auto ar = vector<int>(shape * shape * 3, 0);
  for (int r = 0; r < shape; r++)
    for (int c = 0; c < shape; c++) {
      const auto v = board[idx2(r, c)];
      if (0 == v)
        continue;
      ar[idx3(r, v - 1, 0)] += 1;
      ar[idx3(c, v - 1, 1)] += 1;
      const auto bi = (r / blksz) * blksz + (c / blksz);
      ar[idx3(bi, v - 1, 2)] += 1;
    }
  const auto m = std::accumulate(ar.begin(), ar.end(), -1, sb::max);
  return m < 2;
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
