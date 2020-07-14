#include "tracer.h"

Jager_Tracer::~Jager_Tracer()
{
    if(this->tracer)
        this->tracer->Close();
}

bool Jager_Tracer::init_tracer(const char* tracerName,const char* filePath){
    try{
        auto yaml = YAML::LoadFile(filePath);
        auto configuration = jaegertracing::Config::parse(yaml);

        jaegertracing::net::Socket socket;
        socket.open(AF_INET, SOCK_STREAM);
        const std::string serverURL = configuration.sampler().kDefaultSamplingServerURL; 
        socket.connect(serverURL); // this is used to check if the tracer is able to connect with server successfully

        this->tracer = jaegertracing::Tracer::make(
        tracerName,
        configuration,
        jaegertracing::logging::consoleLogger());
    }catch(...){
        return false;
    }
    opentracing::Tracer::InitGlobal(
    std::static_pointer_cast<opentracing::Tracer>(tracer));
    return true;
}

Span Jager_Tracer::new_span(const char* spanName)const{
    Span span=opentracing::Tracer::Global()->StartSpan(spanName);
    return span;
}

Span Jager_Tracer::child_span(const char* spanName,const Span& parentSpan)const{
      Span span = opentracing::Tracer::Global()->StartSpan(spanName, {opentracing::ChildOf(&parentSpan->context())});
      return span;
}

Span Jager_Tracer::followup_span(const char *spanName, const Span& parentSpan)const{
    Span span = opentracing::Tracer::Global()->StartSpan(spanName, {opentracing::FollowsFrom(&parentSpan->context())});
    return span;
}

Jager_Tracer tracer;
