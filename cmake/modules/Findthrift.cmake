function(find_thrift)

find_file(thrift_INCLUDE_DIRS thrift/Thrift.h)
find_library(thrift_LIBRARIES libthrift.so)

if(EXISTS ${thrift_INCLUDE_DIRS} AND EXISTS ${thrift_LIBRARIES})
    message(STATUS "FOUND " ${thrift_INCLUDE_DIRS} " " ${thrift_LIBRARIES})
    add_library(thrift INTERFACE)
    set_target_properties(${thrift} PROPERTIES
        INTERFACE_LINK_LIBRARIES ${thrift_LIBRARIES}
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LOCATION ${thrift_LIBRARIES}
        INTERFACE_INCLUDE_DIRECTORIES ${thrift_INCLUDE_DIRS}
    )
else()
    message(STATUS "thrift not found")
endif()

endfunction()

