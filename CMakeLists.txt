project(antares-deps)
cmake_minimum_required(VERSION 3.0)

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
        
CMAKE_DEPENDENT_OPTION(BUILD_not_system "Build dependencies not available on system package manager" OFF
		"NOT BUILD_ALL" ON)

CMAKE_DEPENDENT_OPTION(BUILD_sirius "Build sirius solver dependency Library" OFF
		"NOT BUILD_not_system" ON)
message(STATUS "Build sirius solver: ${BUILD_sirius}")

CMAKE_DEPENDENT_OPTION(BUILD_ortools "Build BUILD_ortools dependency Library" OFF
		"NOT BUILD_not_system" ON)
message(STATUS "Build OR-Tools: ${BUILD_ortools}")

CMAKE_DEPENDENT_OPTION(BUILD_wxWidgets "Build wxWidgets dependency Library" OFF
  "NOT BUILD_system" ON)
message(STATUS "Build wxWidgets: ${BUILD_wxWidgets}")

CMAKE_DEPENDENT_OPTION(BUILD_OPENSSL "Build OpenSSL dependency Library" OFF
  "NOT BUILD_system" ON)
message(STATUS "Build BUILD_OPENSSL: ${BUILD_OPENSSL}")

CMAKE_DEPENDENT_OPTION(BUILD_curl "Build curl dependency Library" OFF
  "NOT BUILD_system" ON)
message(STATUS "Build BUILD_curl: ${BUILD_curl}")

CMAKE_DEPENDENT_OPTION(BUILD_zlib "Build zlib dependency Library" OFF
  "NOT BUILD_system" ON)
message(STATUS "Build BUILD_zlib: ${BUILD_zlib}")

CMAKE_DEPENDENT_OPTION(BUILD_BOOST "Download and build boost needed libraries" OFF 
  "NOT BUILD_system" ON)
message(STATUS "Build BUILD_BOOST: ${BUILD_BOOST}")

#Define install directory
if (NOT DEPS_INSTALL_DIR)
    SET(DEPS_INSTALL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../rte-antares-${CMAKE_BUILD_TYPE})

else()
    if(NOT IS_ABSOLUTE ${DEPS_INSTALL_DIR})
        SET(DEPS_INSTALL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${DEPS_INSTALL_DIR})
    endif()    
endif()


# Build Needed dependencies
list(APPEND CMAKE_PREFIX_PATH ${DEPS_INSTALL_DIR})

add_subdirectory(cmake/dependencies)


#Add specific definition in case of dependencies build

if(BUILD_curl)

	# ADD CURL_STATICLIB definition 
	add_definitions(-DCURL_STATICLIB) 
	
	if(WIN32 OR WIN64)
	
		#Linking not working on windows need to add several system dependency
		SET(CURL_LIBRARIES ${CURL_LIBRARIES} "Ws2_32.Lib" "Wldap32.Lib" "Crypt32.Lib")
    else()
		
		#zlib
		find_package(ZLIB REQUIRED)
	
		#find_package(CURL) doesn't indicate ZLIB and idn2 dependencies (idn2 used even with --without-libidn option in configure)
		SET(CURL_LIBRARIES ${CURL_LIBRARIES} ${ZLIB_LIBRARIES} idn2)    
	endif()	 
endif()

if(BUILD_OPENSSL)
	
	if(WIN32 OR WIN64)
    	else()
		#find_package(OpenSSL doesn't indicate -ldl option
		SET(OPENSSL_LIBRARIES ${OPENSSL_LIBRARIES} "dl")    
	endif()	 
endif()

if(BUILD_wxWidgets)
	# Define wxWidgets_ROOT_DIR
	set(wxWidgets_ROOT_DIR ${DEPS_INSTALL_DIR})
endif()