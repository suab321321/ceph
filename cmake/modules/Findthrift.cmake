function(find_thrift)

find_file(thrift_INCLUDE_DIRS thrift/Thrift.h PATHS "${CMAKE_BINARY_DIR}/external/include" NO_DEFAULT_PATH)
find_library(thrift_LIBRARIES libthrift.so PATHS "${CMAKE_BINARY_DIR}/external/lib" NO_DEFAULT_PATH)

if(EXISTS ${thrift_INCLUDE_DIRS} AND EXISTS ${thrift_LIBRARIES})
    message(STATUS "FOUND " ${opentracing_INCLUDE_DIRS} " " ${thrift_LIBRARIES})
    add_library(thrift INTERFACE)
    set_target_properties(${thrift} PROPERTIES
        INTERFACE_LINK_LIBRARIES ${thrift_LIBRARIES}
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LOCATION ${thrift_LIBRARIES}
        INTERFACE_INCLUDE_DIRECTORIES ${opentracing_INCLUDE_DIRS}
    )
else()
    message(STATUS "opentracing not found")
endif()
    
endfunction()
