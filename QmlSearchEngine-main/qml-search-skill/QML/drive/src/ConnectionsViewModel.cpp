/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include <ConnectionsViewModel.h>

#ifndef Q_MOC_RUN
#include <DriveAlerts.h>
#include <sys/alerts/AlertManagerFactory.h>
#include <gos/glink/util/GosPeer.h>
#endif

#include <gm/util/qt/qt_boost_signals2.h>
#include <gm/geom/qt/typeconv.h>
#include <QMetaEnum>
#include <QDebug>

namespace drive::viewmodel {

using namespace drive::alerts;

ConnectionsViewModel::ConnectionsViewModel(
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
    std::shared_ptr<sys::glink::IConnectionHandler> connectionHandler,
    std::shared_ptr<service::mirror::MirrorManager> mirrorManager,
    QObject* parent)
    : QObject(parent)
    , m_glinkConnectionHandler(connectionHandler)
    , m_alertViewRegistry(alertViewRegistry)
    , m_mirrorManager(mirrorManager)
    , m_alertManager(sys::alerts::AlertManagerFactory::createInstance())
{
    m_alertViewRegistry->addAlertView(m_alertManager);

    gm::util::qt::connect(m_glinkConnectionHandler->stateChanged, this,
                          &ConnectionsViewModel::updateGlinkConnectionState);

    gm::util::qt::connect(m_alertManager->clearRequested, this,
                          &ConnectionsViewModel::handleAlertResponse);

    m_mirrorManager->mirroringSessionStartError.connect([this]() {
        auto driveAlert = m_mirrorManager->usingGPS()
                              ? DriveAlerts::E3DScreenMirroringDisabled
                              : DriveAlerts::EGPSScreenMirroringDisabled;
        m_alertManager->createAlert(drive::alerts::alertsMap.at(driveAlert));
    });

    qDebug()
        << "Glink connection state initialized to "
        << QMetaEnum::fromType<ConnectionsViewModel::GlinkConnectionState>()
               .valueToKey(glinkConnectionState());

    updateGlinkConnectionState(m_glinkConnectionHandler->connectionState());
}

ConnectionsViewModel::GlinkConnectionState
ConnectionsViewModel::glinkConnectionState() const
{
    switch (m_glinkConnectionState)
    {
    case sys::glink::ConnectionState::Connected: return Connected;
    case sys::glink::ConnectionState::Disconnected: return Disconnected;
    case sys::glink::ConnectionState::Error: return Error;
    }

    return Disconnected;
};

void ConnectionsViewModel::handleAlertResponse(const sys::alerts::Alert& alert,
                                               const sys::alerts::Option&)
{
    if (alert == drive::alerts::alertsMap.at(
                     DriveAlerts::EGPSScreenMirroringDisabled) ||
        alert == drive::alerts::alertsMap.at(
                     DriveAlerts::E3DScreenMirroringDisabled))
    {
        m_alertManager->clearAlert(alert);
    }
}

void ConnectionsViewModel::updateGlinkConnectionState(
    sys::glink::ConnectionState connectionState)
{
    if (m_glinkConnectionState == connectionState)
        return;

    auto oldConnectionState = m_glinkConnectionState;
    m_glinkConnectionState = connectionState;
    qDebug()
        << "Glink connection state changed to "
        << QMetaEnum::fromType<ConnectionsViewModel::GlinkConnectionState>()
               .valueToKey(glinkConnectionState());

    if ((m_glinkConnectionState == sys::glink::ConnectionState::Error) ||
        (oldConnectionState == sys::glink::ConnectionState::Error))
    {
        updateGlinkErrorState();
    }

    Q_EMIT glinkConnectionStateChanged();
}

void ConnectionsViewModel::updateGlinkErrorState()
{
    auto errorState = m_glinkConnectionHandler->errorState();
    if (m_glinkErrorState == errorState)
        return;

    m_glinkErrorState = errorState;
    if (m_glinkErrorState == sys::glink::ErrorState::TooManyConnections)
    {
        m_alertManager->createAlert(
            drive::alerts::alertsMap.at(DriveAlerts::TooManyConnections));
    }
    else
    {
        m_alertManager->clearAlert(
            drive::alerts::alertsMap.at(DriveAlerts::TooManyConnections));
    }
}

ConnectionsViewModel::ConnectedPeerType
ConnectionsViewModel::connectedPeerType()
{
    auto connectedPeer = m_glinkConnectionHandler->connectedPeer();
    auto retPeerType = connectedPeer.has_value()
                           ? connectedPeer->type()
                           : gos::glink::util::SystemType::Unknown;
    auto newretPeerType =
        gm::util::typeconv::convert<ConnectionsViewModel::ConnectedPeerType>(
            retPeerType);
    qDebug() << "ConnectedPeerType =" << newretPeerType;
    if (m_connectedPeerType != newretPeerType)
    {
        m_connectedPeerType = newretPeerType;
        emit connectedPeerTypeChanged();
    }
    return m_connectedPeerType;
}


}  // namespace drive::viewmodel
