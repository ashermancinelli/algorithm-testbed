#pragma once
#include "common-config.hpp"

#ifdef HAS_KOKKOS_CUDA
#define KOKKOS_LAMBDA [=] __device__
#else
#define KOKKOS_LAMBDA [=]
#endif

#include <Kokkos_Core.hpp>
#include <Kokkos_Parallel.hpp>
#include <Kokkos_View.hpp>

#ifdef HAS_KOKKOS_CUDA
using Device = Kokkos::CudaSpace;
#else
using Device = Kokkos::HostSpace;
#endif

using Kokkos::create_mirror_view;
using Kokkos::deep_copy;
using Kokkos::parallel_for;
using Kokkos::parallel_reduce;
using Kokkos::parallel_scan;
using Kokkos::View;
