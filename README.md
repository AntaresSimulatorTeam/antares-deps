# Antares dependencies build

 ANTARES Simulation and antaresXpansion depends on severals mandatory libraries.
 - [Sirius Solver](https://github.com/AntaresSimulatorTeam/sirius-solver/tree/Antares_VCPKG) (fork from [RTE](https://github.com/rte-france/sirius-solver/tree/Antares_VCPKG))
 - [OR-Tools](https://github.com/AntaresSimulatorTeam/or-tools/tree/rte_dev_sirius) (fork from [RTE](https://github.com/rte-france/or-tools/tree/rte_dev_sirius) based on official OR-Tools github)
 - [wxWidgets](https://github.com/wxWidgets/wxWidgets)
 (Only for the complete Antares Simulator solution with GUI)
 - Boost libraries: test process filesystem regex dll (Only for unit tests)

This repository is used to compile these libraries from sources.

We can distinguish 2 kind of libraries:
- system libraries: wxWidgets, Boost
Theses libraries can be installed from a package manager (apt-get for debian, yum for centos and vcpkg for windows)
- solver libraries: Sirius Solver, OR-Tools
Theses libraries can't be installed from a package manager. They must be compiled from sources.

## Choose built libraries
You can choose built librairies with these options :

|Option | Description | Default |
|:-------|-------|-------|
|`BUILD_ALL`|Enable build of ALL external librairies| `OFF`|
|`BUILD_not_system`|Enable build of external librairies not available on system package manager | `ON`|
|`BUILD_sirius`|Build Sirius solver | `OFF` (`ON` if `BUILD_not_system`)|
|`BUILD_ortools`|Build OR-Tools | `OFF`|
|`BUILD_coin`|Build all COIN librairies | `OFF` (`ON` if `BUILD_not_system`)|
|`BUILD_ZLIB`|Build OR-Tools | `OFF` (`ON` if `BUILD_ortools`)|
|`BUILD_absl`|Build OR-Tools | `OFF` (`ON` if `BUILD_ortools`)|
|`BUILD_gflags`|Build OR-Tools | `OFF` (`ON` if `BUILD_ortools`)|
|`BUILD_glog`|Build OR-Tools | `OFF` (`ON` if `BUILD_ortools`)|
|`BUILD_Protobuf`|Build OR-Tools | `OFF` (`ON` if `BUILD_ortools`)|
|`BUILD_CoinUtils`|Build OR-Tools | `OFF` (`ON` if `BUILD_coin`)|
|`BUILD_Osi`|Build OR-Tools | `OFF` (`ON` if `BUILD_coin`)|
|`BUILD_Clp`|Build OR-Tools | `OFF` (`ON` if `BUILD_coin`)|
|`BUILD_Cgl`|Build OR-Tools | `OFF` (`ON` if `BUILD_coin`)|
|`BUILD_Cbc`|Build OR-Tools | `OFF` (`ON` if `BUILD_coin`)|
|`BUILD_wxWidgets`|Build wxWidgets | `OFF`|
|`BUILD_BOOST`|Build Boost | `OFF`|

Libraries are compiled with static option (except for Sirius solver because OR-Tools use of shared version of Sirius solver).

## CMake configure option

Here is a list of other available CMake configure option :

|Option | Description | Default |
|:-------|-------|-------|
|`CMAKE_BUILD_TYPE` |Define build type. Available values are `Release` and `Debug`  | `Release`|
|`DEPS_INSTALL_DIR`|Define libraries install directory| `<antares_deps_checkout_dir>/../rte-antares-deps-<build_type>`|
|`USE_ORTOOLS_STABLE`| Use `stable` branch of OR-Tools github instead of [fork from RTE](https://github.com/AntaresSimulatorTeam/or-tools/tree/rte_dev_sirius) with sirius solver support| `OFF`|

Note:
> `DEPS_INSTALL_DIR` is added to `CMAKE_PREFIX_PATH`

## Build
Build is done at CMake configure step :

`cmake -B _build -S . -DDEPS_INSTALL_DIR=<deps_install_dir>`

## Using pre-compiled Antares external libraries
When pre-compiled libraries are used to build Antares Simulator or antaresXpansion, some additionnal definitions are needed:
- wxWidgets

When running the CMake configure step for either Antares Simulator or antaresXpansion, an additionnal option is needed `-DUSE_PRECOMPILED_EXT=ON`.
The configuration step becomes

`cmake -B _build -S src -DDEPS_INSTALL_DIR=<deps_install_dir> -DUSE_PRECOMPILED_EXT=ON`
