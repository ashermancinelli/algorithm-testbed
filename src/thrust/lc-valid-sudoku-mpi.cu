#include "sudoku-9x9.hpp"
#include <thrust-config.hpp>
#ifndef HAS_MPI
#error "This example requires MPI to be available!"
#endif
#include <mpi.h>
#include <thrust/device_free.h>
#include <thrust/device_malloc.h>
#include <thrust/extrema.h>
#include <thrust/memory.h>

using sudoku_boards::Board;
using sudoku_boards::shape;

using thrust::device_malloc;
using thrust::device_vector;
using thrust::host_vector;
using thrust::raw_pointer_cast;

__constant__ int blksz;

__device__ int idx2(int r, int c) { return (r * shape) + c; }
__device__ int idx3(int r, int c, int t) { return (r * shape + c) * 3 + t; }
__device__ int tl(int r) { return r - r % blksz; }

__global__ void setrc(int *rows, int *cols) {
  const int r = threadIdx.x, c = threadIdx.y;
  rows[idx2(r, c)] = r;
  cols[idx2(r, c)] = c;
}

__global__ void setar(int *ar, const int *board, const int *rows,
                      const int *cols, const int start) {
  const auto i = start + threadIdx.x;
  const int r = rows[i], c = cols[i];
  const int value = board[idx2(r, c)];
  if (r < 0 || 0 == value)
    return;
  atomicAdd(&ar[idx3(r, value, 0)], 1);
  atomicAdd(&ar[idx3(c, value, 1)], 1);
  const int bx = r / blksz, by = c / blksz;
  const int bi = bx * blksz + by;
  atomicAdd(&ar[idx3(bi, value, 2)], 1);
}

auto isgood(const Board &board, int rank, int size) -> bool {
  const auto work = 81;
  const auto chunk = (work + size - 1) / size;
  const auto rows = device_malloc<int>(chunk * size),
             cols = device_malloc<int>(chunk * size);
  thrust::fill(rows, rows + (chunk * size), -1);
  thrust::fill(cols, cols + (chunk * size), -1);
  setrc<<<1, dim3(9, 9)>>>(raw_pointer_cast(rows), raw_pointer_cast(cols));
  auto d_ar = device_malloc<int>(81 * 3);
  thrust::fill(d_ar, d_ar + (81 * 3), 0);
  setar<<<1, chunk>>>(
      raw_pointer_cast(d_ar),
      raw_pointer_cast((device_vector<int>(board.begin(), board.end())).data()),
      raw_pointer_cast(rows), raw_pointer_cast(cols), chunk * rank);
  cudaDeviceSynchronize();
  auto h_ar = host_vector<int>(d_ar, d_ar + (81 * 3));
  auto gar = host_vector<int>(81 * 3, 0);
  MPI_Reduce(h_ar.data(), gar.data(), gar.size(), MPI_INT, MPI_SUM, 0,
             MPI_COMM_WORLD);
  if (rank > 0)
    return false;
  const auto m = thrust::reduce(thrust::host, gar.begin(), gar.end(), -1,
                                thrust::maximum<int>());
  return m < 2;
}

int main(int argc, char **argv) {

  assert(!MPI_Init(&argc, &argv));

  MPI_Comm comm = MPI_COMM_WORLD;

  int rank, size;
  assert(!MPI_Comm_rank(comm, &rank));
  assert(!MPI_Comm_size(comm, &size));

  cudaMemcpyToSymbol("blksz", &sudoku_boards::blksz,
                     sizeof(sudoku_boards::blksz));

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
