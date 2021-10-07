## RAJA and BQN examples

GPU-portable implementations of programming problems.

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

## Installation with Spack

I use Spack to install the dependencies. If you would like to try it out, you
can use the following:

```console
git clone git@github.com:LLNL/spack.git
export PATH=$PWD/spack/bin:$PATH
spack install kokkos+cuda+wrapper raja+cuda umpire+cuda
spack load kokkos raja umpire
```

## Why are array languages important to GPU programming?

* Array languages force you to think in terms of *operators* on *collections*
  instead of *operations* on *scalars*.
* GPU programming requires the same. You are not able to think in terms of
  sequential loops if you want to gain any performance.
* Leverage well-understood primitives

## References

* [Umpire](https://github.com/LLNL/Umpire)
* [RAJA](https://github.com/LLNL/RAJA)
* [CUDA](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
* [Kokkos](https://github.com/kokkos/kokkos)
* [Spack](https://spack.io/)
