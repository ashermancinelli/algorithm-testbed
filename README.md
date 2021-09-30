## RAJA and BQN examples

Write GPU-portable implementations of BQN solutions.

## Installation

This repo requires the following dependencies:

* Umpire
* RAJA
* CUDA

See [Umpire](https://github.com/LLNL/Umpire) and [RAJA](https://github.com/LLNL/RAJA)
repos for installation instructions.

Once dependencies have been installed, it should be this simple:

```console
$ mkdir build
$ cd build
$ cmake ..
$ make
```

From here, the drivers should be available under `build/src`.

## Why are array languages important to GPU programming?

* Array languages force you to think in terms of *operators* on *collections*
  instead of *operations* on *scalars*.
* GPU programming requires the same. You are not able to think in terms of
  sequential loops if you want to gain any performance.
* Leverage well-understood primitives
