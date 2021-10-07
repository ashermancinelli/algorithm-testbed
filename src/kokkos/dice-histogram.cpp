#include "kokkos-config.hpp"
#include <iostream>

using int_view = View<int *, Device>;
using real_view = View<int *, Device>;

/**
 *
 * BQN solution:
 *
 * F3 ⇐ {f↓˜+´⥊0=≠¨f←⍉(↕≠v)≍{"*"/˜𝕩}¨v←≠¨ ⊔ ∧ ⥊ +⌜´ 1⊸+↕ ¨⟨⟩∾𝕩}
 *
 */

struct Answer {
  std::vector<int> totals;
  std::vector<std::string> histogram;
};

int main(int, char **) {
  std::vector<std::vector<int>> problems{
      {4, 3, 7},
      {6},
      {5, 3, 4},
  };

  Kokkos::initialize();
  {
    for (const auto &problem : problems) {
      std::cout << "Generating histogram for dice with sides: ";
      print_container(problem);

      // Copy the problem to the GPU
      int_view dice("dice", problem.size());
      auto host_mirror = create_mirror_view(dice);
      for (int i = 0; i < problem.size(); i++)
        host_mirror(i) = problem[i];
      deep_copy(dice, host_mirror);
    }
  }
  Kokkos::finalize();
  return 0;
}
