#ifndef TRACER_H_
#define TRACER_H_

#define SIGNED_RIGHT_SHIFT_IS 1
#define ARITHMETIC_RIGHT_SHIFT 1

#include <arpa/inet.h>
#include <yaml-cpp/yaml.h>

#include <jaegertracing/Tracer.h>

#ifndef WITH_JAEGER
  #define WITH_JAEGER
#endif

typedef std::shared_ptr<opentracing::Span> Span;

class Jager_Tracer{
  public:
    Jager_Tracer(){}
    ~Jager_Tracer(){
      if(this->tracer)
        this->tracer->Close();
    }

    void init_tracer(const char* tracerName,const char* filePath){
        auto yaml = YAML::LoadFile(filePath);
        auto configuration = jaegertracing::Config::parse(yaml);
        this->tracer = jaegertracing::Tracer::make(
        tracerName,
        configuration,
        jaegertracing::logging::consoleLogger());
        opentracing::Tracer::InitGlobal(
        std::static_pointer_cast<opentracing::Tracer>(tracer));
    }
    inline void finish_tracer(){
      if(this->tracer)
      	this->tracer->Close();
    }
    Span new_span(const char* spanName)const{
      Span span=opentracing::Tracer::Global()->StartSpan(spanName);
      return std::move(span);
    }
    Span child_span(const char* spanName,const Span& parentSpan)const{
      Span span = opentracing::Tracer::Global()->StartSpan(spanName, {opentracing::ChildOf(&parentSpan->context())});
      return std::move(span);
    }
    Span followup_span(const char *spanName, const Span& parentSpan)const{
    Span span = opentracing::Tracer::Global()->StartSpan(spanName, {opentracing::FollowsFrom(&parentSpan->context())});
    return std::move(span);
  }
private:
  std::shared_ptr<opentracing::v2::Tracer> tracer = NULL;
};

#endif
