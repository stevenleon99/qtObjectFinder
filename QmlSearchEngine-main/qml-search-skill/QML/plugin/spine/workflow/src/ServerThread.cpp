#include <spineplugin/ServerThread.hpp>
#include <procd/spine/grpcservices/GrpcServiceFactory.hpp>

#include <gm/util/grpc/util.h>
#include <gm/util/grpc/consul.h>

#include <sys/log.h>

#include <chrono>

namespace spineplugin {

ServerThread::ServerThread(
    std::vector<std::shared_ptr<gm::util::grpc::GrpcServiceBase>> mainServices, QObject* parent)
    : QThread(parent)
    , m_server(std::make_unique<gm::util::grpc::ServiceServer>(
          "0.0.0.0", 9090, ::grpc::InsecureServerCredentials()))
    , m_services(std::move(mainServices))
    , m_shouldStop(false)
{}

ServerThread::~ServerThread()
{
    stopServer();
    wait();
    SYS_LOG_INFO("Server Thread destroyed");
}

void ServerThread::stopServer()
{
    if (m_server)
    {
        SYS_LOG_INFO("GRPC server shutdown called");
        for (auto&& service : m_services)
        {
            service->globalShutdown();
        }
        m_server->stop(std::chrono::system_clock::now() +
                       std::chrono::milliseconds(500));  // stop the server
    }
    m_shouldStop.store(true);
}

void ServerThread::run()
{
    SYS_LOG_INFO("ServerThread thread ID: {}", std::this_thread::get_id());

    for (auto&& service : m_services)
    {
        m_server->addService(std::string(service->getName()), service->getGrpcService());
    }

    if (!m_shouldStop.load())
    {
        SYS_LOG_INFO("grpc server is starting");
        if (!m_server->buildAndRun())  // Blocking call
        {
            SYS_LOG_ERROR("Failed to start grpc server");
        }
    }
    SYS_LOG_INFO("ServerThread has finished execution");
}

}  // namespace spineplugin
