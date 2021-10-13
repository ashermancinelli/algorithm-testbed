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

// https://leetcode.com/problems/valid-sudoku/discuss/1487300/C%2B%2B-EASY-TO-UNDERSTAND
auto isgood(const Board &board, MPI_Comm comm) -> bool {

  // cartesian product iota
  auto cpi = [](const int l) {
    auto v = vector<pair<int, int>>(l*l, make_pair(0, 0));
    for(int i=0; i<l; i++)
      for(int j=0; j<l; j++)
        v[i*l+j] = std::make_pair(i, j);
    return v;
  };
  const auto indices = cpi(shape);
  const auto block_offsets = cpi(blksz);

  // shape, for all possible values. shape for index in type. 3 for the types
  auto bits = vector<int>(shape * shape * 3, 0);

  int size, rank;
  assert(!MPI_Comm_size(comm, &size));
  assert(!MPI_Comm_rank(comm, &rank));
  const auto work = indices.size();

  const auto chunk_size = (work + size - 1) / size;
  const auto chunked_work = indices | views::chunk(chunk_size) | to<vector>;

  const auto rank_indices = chunked_work[rank];

  auto chkcell = [=, &board, &bits](const int r, const int c) {
    const auto value = board[idx2(r, c)];
    if (0 == value)
      return;
    for (int i = 0; i < shape; i++)
      bits[idx3(r, c, 0)] += static_cast<int>(value == board[idx2(r, i)]);
    for (int i = 0; i < shape; i++)
      bits[idx3(r, c, 1)] += static_cast<int>(value == board[idx2(i, c)]);
    for (const auto &[dx, dy] : block_offsets)
      bits[idx3(r, c, 2)] +=
          static_cast<int>(value == board[idx2(tl(r) + dy, tl(c) + dx)]);
  };

  assert(!MPI_Barrier(comm));
  for (const auto &[r, c] : rank_indices)
    chkcell(r, c);

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
    return 0 == m;
  } else
    return false;
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
