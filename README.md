# Antares dependencies build

ANTARES depends on severals mandatory libraries.
 - [OpenSSL](https://github.com/openssl/openssl)
 - [CURL](https://github.com/curl/curl)
 - [Sirius Solver](https://github.com/AntaresSimulatorTeam/sirius-solver/tree/Antares_VCPKG) (fork from [RTE](https://github.com/rte-france/sirius-solver/tree/Antares_VCPKG))
 - [OR-Tools](https://github.com/AntaresSimulatorTeam/or-tools/tree/rte_dev_sirius) (fork from [RTE](https://github.com/rte-france/or-tools/tree/rte_dev_sirius) based on official OR-Tools github)
 - [wxWidgets](https://github.com/wxWidgets/wxWidgets)
 (Only for the complete Antares Simulator solution with GUI)
 - Boost libraries: test process filesystem regex dll (Only for unit tests)

This repository is used to compile these libraries from sources.

We can distinguish 2 kind of libraries:
- system libraries: OpenSSL, CURL, wxWidgets, Boost
Theses libraries can be installed from a package manager (apt-get for debian, yum for centos and vcpkg for windows)
- solver libraries: Sirius Solver, OR-Tools
Theses libraries can't be installed from a package manager. They must be compiled from sources.

## Choose built libraries
Dependency are built at configure time using the option: `-DBUILD_ALL=ON` (`OFF` by default) or you can compile few of them using the options below.

* OPENSSL (`BUILD_OPENSSL`)
* CURL (`BUILD_CURL`)
* wxWidgets (`BUILD_wxWidgets`)
* Sirius solver (`BUILD_sirius`)
* OR-Tools (`BUILD_ortools`)
* Boost (`BUILD_BOOST`)

Libraries are compiled with static option (except for Sirius solver).

Note:
> You can build all system libraries with : `-DBUILD_SYSTEM=ON` (default `OFF`)
> You can build libraries not available on system with `-DBUILD_not_system=ON` (default `ON`). Sirius solver and OR-Tools will be built.


## Defining dependency install directory
Dependency install directory can be specified with `DEPS_INSTALL_DIR`. By default install directory is `<antares_deps_checkout_dir>/../rte-antares-deps-<build_type>`

Note:
> `DEPS_INSTALL_DIR` is added to `CMAKE_PREFIX_PATH`

## Choose OR-Tools branch
OR-Tools stable branch can be used with `-DUSE_ORTOOLS_STABLE=ON` (`OFF` by default).
Otherwise a [fork from RTE](https://github.com/AntaresSimulatorTeam/or-tools/tree/rte_dev_sirius) is used.

## Using pre-compiled Antares external libraries
When pre-compiled libraries are used to build Antares Simulator or antaresXpansion, some additionnal definitions are needed:
- OPENSSL
- CURL
- wxWidgets

When running the CMake configure step for either Antares Simulator or antaresXpansion, an additionnal option is needed `-DUSE_PRECOMPILED_EXT=ON`.
The configuration step becomes

`cmake -B _build -S src -DDEPS_INSTALL_DIR=<deps_install_dir> -DUSE_PRECOMPILED_EXT=ON`
