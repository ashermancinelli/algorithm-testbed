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

using Answer = vector<pair<int, int>>;

static void print_answer(const Answer &a) {
  for (const auto &[value, histogram] : a) {
    std::cout << value << " ";
    for (int i = 0; i < histogram; i++)
      std::cout << "*";
    std::cout << "\n";
  }
  std::cout << "\n";
}

int main(int argc, char **argv) {
  Kokkos::initialize(argc, argv);

  vector<vector<int>> problems{
      {4, 3, 7},
      {6},
      {5, 3, 4},
  };

  std::vector<Answer> answers;

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

      auto num_bins = std::accumulate(problem.begin(), problem.end(), 1,
                                      std::multiplies<int>());

      int_view bins("bins", num_bins);

      if (1 == problem.size()) {
        Answer a;
        // All values are 1
        for (int i = 1; i <= problem[0]; i++)
          a.push_back(pair<int, int>{i, 1});
        answers.push_back(a);
        continue;
      }

      // parallel_for(
      //     num_bins, KOKKOS_LAMBDA(const int i) { });
    }
  }

  for (const auto &ans : answers)
    print_answer(ans);

  Kokkos::finalize();
  return 0;
}
