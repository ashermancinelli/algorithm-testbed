#include <Kokkos_Core.hpp>
#include <Kokkos_Parallel.hpp>
#include <Kokkos_View.hpp>

using Device = Kokkos::DefaultExecutionSpace;
using Kokkos::View;
using Kokkos::parallel_for;
using Kokkos::create_mirror_view;
using Kokkos::deep_copy;
using Kokkos::parallel_scan;
using Kokkos::parallel_reduce;

#include "common-config.hpp"
