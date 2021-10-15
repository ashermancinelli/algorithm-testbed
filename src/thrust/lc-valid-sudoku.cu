#include "sudoku-9x9.hpp"
#include <thrust-config.hpp>
#include <thrust/extrema.h>

using sudoku_boards::Board;
using sudoku_boards::shape;

__constant__ int blksz;

__device__ int idx2(int r, int c) { return (r * shape) + c; }
__device__ int idx3(int r, int c, int t) { return (r * shape + c) * 3 + t; }
__device__ int tl(int r) { return r - r % blksz; }

__global__ void setbits(int *bits, const int *board) {
  const auto row = threadIdx.x, col = threadIdx.y;
  const int value = board[idx2(row, col)];
  if (0 == value)
    return;
  atomicAdd(&bits[idx3(row, value, 0)], 1);
  atomicAdd(&bits[idx3(col, value, 1)], 1);

  const int bx = row / blksz, by = col / blksz;
  const int bi = bx * blksz + by;
  atomicAdd(&bits[idx3(bi, value, 2)], 1);
}

// https://leetcode.com/problems/valid-sudoku/discuss/1487300/C%2B%2B-EASY-TO-UNDERSTAND
auto isgood(const Board &board) -> bool {

  const auto h_board = thrust::host_vector<int>(board.begin(), board.end());
  const auto d_board = thrust::device_vector<int>(h_board);

  static constexpr int nbits = shape * shape * 3;
  int *raw_d_bits;
  cudaMalloc(&raw_d_bits, sizeof(int) * nbits);

  dim3 tpb(9, 9);
  setbits<<<1, tpb>>>(raw_d_bits, thrust::raw_pointer_cast(d_board.data()));
  cudaDeviceSynchronize();
  auto h_bits = host_vector<int>(nbits, 0);
  cudaMemcpy(h_bits.data(), raw_d_bits, nbits, cudaMemcpyDeviceToHost);

  const auto m = thrust::reduce(thrust::host, h_bits.begin(), h_bits.end(), -1,
                                thrust::maximum<int>()) - 1;
  return 1 > m;
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
