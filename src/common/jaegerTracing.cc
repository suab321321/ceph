
#include <yaml-cpp/yaml.h>
#include <iostream>
#include "jaegerTracer.h"

void jTracer::loadYamlConfigFile(const char *filePath)
{
    auto yaml = YAML::LoadFile(filePath);
    jTracer::configuration = jaegertracing::Config::parse(yaml);
}

void jTracer::initTracer(const char *tracerName)
{
    auto tracer = jaegertracing::Tracer::make(
        tracerName,
        jTracer::configuration,
        jaegertracing::logging::consoleLogger());
    opentracing::Tracer::InitGlobal(
        std::static_pointer_cast<opentracing::Tracer>(tracer));
}
std::unique_ptr<opentracing::Span> newSpan(const char * spanName){
    auto Span=opentracing::Tracer::Global()->StartSpan(spanName);
    return std::move(Span);
}
std::unique_ptr<opentracing::Span> jTracer::childSpan(const char *spanName, const std::unique_ptr<opentracing::Span> &parentSpan)
{
    auto Span = opentracing::Tracer::Global()->StartSpan(spanName, {opentracing::ChildOf(&parentSpan->context())});
    return std::move(Span);
}
std::unique_ptr<opentracing::Span> jTracer::followUpSpan(const char *spanName, const std::unique_ptr<opentracing::Span> &parentSpan)
{
    auto Span = opentracing::Tracer::Global()->StartSpan(spanName, {opentracing::FollowsFrom(&parentSpan->context())});
    return std::move(Span);
}
