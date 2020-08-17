
find_path(yaml-cpp_INCLUDE_DIRS yaml-cpp/yaml.h)
find_library(yaml-cpp_LIBRARIES libyaml-cpp.so.0.6.2)

if(EXISTS ${yaml-cpp_INCLUDE_DIRS} AND EXISTS ${yaml-cpp_LIBRARIES})
  message(STATUS "FOUND " ${yaml-cpp_INCLUDE_DIRS} " " ${yaml-cpp_LIBRARIES})
  set(YAML_CPP_FOUND true)
  add_library(yaml-cpp INTERFACE)
else()
  set(YAML_CPP_FOUND false)
endif()
