
find_path(thrift_INCLUDE_DIRS thrift/Thrift.h)
find_library(thrift_LIBRARIES libthrift.so)

if(EXISTS ${thrift_INCLUDE_DIRS} AND EXISTS ${thrift_LIBRARIES})
    message(STATUS "FOUND " ${thrift_INCLUDE_DIRS} " " ${thrift_LIBRARIES})
    set(thrift_FOUND true)
    add_library(thrift INTERFACE)
else()
    set(thrift_FOUND false)
endif()

