#pragma once
#include "common-config.hpp"

#ifdef HAS_THRUST_CUDA
#define THRUST_LAMBDA [=] __host__ __device__
#else
#define THRUST_LAMBDA [=] __host__
#endif

#include <thrust/copy.h>
#include <thrust/device_vector.h>
#include <thrust/fill.h>
#include <thrust/host_vector.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/memory.h>
#include <thrust/sequence.h>
#include <thrust/tuple.h>

using thrust::device_vector;
using thrust::host_vector;
