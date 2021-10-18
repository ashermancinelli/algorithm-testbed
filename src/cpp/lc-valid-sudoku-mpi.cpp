#include "sudoku-9x9.hpp"
#include <host-config.hpp>
#include <optional>
#ifndef HAS_MPI
#error "This example requires MPI to be available!"
#endif
#include <cassert>
#include <mpi.h>

using sudoku_boards::blksz;
using sudoku_boards::Board;
using sudoku_boards::idx2;
using sudoku_boards::idx3;
using sudoku_boards::shape;
using sudoku_boards::tl;
namespace sb = sudoku_boards;

auto cartesian_product_iota = [](const int i, const int j) {
  auto v = vector<pair<int, int>>(i * j, make_pair(0, 0));
  for (int ii = 0; ii < i; ii++)
    for (int jj = 0; jj < j; jj++)
      v[ii * i + jj] = std::make_pair(ii, jj);
  return v;
};

// https://leetcode.com/problems/valid-sudoku/discuss/1487300/C%2B%2B-EASY-TO-UNDERSTAND
auto isgood(const Board &board, int rank, int size) -> bool {
  const auto work = shape * shape;
  const auto chunk_size = (work + size - 1) / size;
  auto indices =
      std::vector<std::pair<int, int>>(work * size, std::make_pair(-1, -1));
  for (int r = 0; r < shape; r++)
    for (int c = 0; c < shape; c++)
      indices[idx2(r, c)] = std::make_pair(r, c);

  auto ar = vector<int>(shape * shape * 3, 0);

  for (std::size_t i = chunk_size * rank; i < chunk_size + (chunk_size * rank);
       i++) {
    const auto &[r, c] = indices[i];
    const auto v = board[idx2(r, c)];
    if (r < 0 or 0 == v)
      continue;
    ar[idx3(r, v - 1, 0)] += 1;
    ar[idx3(c, v - 1, 1)] += 1;
    const auto bi = (r / blksz) * blksz + (c / blksz);
    ar[idx3(bi, v - 1, 2)] += 1;
  }

  vector<int> gar(shape * shape * 3, 0);
  MPI_Reduce(ar.data(), gar.data(), gar.size(), MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
  return 0 == rank ? std::accumulate(gar.begin(), gar.end(), -1, sb::max) < 2
                   : false;
}

int main(int argc, char **argv) {

  assert(!MPI_Init(&argc, &argv));

  MPI_Comm comm = MPI_COMM_WORLD;

  int size, rank;
  assert(!MPI_Comm_size(comm, &size));
  assert(!MPI_Comm_rank(comm, &rank));

  auto bool2str = [](bool b) { return b ? "true" : "false"; };

  for (const auto &board : sudoku_boards::all_boards) {
    bool ret;
    if (0 == rank)
      ret = isgood(board, rank, size);
    else
      isgood(board, rank, size);
    assert(!MPI_Barrier(comm));
    if (0 == rank)
      std::cout << bool2str(ret) << "\n";
  }

  assert(!MPI_Finalize());
  return EXIT_SUCCESS;
}
