## Algorithm Testbed

Implementations of programming problems, usually leveraging GPUs or distributed computing.
[See the `doc` directory for more.](./doc/README.md)
[See the CHANGELOG for version information and history.](./CHANGELOG.md)

## Installation

This repo will use the following dependencies if found:

* CUDA
* Thrust
* An MPI provider
* Kokkos
* Umpire
* RAJA
* Algol 68 Genie compiler

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
