function(find_opentracing)

find_file(opentracing_INCLUDE_DIRS opentracing/tracer.h PATHS "${CMAKE_BINARY_DIR}/external/include" NO_DEFAULT_PATH)
find_library(opentracing_LIBRARIES libopentracing.so PATHS "${CMAKE_BINARY_DIR}/external/lib" NO_DEFAULT_PATH)

if(EXISTS ${opentracing_INCLUDE_DIRS} AND EXISTS ${opentracing_LIBRARIES})
    message(STATUS "FOUND " ${opentracing_INCLUDE_DIRS} " " ${opentracing_LIBRARIES})
    add_library(OpenTracing INTERFACE)
    set_target_properties(${OpenTracing} PROPERTIES
        INTERFACE_LINK_LIBRARIES ${opentracing_LIBRARIES}
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LOCATION ${opentracing_LIBRARIES}
        INTERFACE_INCLUDE_DIRECTORIES ${opentracing_INCLUDE_DIRS}
    )
else()
    message(STATUS "opentracing not found")
endif()
    
endfunction()
