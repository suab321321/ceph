
find_path(Jaeger_INCLUDE_DIRS jaegertracing/Tracer.h)
find_library(Jaeger_LIBRARIES libjaegertracing.so)

if(EXISTS ${Jaeger_INCLUDE_DIRS} AND EXISTS ${Jaeger_LIBRARIES})
    message(STATUS "FOUND " ${Jaeger_INCLUDE_DIRS} " " ${Jaeger_LIBRARIES})
    set(Jaeger_FOUND true)
    add_library(Jaeger INTERFACE)
else()
    set(Jaeger_FOUND false)
endif()

