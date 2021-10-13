#include <host-config.hpp>
#ifndef HAS_MPI
#error "This example requires MPI to be available!"
#endif
#include <mpi.h>

#include <optional>

using SudokuRange = std::array<int, 27>;

auto copy_row(int i, SudokuRange& r) -> SudokuRange {
  SudokuRange rr;
  // std::copy_n()
}
auto has_duplicates() -> bool { return false; }

// Only rank 0 actually recieves the board. All other ranks will get their data
// from rank 0.
//
// Only the return value from rank 0 matters.
auto isgood(std::optional<vector<int>> board, const int rank) -> bool {
  MPI_Barrier(MPI_COMM_WORLD);

  // 27 jobs, 9 checking rows, 9 checking cols, and 9 checking blocks
  auto job_types = views::concat(
      view::repeat(0) | views::take(9),
      view::repeat(1) | views::take(9),
      view::repeat(2) | views::take(9)
      );
  if(!rank)
    std::cout << job_types << "\n";

  auto indices = ranges::view::repeat_n(views::iota(0) | views::take(9), 3) | views::join;
  if(!rank)
    std::cout << indices << "\n";

  auto has_duplicates = [=](SudokuRange &&r) {
    //
    return false;
  };

  // Each entry corresponds to a possible status for a row, column, or box
  // The first 9 entries correspond to each row
  // The second 9 correspond to each column
  // The final 9 correspond to each box.
  //
  // This array will be sum reduced at the end of the function to check if any
  // ranks found duplicates
  SudokuRange status;
  std::fill(status.begin(), status.end(), 0);

  return false;
}

int main(int argc, char **argv) {

  // clang-format off
  auto good = vector<int>{5, 3, 0,  0, 7, 0,  0, 0, 0,
                          6, 0, 0,  1, 9, 5,  0, 0, 0,
                          0, 9, 8,  0, 0, 0,  0, 6, 0,

                          8, 0, 0,  0, 6, 0,  0, 0, 3,
                          4, 0, 0,  8, 0, 3,  0, 0, 1,
                          7, 0, 0,  0, 2, 0,  0, 0, 6,

                          0, 6, 0,  0, 0, 0,  2, 8, 0,
                          0, 0, 0,  4, 1, 9,  0, 0, 5,
                          0, 0, 0,  0, 8, 0,  0, 7, 9};

  auto bad = vector<int>{8, 3, 0,  0, 7, 0,  0, 0, 0,
                         6, 0, 0,  1, 9, 5,  0, 0, 0,
                         0, 9, 8,  0, 0, 0,  0, 6, 0,

                         8, 0, 0,  0, 6, 0,  0, 0, 3,
                         4, 0, 0,  8, 0, 3,  0, 0, 1,
                         7, 0, 0,  0, 2, 0,  0, 0, 6,

                         0, 6, 0,  0, 0, 0,  2, 8, 0,
                         0, 0, 0,  4, 1, 9,  0, 0, 5,
                         0, 0, 0,  0, 8, 0,  0, 7, 9};
  // clang-format on

  MPI_Init(&argc, &argv);
  int size, rank;

  assert(!MPI_Comm_size(MPI_COMM_WORLD, &size));
  assert(!MPI_Comm_rank(MPI_COMM_WORLD, &rank));

  if (rank > 27) {
    throw std::runtime_error("Rank greater than 27 is unsupported and doesn't "
                             "make sense for this problem.");
    return EXIT_FAILURE;
  }

  MPI_Barrier(MPI_COMM_WORLD);
  if (0 == rank)
    std::cout << "world size=" << size << "\n";
  MPI_Barrier(MPI_COMM_WORLD);

  if (0 == rank) {
    std::cout << (isgood(good, rank) ? "true" : "false") << "\n";
  } else {
    isgood(std::nullopt, rank);
  }

  MPI_Barrier(MPI_COMM_WORLD);
  MPI_Finalize();
  return EXIT_SUCCESS;
}
