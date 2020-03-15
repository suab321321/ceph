

#ifndef JAEGER_TRACER_
#define JAEGER_TRACER_

#include <memory>
#include<jaegertracing/Tracer.h>
#include <opentracing/tracer.h>

class jTracer
{
private:
    static jaegertracing::Config configuration;
public:
    jTracer() {}
    static void loadYamlConfigFile(const char *);
    void initTracer(const char *);
    std::unique_ptr<opentracing::Span> newSpan(const char *);
    std::unique_ptr<opentracing::Span> childSpan(const char *, const std::unique_ptr<opentracing::Span> &);
    std::unique_ptr<opentracing::Span> followUpSpan(const char *, const std::unique_ptr<opentracing::Span> &);
    ~jTracer(){
        opentracing::Tracer::Global()->Close();
    }
};

#endif