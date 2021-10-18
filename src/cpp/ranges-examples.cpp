#include <common-config.hpp>
#include <range/v3/all.hpp>
using namespace ranges;

int main() {
  static constexpr auto size=9, work=81;
  const auto r = ranges::views::iota(0) | ranges::views::take(work) |
                 ranges::views::chunk(((work+size-1)/size));
  std::cout << (1+(work/size)) << " " << r << "\n";
  std::cout << r[4] << "\n";
  return 0;
}
