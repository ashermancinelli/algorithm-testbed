#include <host-config.hpp>
#include <optional>

static constexpr std::size_t shape = 9;
using Board = std::array<int, shape*shape>;

// https://leetcode.com/problems/valid-sudoku/discuss/1487300/C%2B%2B-EASY-TO-UNDERSTAND
auto isgood(Board board) -> bool {

  const auto blksz = static_cast<int>(std::sqrt(shape)); // we know our board is square
  const auto idx2 = [blksz] (int r, int c) { return (r*shape)+c; };
  const auto idx3 = [blksz] (int r, int c, int t) { return (r*shape+c)*shape+t; };

  // cartesian product iota
  auto cpi = [] (const int i) {
    auto ii = views::iota(0) | views::take(i);
    return views::cartesian_product(ii, ii) | to<vector>;
  };
  auto indices = cpi(shape);
  auto block_offsets = cpi(blksz);

  const auto tl = [=] (const int r) { return r-r%blksz; };

  // shape, for all the possible values // shape for the index in the type // 3 for the types
  auto bits = views::repeat(0) | views::take(shape*shape*3) | to<vector<int>>;

  auto chkcell = [=, &board, &bits] (const int r, const int c) {
    const auto value = board[idx2(r, c)];
    if (0==value) return;
    for(int i=0; i<shape; i++)
      bits[idx3(r, c, 0)] += static_cast<int>(value == board[idx2(r, i)]);
    for(int i=0; i<shape; i++)
      bits[idx3(r, c, 1)] += static_cast<int>(value == board[idx2(i, c)]);
    for(const auto& [dx, dy] : block_offsets)
      bits[idx3(r, c, 2)] += static_cast<int>(value == board[idx2(tl(r)+dy, tl(c)+dx)]);
  };

  for(const auto& [r, c] : indices)
    chkcell(r, c);

  const auto m = std::accumulate(bits.begin(), bits.end(), -1, max) - 1;
  return 0==m;
}

int main(int argc, char **argv) {

  // clang-format off
  auto good = Board{5, 3, 0,  0, 7, 0,  0, 0, 0,
                    6, 0, 0,  1, 9, 5,  0, 0, 0,
                    0, 9, 8,  0, 0, 0,  0, 6, 0,

                    8, 0, 0,  0, 6, 0,  0, 0, 3,
                    4, 0, 0,  8, 0, 3,  0, 0, 1,
                    7, 0, 0,  0, 2, 0,  0, 0, 6,

                    0, 6, 0,  0, 0, 0,  2, 8, 0,
                    0, 0, 0,  4, 1, 9,  0, 0, 5,
                    0, 0, 0,  0, 8, 0,  0, 7, 9};

  auto bad = Board{8, 3, 0,  0, 7, 0,  0, 0, 0,
                   6, 0, 0,  1, 9, 5,  0, 0, 0,
                   0, 9, 8,  0, 0, 0,  0, 6, 0,

                   8, 0, 0,  0, 6, 0,  0, 0, 3,
                   4, 0, 0,  8, 0, 3,  0, 0, 1,
                   7, 0, 0,  0, 2, 0,  0, 0, 6,

                   0, 6, 0,  0, 0, 0,  2, 8, 0,
                   0, 0, 0,  4, 1, 9,  0, 0, 5,
                   0, 0, 0,  0, 8, 0,  0, 7, 9};
  // clang-format on

  auto bool2str = [](bool b) { return b ? "true" : "false"; };
  std::cout << "good: " << bool2str(isgood(good)) << "\n"
            << "bad: " << bool2str(isgood(bad)) << "\n";

  return EXIT_SUCCESS;
}
