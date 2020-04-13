#ifndef TRACER_H_
#define TRACER_H_

#define SIGNED_RIGHT_SHIFT_IS 1
#define ARITHMETIC_RIGHT_SHIFT 1

#include <iostream>
#include <arpa/inet.h>
#include <yaml-cpp/yaml.h>

#include <jaegertracing/Tracer.h>

#ifndef WITH_JAEGER
  #define WITH_JAEGER
#endif

// class JTracer {

// public:
// static void setUpTracer(const char* serviceToTrace) {
//   static auto configYAML = YAML::LoadFile("../jaegertracing/config.yml");
//   static auto config = jaegertracing::Config::parse(configYAML);
//   static auto tracer = jaegertracing::Tracer::make(
//       serviceToTrace, config, jaegertracing::logging::consoleLogger());
//   opentracing::Tracer::InitGlobal(
//       std::static_pointer_cast<opentracing::Tracer>(tracer));
// }

// static jspan tracedSubroutine(
//     jspan& parentSpan,
//     const char* subRoutineContext) {
//   auto span = opentracing::Tracer::Global()->StartSpan(
//       subRoutineContext, {opentracing::ChildOf(&parentSpan->context())});
//   span->Finish();
//   return span;
// }

// static jspan tracedFunction(const char* funcContext) {
//   auto span = opentracing::Tracer::Global()->StartSpan(funcContext);
//   span->Finish();
//   return span;
// }

// static std::string inject(jspan& span, const char* name) {
//   std::stringstream ss;
//   if (!span) {
//     auto span = opentracing::Tracer::Global()->StartSpan(name);
//   }
//   auto err = opentracing::Tracer::Global()->Inject(span->context(), ss);
//   assert(err);
//   return ss.str();
// }

// static jspan extract(const char* name,
// 	     std::string t_meta) {
//   std::stringstream ss(t_meta);
//   //    if(!tracer){
//   //    }
//   // setUpTracer("Extract-service");
//   auto span_context_maybe = opentracing::Tracer::Global()->Extract(ss);
//   assert(span_context_maybe);

//   // Propogation span
//   auto span = opentracing::Tracer::Global()->StartSpan(
//       "propagationSpan", {ChildOf(span_context_maybe->get())});
//   span->Finish();

//   return span;
// }

// };

typedef std::unique_ptr<opentracing::Span> Span;

class JTracer{
  public:
    JTracer(){}
    ~JTracer(){
      if(!this->isTracerClosed)
        this->tracer->Close();
        this->isTracerClosed=true;
    }
    // static void loadYamlConfiguration(const char *filePath){
    //   auto yaml=YAML::loadFile(filePath);
    //   auto configuration=jaegertracing::Config::parse(yaml);
    // }
    void initTracer(const char* tracerName,const char* filePath){
        auto yaml = YAML::LoadFile(filePath);
        auto configuration = jaegertracing::Config::parse(yaml);
        this->isTracerClosed=false;
        this->tracer = jaegertracing::Tracer::make(
        tracerName,
        configuration,
        jaegertracing::logging::consoleLogger());
        opentracing::Tracer::InitGlobal(
        std::static_pointer_cast<opentracing::Tracer>(tracer));
    }
    inline void finishTracer(){
      if(!this->isTracerClosed){
	 this->isTracerClosed=true;
	 this->tracer->Close();
       }
    }
    Span newSpan(const char* spanName){
      Span span=opentracing::Tracer::Global()->StartSpan(spanName);
      return std::move(span);
    }
    Span childSpan(const char* spanName,const Span& parentSpan){
      Span span = opentracing::Tracer::Global()->StartSpan(spanName, {opentracing::ChildOf(&parentSpan->context())});
      return std::move(span);
    }
    Span followUpSpan(const char *spanName, const Span& parentSpan){
    Span span = opentracing::Tracer::Global()->StartSpan(spanName, {opentracing::FollowsFrom(&parentSpan->context())});
    return std::move(span);
  }
private:
  std::shared_ptr<opentracing::v2::Tracer> tracer;
  bool isTracerClosed;
};

#endif
