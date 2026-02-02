#pragma once

#include <QObject>
#include <QThread>

#include <grpcpp/grpcpp.h>

#include <gm/util/grpc/grpcServiceBase.h>
#include <gm/util/grpc/util.h>

namespace spineplugin {

using GrpcServices = std::vector<std::shared_ptr<gm::util::grpc::GrpcServiceBase>>;

class ServerThread : public QThread
{
    Q_OBJECT

public:
    explicit ServerThread(GrpcServices mainServices, QObject* parent = nullptr);

    ~ServerThread();

    void stopServer();

protected:
    void run() override;

private:
    std::shared_ptr<gm::util::grpc::ServiceServer> m_server;
    GrpcServices m_services;
    std::atomic<bool> m_shouldStop;
};

}  // namespace spineplugin
