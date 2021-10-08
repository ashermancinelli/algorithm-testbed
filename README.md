## Portable Algorithm Testbed

GPU-portable implementations of programming problems.
[See the `doc` directory for more.](./doc/README.md)

## Installation

This repo will use the following dependencies if found:

* Umpire
* RAJA
* CUDA
* Kokkos

See the references section below for documentation on each of these libraries.

Once dependencies have been installed, it should be this simple:

```console
$ mkdir build
$ cd build
$ cmake ..
$ make
```

From here, the drivers should be available under `build/src`.

### Dependency Installation with Spack

I use Spack to install the dependencies. If you would like to try it out, you
can use the following:

```console
git clone git@github.com:LLNL/spack.git
export PATH=$PWD/spack/bin:$PATH

# For CUDA
spack install kokkos+cuda+wrapper raja+cuda umpire+cuda

# For host
spack install kokkos raja umpire

# Add installations to your PATH/LD_LIBRARY_PATH/CMAKE_PREFIX_PATH
spack load kokkos raja umpire
```

## Purpose

GPU programming requires the developer to think in terms of operations on arrays.
Developers are used to operating on scalars. If developers have to operate on
colletions of items, the typical solution is to iterate over an array so the
developer can continue to think in terms of scalars.

Array programming languages require the developer to think in terms of
operations on arrays. This repo is a testbed to demonstrate how solutions to
programming problems in an array language may be ported to a GPU capable
solution.

### Why are array languages important to GPU programming?

* Array languages force you to think in terms of *operators* on *collections*
  instead of *operations* on *scalars*.
* GPU programming requires the same. You are not able to think in terms of
  sequential loops if you want to gain any performance.
* Leverage well-understood primitives
  * When we apply well-understood algorithms, we can leverage many years of cumulative research and development from vendors such as NVIDIA, Cray, AMD, etc

## References

* [Efficient Parallel Scan Algorithms for GPUs](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.163.847&rep=rep1&type=pdf)
* [Umpire](https://github.com/LLNL/Umpire)
* [RAJA](https://github.com/LLNL/RAJA)
* [CUDA](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
* [Kokkos](https://github.com/kokkos/kokkos)
* [Spack](https://spack.io/)
