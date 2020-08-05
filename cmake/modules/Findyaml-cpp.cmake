
function(find_yamlcpp)
  message(STATUS "INSIDE FIND_YAML-CPP")
  find_path(yaml-cpp_INCLUDE_DIRS yaml-cpp/yaml.h PATHS "${CMAKE_BINARY_DIR}/external/include" NO_DEFAULT_PATH)
  find_library(yaml-cpp_LIBRARIES libyaml-cpp.so  PATHS "${CMAKE_BINARY_DIR}/external/lib" NO_DEFAULT_PATH)

  if(EXISTS ${yaml-cpp_INCLUDE_DIRS} AND EXISTS ${yaml-cpp_LIBRARIES})
    message(STATUS "FOUND " ${yaml-cpp_INCLUDE_DIRS} " " ${yaml-cpp_LIBRARIES})
    add_library(yaml-cpp INTERFACE)
    set_target_properties(${yaml-cpp} PROPERTIES
      INTERFACE_LINK_LIBRARIES ${yaml-cpp_LIBRARIES}
      IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
      IMPORTED_LOCATION ${yaml-cpp_LIBRARIES}
      INTERFACE_INCLUDE_DIRECTORIES ${yaml-cpp_INCLUDE_DIRS}
    )
  endif()

  # if(yaml-cpp_INCLUDE_DIRS AND yaml-cpp_LIBRARIES)
  #   if(NOT TARGET yaml-cpp)
  #     add_library(yaml-cpp UNKNOWN IMPORTED)
  #     set_target_properties(yaml-cpp PROPERTIES
  #       INTERFACE_INCLUDE_DIRECTORIES "${yaml-cpp_INCLUDE_DIRS}"
  #       INTERFACE_LINK_LIBRARIES ${yaml-cpp_LIBRARIES}
  #       IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
  #       IMPORTED_LOCATION ${yaml-cpp_LIBRARIES})
  #   endif()
  #   message(STATUS ${yaml-cpp_INCLUDE_DIRS})
  #   set(yaml-cpp_PREINSTALLED true PARENT_SCOPE)
  # endif()

endfunction()