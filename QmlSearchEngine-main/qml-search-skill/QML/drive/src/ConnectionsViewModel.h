/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#ifndef Q_MOC_RUN
#include <sys/glink/IConnectionHandler.h>
#include <sys/alerts/itf/IAlertManager.h>
#include <sys/alerts/itf/IAlertAggregator.h>
#include <service/mirror/MirrorManager.h>
#endif

#include <QObject>

namespace drive::viewmodel {

class ConnectionsViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(GlinkConnectionState glinkConnectionState READ
                   glinkConnectionState NOTIFY glinkConnectionStateChanged)
    Q_PROPERTY(ConnectedPeerType connectedPeerType READ connectedPeerType NOTIFY
                   connectedPeerTypeChanged)

public:
    enum GlinkConnectionState
    {
        Connected = 0,
        Disconnected,
        Error
    };
    Q_ENUM(GlinkConnectionState)

    enum class ConnectedPeerType
    {
        Egps,
        E3d,
        Ehub,
        Laptop,
        Unknown
    };
    Q_ENUM(ConnectedPeerType)

    ConnectionsViewModel(
        std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
        std::shared_ptr<sys::glink::IConnectionHandler> connectionHandler,
        std::shared_ptr<service::mirror::MirrorManager> mirrorManager,
        QObject* parent = nullptr);

    GlinkConnectionState glinkConnectionState() const;
    ConnectedPeerType connectedPeerType();
signals:
    void glinkConnectionStateChanged();
    void connectedPeerTypeChanged();
private slots:
    void handleAlertResponse(const sys::alerts::Alert& alert,
                             const sys::alerts::Option&);

private:
    ConnectedPeerType m_connectedPeerType{ConnectedPeerType::Unknown};
    void updateGlinkConnectionState(
        sys::glink::ConnectionState connectionState);
    void updateGlinkErrorState();

    std::shared_ptr<sys::glink::IConnectionHandler> m_glinkConnectionHandler;
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> m_alertViewRegistry;
    std::shared_ptr<service::mirror::MirrorManager> m_mirrorManager;
    std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertManager;

    sys::glink::ConnectionState m_glinkConnectionState =
        sys::glink::ConnectionState::Disconnected;
    sys::glink::ErrorState m_glinkErrorState = sys::glink::ErrorState::None;
};

}  // namespace drive::viewmodel

namespace gm::util::typeconv {

template <>
struct Conversion<gos::glink::util::SystemType,
                  drive::viewmodel::ConnectionsViewModel::ConnectedPeerType>
{
    drive::viewmodel::ConnectionsViewModel::ConnectedPeerType operator()(
        gos::glink::util::SystemType type) const
    {
        using namespace gos::glink::util;
        using namespace drive::viewmodel;
        switch (type)
        {
        case SystemType::E3d:
            return ConnectionsViewModel::ConnectedPeerType::E3d;
        case SystemType::Egps:
            return ConnectionsViewModel::ConnectedPeerType::Egps;
        case SystemType::Ehub:
            return ConnectionsViewModel::ConnectedPeerType::Ehub;
        case SystemType::Laptop:
            return ConnectionsViewModel::ConnectedPeerType::Laptop;
        case SystemType::Unknown:
            return ConnectionsViewModel::ConnectedPeerType::Unknown;
        }
    }
};
}  // namespace gm::util::typeconv