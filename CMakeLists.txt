cmake_minimum_required(VERSION 3.0)

project(antares-deps NONE)

set(DEFAULT_BUILD_TYPE Release)

# Set Build Type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE ${DEFAULT_BUILD_TYPE})
endif()

if (DEFINED VCPKG_ROOT)
    include(${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake)
endif()

#CMake function to build dependancy from git
include("cmake/utils.cmake")

option(BUILD_ALL "Build all dependencies" OFF)
message(STATUS "Build all dependencies: ${BUILD_ALL}")

option(USE_ORTOOLS_STABLE "Use OR-Tools stable instead of RTE OR-Tools branch with Sirius support" OFF)
message(STATUS "Use OR-Tools stable instead of RTE OR-Tools branch with Sirius support: ${USE_ORTOOLS_STABLE}")

# IF BUILD_DEPS=ON THEN Force all BUILD_*=ON
include(CMakeDependentOption)

CMAKE_DEPENDENT_OPTION(BUILD_system "Build dependencies available on system package manager" OFF
		"NOT BUILD_ALL" ON)
        
CMAKE_DEPENDENT_OPTION(BUILD_not_system "Build dependencies not available on system package manager" ON
		"NOT BUILD_ALL" ON)

CMAKE_DEPENDENT_OPTION(BUILD_sirius "Build sirius solver dependency Library" OFF
		"NOT BUILD_not_system" ON)
message(STATUS "Build sirius solver: ${BUILD_sirius}")

CMAKE_DEPENDENT_OPTION(BUILD_coin "Build all COIN dependency Library" OFF
		"NOT BUILD_not_system" ON)
message(STATUS "Build Coin: ${BUILD_coin}")

option(BUILD_ortools "Build OR-Tools dependency Library" OFF)
message(STATUS "Build OR-Tools: ${BUILD_ortools}")

CMAKE_DEPENDENT_OPTION(BUILD_ZLIB "Build the ZLIB dependency Library" OFF
  "NOT BUILD_ortools" ON)
message(STATUS "Build ZLIB: ${BUILD_ZLIB}")

CMAKE_DEPENDENT_OPTION(BUILD_absl "Build the abseil-cpp dependency Library" OFF
  "NOT BUILD_ortools" ON)
message(STATUS "Build abseil-cpp: ${BUILD_absl}")

CMAKE_DEPENDENT_OPTION(BUILD_gflags "Build the gflags dependency Library" OFF
  "NOT BUILD_not_system" ON)
if(BUILD_ortools)
	SET(BUILD_gflags ON)
endif()
message(STATUS "Build gflags: ${BUILD_gflags}")

CMAKE_DEPENDENT_OPTION(BUILD_glog "Build the glog dependency Library" OFF
  "NOT BUILD_not_system" ON)
if(BUILD_ortools)
	SET(BUILD_glog ON)
endif()
message(STATUS "Build glog: ${BUILD_glog}")

CMAKE_DEPENDENT_OPTION(BUILD_Protobuf "Build the Protobuf dependency Library" OFF
  "NOT BUILD_ortools" ON)
message(STATUS "Build Protobuf: ${BUILD_Protobuf}")

CMAKE_DEPENDENT_OPTION(BUILD_CoinUtils "Build the CoinUtils dependency Library" OFF
  "NOT BUILD_coin" ON)
message(STATUS "Build CoinUtils: ${BUILD_CoinUtils}")

CMAKE_DEPENDENT_OPTION(BUILD_Osi "Build the Osi dependency Library" OFF
  "NOT BUILD_coin" ON)
message(STATUS "Build Osi: ${BUILD_Osi}")

CMAKE_DEPENDENT_OPTION(BUILD_Clp "Build the Clp dependency Library" OFF
  "NOT BUILD_coin" ON)
message(STATUS "Build Clp: ${BUILD_Clp}")

CMAKE_DEPENDENT_OPTION(BUILD_Cgl "Build the Cgl dependency Library" OFF
  "NOT BUILD_coin" ON)
message(STATUS "Build Cgl: ${BUILD_Cgl}")

CMAKE_DEPENDENT_OPTION(BUILD_Cbc "Build the Cbc dependency Library" OFF
  "NOT BUILD_coin" ON)
message(STATUS "Build Cbc: ${BUILD_Cbc}")

CMAKE_DEPENDENT_OPTION(BUILD_wxWidgets "Build wxWidgets dependency Library" OFF
  "NOT BUILD_system" ON)
message(STATUS "Build wxWidgets: ${BUILD_wxWidgets}")

CMAKE_DEPENDENT_OPTION(BUILD_BOOST "Download and build boost needed libraries" OFF 
  "NOT BUILD_system" ON)
message(STATUS "Build BUILD_BOOST: ${BUILD_BOOST}")

#Define install directory
if (NOT DEPS_INSTALL_DIR)
    SET(DEPS_INSTALL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../rte-antares-deps-${CMAKE_BUILD_TYPE})

else()
    if(NOT IS_ABSOLUTE ${DEPS_INSTALL_DIR})
        SET(DEPS_INSTALL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${DEPS_INSTALL_DIR})
    endif()    
endif()

message(STATUS "DEPS_INSTALL_DIR : ${DEPS_INSTALL_DIR}")

# Build Needed dependencies
list(APPEND CMAKE_PREFIX_PATH ${DEPS_INSTALL_DIR})

add_subdirectory(cmake/dependencies)
