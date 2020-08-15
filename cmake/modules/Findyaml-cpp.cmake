
# function(find_yamlcpp)
#   message(STATUS "INSIDE FIND_YAML-CPP")
#   find_path(yaml-cpp_INCLUDE_DIRS yaml-cpp/yaml.h)
#   find_library(yaml-cpp_LIBRARIES libyaml-cpp.so.2)

#   if(EXISTS ${yaml-cpp_INCLUDE_DIRS} AND EXISTS ${yaml-cpp_LIBRARIES})
#     message(STATUS "FOUND " ${yaml-cpp_INCLUDE_DIRS} " " ${yaml-cpp_LIBRARIES})
#     add_library(yaml-cpp INTERFACE)
#     set_target_properties(${yaml-cpp} PROPERTIES
#       INTERFACE_LINK_LIBRARIES ${yaml-cpp_LIBRARIES}
#       IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
#       IMPORTED_LOCATION ${yaml-cpp_LIBRARIES}
#       INTERFACE_INCLUDE_DIRECTORIES ${yaml-cpp_INCLUDE_DIRS}
#     )
#   endif()
# endfunction()

function (find_yamlcpp)
  find_package(yaml-cpp)
  message(STATUS "finding yaml-cpp")
  if(${yaml-cpp_FOUND})
    message(STATUS "here yaml-cpp" ${YAML_CPP_INCLUDE_DIR} ${YAML_CPP_LIBRARIES})
  else()
    message(STATUS "not found yaml-cpp")
  endif()
endfunction()