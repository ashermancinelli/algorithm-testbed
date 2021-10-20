#include "sudoku-9x9.hpp"
#include <thrust-config.hpp>
#include <thrust/device_free.h>
#include <thrust/device_malloc.h>
#include <thrust/extrema.h>

using sudoku_boards::Board;
using sudoku_boards::shape;

using thrust::device_free;
using thrust::device_malloc;
using thrust::device_vector;
using thrust::host_vector;
using thrust::raw_pointer_cast;

__constant__ int blksz;

__device__ int idx2(int r, int c) { return (r * shape) + c; }
__device__ int idx3(int r, int c, int t) { return (r * shape + c) * 3 + t; }
__device__ int tl(int r) { return r - r % blksz; }

__global__ void setar(int *ar, const int *board) {
  const auto row = threadIdx.x, col = threadIdx.y;
  const int value = board[idx2(row, col)];
  if (0 == value)
    return;
  atomicAdd(&ar[idx3(row, value, 0)], 1);
  atomicAdd(&ar[idx3(col, value, 1)], 1);

  const int bx = row / blksz, by = col / blksz;
  const int bi = bx * blksz + by;
  atomicAdd(&ar[idx3(bi, value, 2)], 1);
}

// https://leetcode.com/problems/valid-sudoku/discuss/1487300/C%2B%2B-EASY-TO-UNDERSTAND
auto isgood(const Board &board) -> bool {
  auto d_ar = device_malloc<int>(81 * 3);
  setar<<<1, dim3(9, 9)>>>(
      raw_pointer_cast(d_ar),
      raw_pointer_cast(
          (thrust::device_vector<int>(board.begin(), board.end())).data()));
  cudaDeviceSynchronize();
  const auto m =
      thrust::reduce(d_ar, d_ar + (81 * 3), -1, thrust::maximum<int>());
  device_free(d_ar);
  return m < 2;
}

int main(int argc, char **argv) {
  (void)argc;
  (void)argv;

  cudaMemcpyToSymbol("blksz", &sudoku_boards::blksz,
                     sizeof(sudoku_boards::blksz));

  auto bool2str = [](bool b) { return b ? "true" : "false"; };

  for (const auto &board : sudoku_boards::all_boards) {
    bool ret = isgood(board);
    std::cout << bool2str(ret) << "\n";
  }

  return EXIT_SUCCESS;
}
