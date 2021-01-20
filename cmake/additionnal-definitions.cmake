if(BUILD_curl OR USE_PRECOMPILED_EXT)

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

if(BUILD_OPENSSL OR USE_PRECOMPILED_EXT)

	if(WIN32 OR WIN64)
    	else()
		#find_package(OpenSSL doesn't indicate -ldl option
		SET(OPENSSL_LIBRARIES ${OPENSSL_LIBRARIES} "dl")    
	endif()
    
endif()

if(BUILD_wxWidgets OR USE_PRECOMPILED_EXT)

  # Define wxWidgets_ROOT_DIR
  set(wxWidgets_ROOT_DIR ${DEPS_INSTALL_DIR})

endif()