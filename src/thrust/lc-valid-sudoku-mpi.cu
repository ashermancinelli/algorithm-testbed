#include "sudoku-9x9.hpp"
#include <thrust-config.hpp>
#ifndef HAS_MPI
#error "This example requires MPI to be available!"
#endif
#include <mpi.h>
#include <thrust/extrema.h>

using sudoku_boards::Board;
using sudoku_boards::shape;

__constant__ int blksz;

__device__ int idx2(int r, int c) { return (r * shape) + c; }
__device__ int idx3(int r, int c, int t) { return (r * shape + c) * 3 + t; }
__device__ int tl(int r) { return r - r % blksz; }

__global__ void setbits(int *bits, const int *board,
                        thrust::pair<int, int> bounds) {
  const auto row = threadIdx.x, col = threadIdx.y;
  const int value = board[idx2(row, col)];
  const int i2 = idx2(row, col);
  const bool is_in_bounds = (i2 < bounds.second) && (i2 >= bounds.first);
  if (!is_in_bounds || 0 == value)
    return;
  atomicAdd(&bits[idx3(row, value, 0)], 1);
  atomicAdd(&bits[idx3(col, value, 1)], 1);

  const int bx = row / blksz, by = col / blksz;
  const int bi = bx * blksz + by;
  atomicAdd(&bits[idx3(bi, value, 2)], 1);
}

// https://leetcode.com/problems/valid-sudoku/discuss/1487300/C%2B%2B-EASY-TO-UNDERSTAND
auto isgood(const Board &board, MPI_Comm comm) -> bool {

  const auto h_board = thrust::host_vector<int>(board.begin(), board.end());
  const auto d_board = thrust::device_vector<int>(h_board);

  int size, rank;
  assert(!MPI_Comm_size(comm, &size));
  assert(!MPI_Comm_rank(comm, &rank));
  const auto work = shape * shape;
  const auto chunk_size = (work + size - 1) / size;

  const auto bounds =
      thrust::make_pair(chunk_size * rank, (chunk_size * rank) + chunk_size);

  static constexpr int nbits = shape * shape * 3;
  int *raw_d_bits;
  cudaMalloc(&raw_d_bits, sizeof(int) * nbits);

  dim3 tpb(9, 9);
  setbits<<<1, tpb>>>(raw_d_bits, thrust::raw_pointer_cast(d_board.data()),
                      bounds);
  cudaDeviceSynchronize();
  auto h_bits = thrust::host_vector<int>(nbits, 0);
  cudaMemcpy(h_bits.data(), raw_d_bits, nbits, cudaMemcpyDeviceToHost);

  // Ensure all ranks have reached their solutions
  assert(!MPI_Barrier(comm));

  thrust::host_vector<int> gbits(shape * shape * 3, 0);
  assert(!MPI_Reduce(/*send=*/h_bits.data(),
                     /*recv=*/gbits.data(),
                     /*count=*/gbits.size(),
                     /*datatype=*/MPI_INT,
                     /*operation=*/MPI_SUM,
                     /*dest rank=*/0,
                     /*communicator=*/comm));

  if (rank > 0)
    return false;

  const auto m = thrust::reduce(thrust::host, gbits.begin(), gbits.end(), -1,
                                thrust::maximum<int>()) -
                 1;
  return 1 > m;
}

int main(int argc, char **argv) {

  assert(!MPI_Init(&argc, &argv));

  MPI_Comm comm = MPI_COMM_WORLD;

  int rank;
  assert(!MPI_Comm_rank(comm, &rank));

  cudaMemcpyToSymbol("blksz", &sudoku_boards::blksz,
                     sizeof(sudoku_boards::blksz));

  auto bool2str = [](bool b) { return b ? "true" : "false"; };

  for (const auto &board : sudoku_boards::all_boards) {
    bool ret;
    if (0 == rank)
      ret = isgood(board, comm);
    else
      isgood(board, comm);
    assert(!MPI_Barrier(comm));
    if (0 == rank)
      std::cout << bool2str(ret) << "\n";
  }

  assert(!MPI_Finalize());
  return EXIT_SUCCESS;
}
