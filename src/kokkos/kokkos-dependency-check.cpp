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

int main(int, char **) {
  Kokkos::initialize();
  {
    // Create a view just to be sure it's working
    int_view dice("dice", 3);
  }
  Kokkos::finalize();
  return 0;
}
