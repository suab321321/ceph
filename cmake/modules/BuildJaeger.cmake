# This module builds Jaeger after it's dependencies are installed and discovered
# OpenTracing: is built using cmake/modules/BuildOpenTracing.cmake
# Thrift: build using cmake/modules/Buildthrift.cmake
# yaml-cpp, nlhomann-json: are installed locally and then discovered using
# Find<package>.cmake
# Boost Libraries used for building thrift are build and provided by
# cmake/modules/BuildBoost.cmake

function(build_jaeger)
  include(Findjaeger)
  find_jaegertracing()
  message(STATUS ${Jaeger})
  if(NOT TARGET Jaeger)
    set(Jaeger_DOWNLOAD_DIR "${CMAKE_SOURCE_DIR}/src/jaegertracing")
    set(Jaeger_SOURCE_DIR "${CMAKE_SOURCE_DIR}/src/jaegertracing/jaeger-client-cpp")
    set(Jaeger_INSTALL_DIR "${CMAKE_BINARY_DIR}/external")
    set(Jaeger_BINARY_DIR "${Jaeger_INSTALL_DIR}/Jaeger")

    file(MAKE_DIRECTORY "${Jaeger_INSTALL_DIR}")
    set(Jaeger_CMAKE_ARGS -DCMAKE_POSITION_INDEPENDENT_CODE=ON
                          -DBUILD_SHARED_LIBS=ON
                          -DHUNTER_ENABLED=OFF
                          -DBUILD_TESTING=OFF
                          -DJAEGERTRACING_BUILD_EXAMPLES=OFF
                          -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/external
                          -DCMAKE_INSTALL_RPATH=${CMAKE_BINARY_DIR}/external
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE
                          -DOpenTracing_DIR=${CMAKE_SOURCE_DIR}/src/jaegertracing/opentracing-cpp
                          -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/external
                          -Dyaml-cpp_HOME=${CMAKE_BINARY_DIR}/external
                          -DTHRIFT_HOME=${CMAKE_BINARY_DIR}/external
                          -DOpenTracing_HOME=${CMAKE_BINARY_DIR}/external
                          -DCMAKE_FIND_ROOT_PATH=${CMAKE_SOURCE_DIR}/debian/tmp${CMAKE_BINARY_DIR}/external
                          -DCMAKE_INSTALL_LIBDIR=${CMAKE_BINARY_DIR}/external/lib)

      message(STATUS "DEPENDENCIES ${dependencies}")
      if(CMAKE_MAKE_PROGRAM MATCHES "make")
        # try to inherit command line arguments passed by parent "make" job
        set(make_cmd $(MAKE))
      else()
        set(make_cmd ${CMAKE_COMMAND} --build <BINARY_DIR> --config $<CONFIG> --target Jaeger)
      endif()
      set(install_cmd $(MAKE) install DESTDIR=)

      include(ExternalProject)
      ExternalProject_Add(Jaeger
        GIT_REPOSITORY https://github.com/ideepika/jaeger-client-cpp.git
        GIT_TAG "hunter-disabled"
        UPDATE_COMMAND ""
        INSTALL_DIR "${CMAKE_BINARY_DIR}/external"
        DOWNLOAD_DIR ${Jaeger_DOWNLOAD_DIR}
        SOURCE_DIR ${Jaeger_SOURCE_DIR}
        PREFIX ${Jaeger_INSTALL_DIR}
        CMAKE_ARGS ${Jaeger_CMAKE_ARGS}
        BINARY_DIR ${Jaeger_BINARY_DIR}
        BUILD_COMMAND ${make_cmd}
        INSTALL_COMMAND ${install_cmd}
        DEPENDS "${dependencies}"
        )
  else()
    message(STATUS "Pre-installed_JaegerTracer")
  endif()
endfunction()