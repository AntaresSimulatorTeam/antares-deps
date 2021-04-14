if(BUILD_wxWidgets OR USE_PRECOMPILED_EXT)

  # Define wxWidgets_ROOT_DIR
  set(wxWidgets_ROOT_DIR ${DEPS_INSTALL_DIR})
  
  # Define specif wxWidget config option so wxWidget is found with find_package
  if (UNIX)
      set(wxWidgets_USE_STATIC ON)
      set(wxWidgets_CONFIG_EXECUTABLE ${DEPS_INSTALL_DIR}/bin/wx-config)
      set(wxWidgets_CONFIG_OPTIONS --prefix=${DEPS_INSTALL_DIR})
  endif()

endif()
