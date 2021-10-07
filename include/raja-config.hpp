#pragma once

#include <RAJA/RAJA.hpp>
#include <umpire/Allocator.hpp>
#include <umpire/ResourceManager.hpp>

using RAJA::forall;
using RAJA::inclusive_scan_inplace;
using RAJA::RangeSegment;

#ifdef RAJA_CUDA_ACTIVE
using exec_space = RAJA::cuda_exec<128>;
using reduce_pol = RAJA::cuda_reduce;
#define LAMBDA [=] __device__
static const char mem_space[] = "UM";
#else
using exec_space = RAJA::seq_exec;
using reduce_pol = RAJA::seq_reduce;
#define LAMBDA [=]
static const char mem_space[] = "HOST";
#endif

#include "common-config.hpp"
