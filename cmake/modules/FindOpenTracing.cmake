
find_path(OpenTracing_INCLUDE_DIRS opentracing/tracer.h)
find_library(OpenTracing_LIBRARIES libopentracing.so)

if(EXISTS ${OpenTracing_INCLUDE_DIRS} AND EXISTS ${OpenTracing_LIBRARIES})
    message(STATUS "FOUND " ${OpenTracing_INCLUDE_DIRS} " " ${OpenTracing_LIBRARIES})
    set(OpenTracing_FOUND true)
    add_library(OpenTracing INTERFACE)
else()
    set(OpenTracing_FOUND false)
endif()
