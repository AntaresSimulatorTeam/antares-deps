#####################
##  minizip-ng  ##
#####################
find_package(minizip-ng)
if(NOT minizip-ng_FOUND)
    set(REPOSITORY "https://github.com/zlib-ng/minizip-ng.git")
        set(TAG "3.0.6")
        set(CMAKE_ARGS_MZ "-DCMAKE_INSTALL_PREFIX=${DEPS_INSTALL_DIR} -DMZ_LZMA=OFF -DMZ_ZSTD=OFF -DMZ_BZIP2=OFF -DMZ_PKCRYPT=OFF -DMZ_WZAES=OFF -DMZ_OPENSSL=OFF -DMZ_ICONV=OFF -DMZ_COMPAT=OFF")

        build_git_dependency(
            NAME
            minizip-ng
            REPOSITORY
            ${REPOSITORY}
            TAG
            ${TAG}
            CMAKE_ARGS
            "${CMAKE_ARGS_MZ} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
        )

endif()
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
            ${sirius_solver_REPO}
        TAG
            ${sirius_solver_TAG}
        SOURCE_SUBDIR
            "src"
        )
    endif()

endif()

##############
##  GFLAGS  ##
##############
if(BUILD_gflags)
    # On Windows, when configuring "glog" or "gflags", a path to <package>-config.cmake is stored
    # under the form of a registry key (HKEY_CURRENT_USER\Software\Kitware\CMake\Packages\<PackageName>).
    # A a consequence, when deploying/installing another version of antares-deps, supposed to be 
    # completely independent, an already compiled package ("glog" or "gflags") is found by the 
    # find_package(<PackageName>) in the Windows registry.
    # As we can't make packages "glog" or "gflags" not to store paths in the Windows' registry, 
    # we tell find_package(<PackageName>) not to search in registry, by using NO_CMAKE_PACKAGE_REGISTRY option.
    find_package(gflags NO_CMAKE_PACKAGE_REGISTRY)

    if(NOT gflags_FOUND)
        build_git_dependency(
        NAME
            gflags
        REPOSITORY
            "https://github.com/gflags/gflags.git"
        TAG
            "v2.2.2"
        CMAKE_ARGS
            -DINSTALL_SHARED_LIBS:BOOL=OFF
            -DBUILD_STATIC_LIBS:BOOL=ON
            -DINSTALL_STATIC_LIBS:BOOL=ON
        )

    endif()
endif()

############
##  GLOG  ##
############
if(BUILD_glog)
    find_package(glog NO_CMAKE_PACKAGE_REGISTRY)

    if(NOT glog_FOUND)
        build_git_dependency(
        NAME
            glog
        REPOSITORY
            "https://github.com/google/glog.git"
        TAG
            "v0.4.0"
        CMAKE_ARGS
            -DWITH_GFLAGS:BOOL=OFF
        )
    endif()
endif()

#################
##  Coinutils  ##
#################
if(BUILD_CoinUtils)
    find_package(CoinUtils)

    if(NOT CoinUtils_FOUND)
        build_git_dependency(
        NAME
            CoinUtils
        REPOSITORY
            "https://github.com/Mizux/CoinUtils.git"
        TAG
            "stable/2.11"
        )
    endif()
endif()

###########
##  Osi  ##
###########
if(BUILD_Osi)

    find_package(Osi)

    if(NOT Osi_FOUND)

        build_git_dependency(
        NAME
            Osi
        REPOSITORY
            "https://github.com/Mizux/Osi.git"
        TAG
            "stable/0.108"
        )
    endif()
endif()

###########
##  Clp  ##
###########
if(BUILD_Clp)

    find_package(Clp)

    if(NOT Clp_FOUND)
        build_git_dependency(
        NAME
            Clp
        REPOSITORY
            "https://github.com/Mizux/Clp.git"
        TAG
            "stable/1.17"
        )
    endif()

endif()

###########
##  Cgl  ##
###########
if(BUILD_Cgl)

    find_package(Cgl)

    if(NOT Cgl_FOUND)
        build_git_dependency(
        NAME
            Cgl
        REPOSITORY
            "https://github.com/Mizux/Cgl.git"
        TAG
            "stable/0.60"
        )
    endif()

endif()

###########
##  Cbc  ##
###########
if(BUILD_Cbc)

    find_package(Cbc)

    if(NOT Cbc_FOUND)
        build_git_dependency(
        NAME
            Cbc
        REPOSITORY
            "https://github.com/Mizux/Cbc.git"
        TAG
            "stable/2.10"
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


