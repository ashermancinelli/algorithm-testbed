# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added 

- ASM targets
- Better formatting targets

### Changed

- Cleaned up the example infrastructure to better support custom targets like ASM and COBOL
- Applied formatters now that formatting targets are working

## [v0.2.2] 10-18-2021

### Added

- Linting targets for python, cmake, and C/C++
- Python examples
- CMake examples
- Cobol infrastructure

### Changed

- Broke top-level CMake script into many smaller scripts

## [v0.2.1] - 10-16-2021

### Changed

- The repository name to "Algorithm Testbed"

### Added

- Docs in preparation for HPC YT video
- Infrastructure for algol 68 examples

## [v0.2.0] - 10-14-2021

### Added

- Documentation subdirectory
- Finished distributed, cuda enabled valid sudoku checker

### Changed

- Layout of Fortran code. Shared module exists in the include directory, and is given to each consumer targets.
- Revamped build system.

## [v0.1.2] - 10-8-2021

### Added

- Documentation about the purpose of the repo

### Changed

- Name of repo to "portable-algorithm-testbed"
- Common header layout
- Correctly handle packages not being found
- Fix host kokkos code

## [v0.1.1] - 10-7-2021

### Added

- better installation instructions, documentation

## [v0.1.0] - 10-7-2021

### Added

- Kokkos examples
- RAJA example
- Moved headers into separate include directory
- added ranges-v3 to host third party libraries
