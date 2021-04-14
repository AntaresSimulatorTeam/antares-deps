##############
##  wxWidgets  ##
##############
if(BUILD_wxWidgets)

#Check if wxWidgets is not already available
find_package(wxWidgets)

#If wxWidgets is not found it could mean that precompiled librairies are used : Define wxWidgets_ROOT_DIR and check again
if (NOT wxWidgets_FOUND)
    set(wxWidgets_ROOT_DIR ${DEPS_INSTALL_DIR})
    find_package(wxWidgets)
endif()

if (NOT wxWidgets_FOUND)

  build_git_dependency(
    NAME
      wxWidgets
    REPOSITORY
      "https://github.com/wxWidgets/wxWidgets.git"
    TAG
      "v3.1.3"
    CMAKE_ARGS
      "-DwxBUILD_SHARED=OFF"
  )
  
endif()

endif()

#####################
##  Sirius solver  ##
#####################
if(BUILD_sirius)

#Check if sirius is already available
find_package(sirius_solver)

if (NOT sirius_solver_FOUND)
build_git_dependency(
    NAME
      sirius
    REPOSITORY
      "https://github.com/AntaresSimulatorTeam/sirius-solver.git"
    TAG
      "Antares_VCPKG"
    SOURCE_SUBDIR
      "src"
  )
endif()
  
endif()

#####################
##  OR-TOOLS       ##
#####################
if(BUILD_ortools)

#Check if ortools is already available
find_package(ortools)

if(NOT ortools_FOUND)

if (USE_ORTOOLS_STABLE)
	set(REPOSITORY "https://github.com/google/or-tools.git")
	set(TAG "stable")
    set(CMAKE_ARGS "")
else()
    set(REPOSITORY "https://github.com/AntaresSimulatorTeam/or-tools.git")
    set(TAG "rte_dev_sirius")
    set(CMAKE_ARGS "-DUSE_SIRIUS=ON")
endif()

build_git_dependency(
    NAME
      or-tools
    REPOSITORY
      ${REPOSITORY}
    TAG
      ${TAG}
    CMAKE_ARGS
      "${CMAKE_ARGS} -DUSE_COINOR=ON -DBUILD_PYTHON=OFF -DBUILD_TESTING=OFF -DBUILD_DEPS=ON -DBUILD_SAMPLES=OFF -DBUILD_EXAMPLES=OFF -DBUILD_FLATZINC=OFF"
  )
endif()

endif()

if(BUILD_BOOST)
	message("")
	message("**********************************************************************")
	message("** Download, build and installation of Boost ...")
	message("**********************************************************************")

	# Creating the cmake file that is about to download, build and install boost
	configure_file(
		${CMAKE_CURRENT_SOURCE_DIR}/boost/CMakeLists.txt.in
		${CMAKE_CURRENT_BINARY_DIR}/boost/CMakeLists.txt @ONLY
		)

	# Configuration step of the previously created cmake file
	execute_process(
		COMMAND ${CMAKE_COMMAND} -H. -B project_build -G "${CMAKE_GENERATOR}"
		RESULT_VARIABLE result
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/boost
		)
	if(result)
		message(FATAL_ERROR "CMake configuration step for Boost Test failed: ${result}")
	endif()

	# Build step of the previously created cmake file (download, build and install are processed here)
	execute_process(
		COMMAND ${CMAKE_COMMAND} --build project_build --config ${CMAKE_BUILD_TYPE}
		RESULT_VARIABLE result
		WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/boost
		)
	if(result)
		message(FATAL_ERROR "CMake build step for Boost Test failed: ${result}")
	endif()

	message("**********************************************************************")
	message("** Finished download, build and installation of Boost.")
	message("**********************************************************************")
	message("")
endif()


