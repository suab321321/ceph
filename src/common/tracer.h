#ifndef TRACER_H_
#define TRACER_H_

#define SIGNED_RIGHT_SHIFT_IS 1
#define ARITHMETIC_RIGHT_SHIFT 1

#include <arpa/inet.h>
#include <yaml-cpp/yaml.h>

#include <jaegertracing/Tracer.h>
#include <jaegertracing/net/IPAddress.h>
#include <jaegertracing/net/Socket.h>

//forward declaration of req_state defined /rgw/rgw_common.h
struct req_state;

typedef std::unique_ptr<opentracing::Span> Span;

class Jager_Tracer{
  public:
    Jager_Tracer(){}
    ~Jager_Tracer(){
      if(this->tracer)
        this->tracer->Close();
    }

    bool init_tracer(const char* tracerName,const char* filePath){
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

//will be used throughout ceph to create spans
extern Jager_Tracer tracer;

// structure to manage spans to trace functions who have access to req_state in /rgw/*
struct req_state_span{
    req_state* state = nullptr;
    bool is_inserted = false;
    void set_req_state(req_state* _s);
    void set_span(Span& span);
    ~req_state_span();
};

/** Optional Paramter to function which will be traced */
struct optional_span{
    const Span& span;
    optional_span(const Span& _span) : span(_span) {}
};

//method to start tracing of a single Span
static inline void trace(Span& span, const optional_span& parent_span, const char* span_name)
{
    if(parent_span.span)
    {
      span = tracer.child_span(span_name, parent_span.span);
    }
}

//method to finish tracing of a single Span
static inline void finish_trace(Span& span)
{
    if(span){
      Span s = std::move(span);
      s->Finish();
    }
}

#endif
