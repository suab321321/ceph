function(find_jaegertracing)
    find_file(jaegertracing_INCLUDE_DIRS jaegertracing/Tracer.h)
    find_library(jaegertracing_LIBRARIES libjaegertracing.so)

    if(EXISTS ${jaegertracing_INCLUDE_DIRS} AND EXISTS ${jaegertracing_LIBRARIES})
        message(STATUS "FOUND " ${jaegertracing_INCLUDE_DIRS} " " ${jaegertracing_LIBRARIES})
        add_library(Jaeger INTERFACE)
        set_target_properties(${Jaeger} PROPERTIES
            INTERFACE_LINK_LIBRARIES ${jaegertracing_LIBRARIES}
            IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
            IMPORTED_LOCATION ${jaegertracing_LIBRARIES}
            INTERFACE_INCLUDE_DIRECTORIES ${jaegertracing_INCLUDE_DIRS}
        )
    endif()
endfunction(find_jaegertracing)

