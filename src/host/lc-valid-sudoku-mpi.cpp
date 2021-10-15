#include "sudoku-9x9.hpp"
#include <host-config.hpp>
#include <optional>
#ifndef HAS_MPI
#error "This example requires MPI to be available!"
#endif
#include <mpi.h>

using sudoku_boards::blksz;
using sudoku_boards::Board;
using sudoku_boards::idx2;
using sudoku_boards::idx3;
using sudoku_boards::shape;
using sudoku_boards::tl;

auto cartesian_product_iota = [](const int i, const int j) {
  auto v = vector<pair<int, int>>(i*j, make_pair(0, 0));
  for(int ii=0; ii<i; ii++)
    for(int jj=0; jj<j; jj++)
      v[ii*i+jj] = std::make_pair(ii, jj);
  return v;
};

// https://leetcode.com/problems/valid-sudoku/discuss/1487300/C%2B%2B-EASY-TO-UNDERSTAND
auto isgood(const Board &board, MPI_Comm comm) -> bool {

  int size, rank;
  assert(!MPI_Comm_size(comm, &size));
  assert(!MPI_Comm_rank(comm, &rank));
  const auto work = shape*shape;

  const auto chunk_size = (work + size - 1) / size;

  auto indices = cartesian_product_iota(shape, shape);
  while (indices.size() < chunk_size*size) // backfill dummy entries
    indices.push_back(std::make_pair(-1, -1));

  const auto block_offsets = cartesian_product_iota(blksz, blksz);

  auto bits = vector<int>(shape * shape * 3, 0);

  auto chkcell = [=, &board, &bits](const int r, const int c) {
    if (r < 0) return;
    const auto value = board[idx2(r, c)];
    if (0 == value) return;
    for (std::size_t i = 0; i < shape; i++)
      bits[idx3(r, c, 0)] += static_cast<int>(value == board[idx2(r, i)]);
    for (std::size_t i = 0; i < shape; i++)
      bits[idx3(r, c, 1)] += static_cast<int>(value == board[idx2(i, c)]);
    for (const auto &[dx, dy] : block_offsets)
      bits[idx3(r, c, 2)] +=
          static_cast<int>(value == board[idx2(tl(r) + dy, tl(c) + dx)]);
  };

  assert(!MPI_Barrier(comm));
  for(std::size_t i=chunk_size*rank; i < chunk_size+(chunk_size*rank); i++)
  { const auto &[r, c] = indices[i]; chkcell(r, c); }

  // Ensure all ranks have reached their solutions
  assert(!MPI_Barrier(comm));

  vector<int> gbits(shape * shape * 3, 0);
  assert(!MPI_Reduce(/*send=*/bits.data(),
                     /*recv=*/gbits.data(),
                     /*count=*/gbits.size(),
                     /*datatype=*/MPI_INT,
                     /*operation=*/MPI_SUM,
                     /*dest rank=*/0,
                     /*communicator=*/comm));
  if (0 == rank) {
    const auto m = std::accumulate(gbits.begin(), gbits.end(), -1, max) - 1;
    return 1 > m;
  } else return false;
}

int main(int argc, char **argv) {

  assert(!MPI_Init(&argc, &argv));

  MPI_Comm comm = MPI_COMM_WORLD;

  int rank;
  assert(!MPI_Comm_rank(comm, &rank));

  auto bool2str = [](bool b) { return b ? "true" : "false"; };

  for (const auto &board : sudoku_boards::all_boards) {
    bool ret;
    if (0 == rank)
      ret = isgood(board, comm);
    else
      isgood(board, comm);
    assert(!MPI_Barrier(comm));
    if(0==rank)
      std::cout << bool2str(ret) << "\n";
  }

  assert(!MPI_Finalize());
  return EXIT_SUCCESS;
}
