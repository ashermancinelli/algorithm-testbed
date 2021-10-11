#pragma once
#include "common-config.hpp"

#ifdef HAS_THRUST_CUDA
#define THRUST_LAMBDA [=] __host__ __device__
#else
#define THRUST_LAMBDA [=] __host__
#endif

#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/copy.h>
#include <thrust/fill.h>
#include <thrust/sequence.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/tuple.h>

using thrust::host_vector;
using thrust::device_vector;
