/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#include "NetworkSettingsViewModel.h"

#include <gm/util/qt/qt_boost_signals2.h>
#include <gm/util/typeconv.h>
#include <sys/config/config.h>
#include <sys/log.h>

#include <QDebug>
#include <QTimer>

using namespace drive::networksettings;
using namespace drive::alerts;

namespace drive::viewmodel {

NetworkSettingsViewModel::NetworkSettingsViewModel(
    const std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertVwr,
    const std::shared_ptr<drive::itf::settings::ISystemSettings> systemSettings)
    : m_systemSettings{systemSettings}
    , m_alertVwr{alertVwr}
{
    QRegularExpression rgx(
        "^((?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]|[3-9]?[0-9])\\.){3}(?:[0-1]"
        "?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]|[3-9]?[0-9])$");

    QRegularExpression ehubStaticRgx(
        "^([1][6][9]\\.[2][5][4]\\.)(([0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]|[3-"
        "9]?0-9])\\.)([0-1]?["
        "0-9]?[0-9]|2[0-4][0-9]|25[0-5]|[3-9]?[0-9])$");

    // We need to know if we are on an eHub as the behavior currently is a
    // little bit different for an eHub than the other systems because eHub has
    // an internal router and currently we don't have a way to pull information
    // from the router when connected to a LAN port (GLink). This means we need
    // to adjust the "Status" text accordingly.
    m_isEhub = sys::config::Config::instance()->platform.systemType() ==
               sys::config::SystemType::Ehub;


    m_IPExcluder = new QRegularExpressionValidator(ehubStaticRgx, this);

    m_validator = new QRegularExpressionValidator(rgx, this);


    gm::util::qt::connect(m_systemSettings->networkConfigurationReceived, this,
                          &drive::viewmodel::NetworkSettingsViewModel::
                              updateNetworkConfiguration);

    gm::util::qt::connect(
        m_systemSettings->isNetworkConnected, this,
        &drive::viewmodel::NetworkSettingsViewModel::updateNetworkStatus);


    // Make sure we don't display a "connected" alert when loading the page
    updateNetworkConfiguration();
    updateNetworkStatus(m_systemSettings->getCurrentConnectionState());

    // If the current address type is "static" then set the member variable
    if (m_ipAddressType == m_ipAddrTypeStr.first)
    {
        m_isStaticIP = true;
    }

    gm::util::qt::connect(
        m_systemSettings->stateChanged, this,
        &NetworkSettingsViewModel::updateGlinkConnectionStateChanged);

    // Make sure we don't display a "connected" alert when loading the page
    m_isFirstAlertConnected = true;
    updateGlinkConnectionStateChanged(m_systemSettings->connectionState());

    gm::util::qt::connect(m_systemSettings->peerChanged, this,
                          &NetworkSettingsViewModel::updatePeerChanged);

    updatePeerChanged(m_systemSettings->connectedPeer());

    gm::util::qt::connect(m_systemSettings->requestConfigState, this,
                          &NetworkSettingsViewModel::checkRequestState);


    gm::util::qt::connect(m_alertMgr->clearRequested, this,
                          &NetworkSettingsViewModel::handleAlertResponse);


    m_alertVwr->addAlertView(m_alertMgr);
    refreshFrontEnd();
}
void NetworkSettingsViewModel::handleAlertResponse(
    const sys::alerts::Alert& alert, const sys::alerts::Option& option)
{
    if ((drive::alerts::confirmOption.title == option.title) ||
        (drive::alerts::dismissOption.title == option.title))
    {
        m_alertMgr->clearAlert(alert);
    }
}
void NetworkSettingsViewModel::getUpdatedNwSettings()
{
    m_macAddress = QString::fromStdString(m_systemSettings->getMacAddress());

    const auto [staticAddr, dynamicAddr] = m_ipAddrTypeStr;
    auto ipAddrType =
        static_cast<IpAddressType>(m_systemSettings->getCurrentAddressType());
    m_ipAddressType = static_cast<bool>(ipAddrType) ? dynamicAddr : staticAddr;

    m_ipAddress =
        QString::fromStdString(m_systemSettings->getCurrentIPAddress());

    m_subNet = QString::fromStdString(m_systemSettings->getSubnet());

    m_gateWay = QString::fromStdString(m_systemSettings->getGateway());

    m_dnsServerA = QString::fromStdString(m_systemSettings->getDnsServerA());

    m_dnsServerB = QString::fromStdString(m_systemSettings->getDnsServerB());
}

void NetworkSettingsViewModel::getUpdatedConfigSettings()
{
    m_macAddress = QString::fromStdString(m_systemSettings->getMacAddress());

    const auto [staticAddr, dynamicAddr] = m_ipAddrTypeStr;
    auto ipAddrType =
        static_cast<IpAddressType>(m_systemSettings->getConfigAddressType());
    m_ipAddressType = static_cast<bool>(ipAddrType) ? dynamicAddr : staticAddr;

    m_ipAddress =
        QString::fromStdString(m_systemSettings->getConfigIPAddress());
    bool bIpAddressEmpty = m_ipAddress.isEmpty();

    // If the IP Address in the config file is empty, then get the values from
    // the adapter else get the values form the config file.
    if (bIpAddressEmpty)
    {
        m_ipAddress =
            QString::fromStdString(m_systemSettings->getCurrentIPAddress());
    }

    m_subNet =
        bIpAddressEmpty
            ? QString::fromStdString(m_systemSettings->getSubnet())
            : QString::fromStdString(m_systemSettings->getConfigSubnet());

    m_gateWay =
        bIpAddressEmpty
            ? QString::fromStdString(m_systemSettings->getGateway())
            : QString::fromStdString(m_systemSettings->getConfigGateway());

    m_dnsServerA =
        bIpAddressEmpty
            ? QString::fromStdString(m_systemSettings->getDnsServerA())
            : QString::fromStdString(m_systemSettings->getConfigDnsServerA());

    m_dnsServerB =
        bIpAddressEmpty
            ? QString::fromStdString(m_systemSettings->getDnsServerB())
            : QString::fromStdString(m_systemSettings->getConfigDnsServerB());
}

void NetworkSettingsViewModel::setApplyChangesPending(bool isApplyPending)
{
    m_isApplyChangesPending = isApplyPending;
    emit isApplyChangesPendingChanged();
}

NetworkSettingsViewModel* NetworkSettingsViewModel::instance(
    const std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertVwr,
    const std::shared_ptr<drive::itf::settings::ISystemSettings> nwSettings)
{
    static NetworkSettingsViewModel nwSettingsViewModel(alertVwr, nwSettings);
    return &nwSettingsViewModel;
}

const QString& NetworkSettingsViewModel::networkStatus()
{
    return m_networkStatus;
}

const QString& NetworkSettingsViewModel::nwStatusColor() const
{
    return m_nwStatusColor;
}

const QString& NetworkSettingsViewModel::macAddress() const
{
    return m_macAddress;
}

const QString& NetworkSettingsViewModel::ipAddressType() const
{
    return m_ipAddressType;
}

const QString& NetworkSettingsViewModel::ipAddress() const
{
    return m_ipAddress;
}

const QString& NetworkSettingsViewModel::subnet() const
{
    return m_subNet;
}

const QString& NetworkSettingsViewModel::gateway() const
{
    return m_gateWay;
}

const QString& NetworkSettingsViewModel::dnsServerA() const
{
    return m_dnsServerA;
}

const QString& NetworkSettingsViewModel::dnsServerB() const
{
    return m_dnsServerB;
}

QRegularExpressionValidator* NetworkSettingsViewModel::validator() const
{
    return m_validator;
}

void NetworkSettingsViewModel::updateNetworkConfiguration()
{
    // If we are static don't overwrite the UI fields with values from the
    // adapter
    if (m_isStaticIP)
        return;

    auto ipAddrType =
        static_cast<IpAddressType>(m_systemSettings->getCurrentAddressType());
    if (ipAddrType == IpAddressType::Static)
    {
        getUpdatedConfigSettings();
    }
    else
    {
        getUpdatedNwSettings();
    }

    emit ipAddressTypeChanged(ipAddrType);
}

bool NetworkSettingsViewModel::isIPAddressExcluded(QString text)
{
    int pos = 0;
    bool ret = m_isEhub ? m_IPExcluder->validate(text, pos) ==
                              QRegularExpressionValidator::Acceptable
                        : false;

    SYS_LOG_DEBUG("Entered Ip Address {} excluded? {}", text.toStdString(),
                  ret);
    return ret;
}

void NetworkSettingsViewModel::handleIPTypeSwitch(bool isChecked)
{
    // Let's track this value for use in other functions
    m_isStaticIP = !isChecked;

    if (isChecked)  // Dynamic Type
    {
        SYS_LOG_INFO("Requesting dynamic IP configuration");
        setIsApplyButtonActivated(false);
        QVariant ipType;
        ipType.setValue<drive::networksettings::IpAddressType>(
            static_cast<drive::networksettings::IpAddressType>(isChecked));

        m_ipAddress = QString();
        m_subNet = QString();
        m_gateWay = QString();
        m_dnsServerA = QString();
        m_dnsServerB = QString();

        refreshFrontEnd();

        applyNwSettings(ipType, m_ipAddress, m_subNet, m_gateWay, m_dnsServerA,
                        m_dnsServerB);
    }
    else
    {
        SYS_LOG_INFO("Waiting static IP configuration");
        setIsApplyButtonActivated(true);
        getUpdatedConfigSettings();

        // Need to unset this prior to calling the function to update the front
        // end so the function sets the new values from the config file in the
        // UI fields.
        m_isStaticIP = false;
        refreshFrontEnd();
        m_isStaticIP = true;  // Set it back to true
    }
}

void NetworkSettingsViewModel::updateNetworkConfigRequestState(
    gos::itf::sys::RequestState state)
{
    using namespace drive::itf::settings;
    switch (state)
    {
    case gos::itf::sys::RequestState::Success: return;
    case gos::itf::sys::RequestState::Failed: return;
    case gos::itf::sys::RequestState::Disconnected:
        setNetworkStatusUi(NetworkStatesUi::Disconnected);

        return;
    default: return;
    }
}

void NetworkSettingsViewModel::updateNetworkStatus(bool isConnected)
{
    bool prevConnected = m_isCableConnected;
    m_isCableConnected = isConnected;
    NetworkStatesUi newNetworkStateUI = NetworkStatesUi::Init;
    auto ipAddress =
        QString::fromStdString(m_systemSettings->getCurrentIPAddress());

    // If there is no connection of any type or we are eHub and the Ethernet
    // information is being displayed and there is no network connection
    if (!isConnected &&
        (!m_isGlinkConnection ||
         (m_isEhub && m_nwTypeDisplayed == NetworkTypeDisplayed::Ethernet)))
    {
        SYS_LOG_DEBUG("Network is disconnected");
        newNetworkStateUI = NetworkStatesUi::Disconnected;
        refreshFrontEnd();
    }
    // If the user changed the protocol to "static" but hasn't applied the
    // changes yet or just reconnected to the network
    else if (m_isCableConnected && m_isStaticIP &&
             (!prevConnected || m_isApplyButtonActivated))
    {
        // The cable was just connected and then the configuration needs to
        // be applied to the network adapter
        SYS_LOG_DEBUG(
            "Network connected static configuration needs to be applied");
        newNetworkStateUI = NetworkStatesUi::NotConfigured;
        setIsApplyButtonActivated(true);
    }
    else if (m_isCableConnected && ipAddress.isEmpty())
    {
        SYS_LOG_DEBUG("Network connecting..");
        newNetworkStateUI = NetworkStatesUi::Connecting;
    }
    else
    {
        newNetworkStateUI = updateNetworkStatus2(prevConnected);
    }

    // Update the network status if we are not an eHub platform or we are
    // displaying the Ethernet information
    if (!m_isEhub || m_nwTypeDisplayed == NetworkTypeDisplayed::Ethernet)
    {
        setNetworkStatusUi(newNetworkStateUI);
    }
    m_isFirstAlertConnected = false;
    emit ethernetConnectionChanged();
}

// This function exists because I needed to move some of the functionality from
// the primary updateNetworkStatus() to this new function to address an issue
// Sonar Cloud raised with the complexity of the primary function.
NetworkSettingsViewModel::NetworkStatesUi
NetworkSettingsViewModel::updateNetworkStatus2(const bool prevConnected)
{
    NetworkStatesUi newNetworkStateUI = NetworkStatesUi::Init;
    auto prevNetworkStateUI = m_networkStateUi;
    auto ipAddress =
        QString::fromStdString(m_systemSettings->getCurrentIPAddress());
    auto ipAddressConfig =
        QString::fromStdString(m_systemSettings->getConfigIPAddress());
    const auto [staticAddr, dynamicAddr] = m_ipAddrTypeStr;
    auto ipAddrType =
        static_cast<IpAddressType>(m_systemSettings->getCurrentAddressType());
    m_ipAddressType = static_cast<bool>(ipAddrType) ? dynamicAddr : staticAddr;

    // If we are not in "static" mode then let's update the IP address
    if (ipAddrType == drive::networksettings::IpAddressType::Dynamic &&
        !m_isStaticIP)
    {
        m_ipAddress = ipAddress;
    }

    refreshFrontEnd();

    // If the user tried to apply the static settings.
    if (m_isCableConnected && !m_isGlinkConnection && m_isStaticIP &&
        ipAddrType == drive::networksettings::IpAddressType::Static &&
        ipAddress != ipAddressConfig)
    {
        // Static IP but we cannot have the requested IP
        SYS_LOG_DEBUG("Network connected with invalid static IP");
        newNetworkStateUI = NetworkStatesUi::WrongConfiguration;
        m_alertMgr->createAlert(
            drive::alerts::alertsMap.at(DriveAlerts::NetworkConfigFailed));

        // The address was not successfully set. Make sure the buttons are
        // re-activated but don't want to call the function to do this as it
        // will change the network status.
        m_isApplyButtonActivated = true;
        emit isApplyButtonActivatedChanged();
    }
    // Configuration failed if the IP Address or subnet is empty when DHCP is
    // selected
    else if (m_isCableConnected && !m_isGlinkConnection &&
             ipAddrType == drive::networksettings::IpAddressType::Dynamic &&
             (m_ipAddress.isEmpty() || m_subNet.isEmpty()))
    {
        SYS_LOG_DEBUG("Network connected with invalid dynamic configuration");
        newNetworkStateUI = NetworkStatesUi::NotConfigured;
        m_alertMgr->createAlert(
            drive::alerts::alertsMap.at(DriveAlerts::NetworkConfigFailed));
    }
    else if ((m_isCableConnected || m_isGlinkConnection) &&
             (!m_isEhub || m_nwTypeDisplayed == NetworkTypeDisplayed::Ethernet))
    {
        SYS_LOG_DEBUG("Network connected");
        newNetworkStateUI = NetworkStatesUi::Connected;
        setIsApplyButtonActivated(false);
        if (!m_isFirstAlertConnected &&
            (prevConnected != m_isCableConnected ||
             prevNetworkStateUI != NetworkStatesUi::Connected))
        {
            m_isFirstAlertConnected = true;
            m_alertMgr->createAlert(
                drive::alerts::alertsMap.at(DriveAlerts::NetworkConfigSuccess));
        }
    }
    return newNetworkStateUI;
}

bool NetworkSettingsViewModel::isApplyChangesPending() const
{
    return m_isApplyChangesPending;
}

void NetworkSettingsViewModel::applyNwSettings(const QVariant& ipAddressType,
                                               const QString& ipAddress,
                                               const QString& subnet,
                                               const QString& gateway,
                                               const QString& dnsServerA,
                                               const QString& dnsServerB)
{
    setIsApplyButtonActivated(false);
    setNetworkStatusUi(NetworkStatesUi::Connecting);

    auto addressType =
        ipAddressType.value<drive::networksettings::IpAddressType>();
    if (addressType == IpAddressType::Static)
    {
        SYS_LOG_INFO("Requesting Static IP to source");

        // Let's update the data members with the most recent values. We could
        // call the function and pull them from the config file after they have
        // been set but the overhead isn't necessary since we know what they are
        m_ipAddress = ipAddress;
        m_subNet = subnet;
        m_gateWay = gateway;
        m_dnsServerA = dnsServerA;
        m_dnsServerB = dnsServerB;

        // Apply the static address settings
        m_systemSettings->setStaticIP(
            ipAddress.toStdString(), subnet.toStdString(),
            gateway.toStdString(), dnsServerA.toStdString(),
            dnsServerB.toStdString());
    }
    else
    {
        SYS_LOG_INFO("Requesting Dynamic IP to source");
        m_systemSettings->setDynamicIP();
    }
}

void NetworkSettingsViewModel::updateGlinkConnectionStateChanged(
    sys::glink::ConnectionState state)
{
    auto prevGlinkConnection = m_isGlinkConnection;
    NetworkStatesUi glinkNetworkState = NetworkStatesUi::Disconnected;

    switch (state)
    {
    case sys::glink::ConnectionState::Connected:
        SYS_LOG_INFO("Glink connected");
        setIsGlinkConnection(true);
        updatePeerChanged(m_systemSettings->connectedPeer());
        glinkNetworkState = NetworkStatesUi::Connected;
        break;
    case sys::glink::ConnectionState::Disconnected:
        SYS_LOG_INFO("Glink disconnected");
        setIsGlinkConnection(false);
        updatePeerChanged(std::nullopt);
        break;
    case sys::glink::ConnectionState::Error:
        SYS_LOG_INFO("Glink error");
        setIsGlinkConnection(false);
        updatePeerChanged(std::nullopt);
        break;
    }

    // If we are eHub and we are on the GLink page then update the status field
    if (m_isEhub && m_nwTypeDisplayed == NetworkTypeDisplayed::Glink)
    {
        setNetworkStatusUi(glinkNetworkState);
    }
    else
    {
        // If we are network connected and that happened was the GLink
        // connection state changed then only need to update the status field
        if (m_isCableConnected && (m_isGlinkConnection != prevGlinkConnection))
        {
            setNetworkStatusUi(m_networkStateUi);
        }
        else  // Let's check everything and update accordingly
        {
            updateNetworkStatus(m_isCableConnected);
        }
    }
}

void NetworkSettingsViewModel::updatePeerChanged(
    std::optional<gos::glink::util::GosPeer> peer)
{
    // If we have a value and are glink connected and we are not on eHub or we
    // are on the Glink page then update the Glink label
    if (peer.has_value() && m_isGlinkConnection &&
        (!m_isEhub || m_nwTypeDisplayed == NetworkTypeDisplayed::Glink))
    {
        auto systemType =
            gm::util::typeconv::convert<std::string>(peer.value().type());
        auto sn = QString::fromStdString(peer.value().name());
        auto newGlinkLabel =
            QString::fromStdString(systemType).toUpper() + "(\"" + sn + "\")";
        m_glinkLabel = "to " + newGlinkLabel;
        SYS_LOG_INFO("GLink connected to {}", newGlinkLabel.toStdString());
    }
    else  // Clear the label
    {
        m_glinkLabel = QString();
    }
}

void NetworkSettingsViewModel::checkRequestState(
    gos::itf::sys::RequestState requestState)
{
    m_systemSettings->requestConnectionState();
    updateNetworkConfigRequestState(requestState);
}

QString NetworkSettingsViewModel::glinkLabel() const
{
    return m_glinkLabel;
}

void NetworkSettingsViewModel::setIsGlinkConnection(bool newIsGlinkConnection)
{
    if (m_isGlinkConnection == newIsGlinkConnection)
        return;
    m_isGlinkConnection = newIsGlinkConnection;

    emit glinkConnectionChanged();
}

void NetworkSettingsViewModel::setNetworkStatusUi(
    NetworkStatesUi networkStatusUi)
{
    const auto [connected, notConfigured, wrongIp, connecting, disconnected] =
        m_nwStatusStr;
    const auto [green, yellow, red] = m_nwStatusColors;
    m_networkStateUi = networkStatusUi;

    if (!m_isCableConnected && !m_isGlinkConnection &&
        m_networkStateUi != NetworkStatesUi::Disconnected)
    {
        m_networkStateUi = NetworkStatesUi::Disconnected;
    }

    if (m_networkStateUi == NetworkStatesUi::Connected && m_isGlinkConnection)
    {
        updatePeerChanged(m_systemSettings->connectedPeer());
    }
    else
    {
        updatePeerChanged(std::nullopt);
    }

    switch (m_networkStateUi)
    {
    case NetworkStatesUi::Disconnected:
        setApplyChangesPending(false);
        m_networkStatus = disconnected;
        m_nwStatusColor = red;
        break;
    case NetworkStatesUi::Connected:
        setApplyChangesPending(false);
        m_networkStatus = connected;
        m_nwStatusColor = green;
        break;
    case NetworkStatesUi::Connecting:
        setApplyChangesPending(true);
        m_networkStatus = connecting;
        m_nwStatusColor = yellow;
        break;
    case NetworkStatesUi::NotConfigured:
        setApplyChangesPending(false);
        m_networkStatus = notConfigured;
        m_nwStatusColor = yellow;
        break;
    case NetworkStatesUi::WrongConfiguration:
        setApplyChangesPending(false);
        m_networkStatus = wrongIp;
        m_nwStatusColor = red;
        getUpdatedConfigSettings();  // Display config configuration
        refreshFrontEnd();
        break;
    default: break;
    }

    emit networkStatusChanged();
    emit nwStatusColorChanged();
    emit glinkLabelChanged();
}

bool NetworkSettingsViewModel::isApplyButtonActivated() const
{
    return m_isApplyButtonActivated;
}

bool NetworkSettingsViewModel::isEhub()
{
    return m_isEhub;
}

void NetworkSettingsViewModel::setIsApplyButtonActivated(
    bool newIsApplyButtonActivated)
{
    if (m_isApplyButtonActivated != newIsApplyButtonActivated)
    {
        m_isApplyButtonActivated = newIsApplyButtonActivated;
        emit isApplyButtonActivatedChanged();
    }

    if (m_isApplyButtonActivated &&
        (!m_isEhub || m_nwTypeDisplayed == NetworkTypeDisplayed::Ethernet))
    {
        setNetworkStatusUi(NetworkStatesUi::NotConfigured);
    }
}

void NetworkSettingsViewModel::refreshFrontEnd()
{
    // If we are static we should never overwrite the UI fields
    if (!m_isStaticIP)
    {
        emit ipAddressChanged();
        emit subnetChanged();
        emit gatewayChanged();
        emit macAddressChanged();
        emit dnsServerAChanged();
        emit dnsServerBChanged();
    }
}

void NetworkSettingsViewModel::btnNwTypeClicked(const QString name)
{
    m_nwTypeDisplayed =
        (name == m_nwTypeDisplayedStr.first ? NetworkTypeDisplayed::Ethernet
                                            : NetworkTypeDisplayed::Glink);

    // User clicked on the Ethernet button then update the network status
    if (m_nwTypeDisplayed == NetworkTypeDisplayed::Ethernet)
    {
        m_isFirstAlertConnected = true;
        updateNetworkStatus(m_isCableConnected);
    }
    else  // User clicked on the GLink button set the Glink status
    {
        updateGlinkConnectionStateChanged(
            m_isGlinkConnection ? sys::glink::ConnectionState::Connected
                                : sys::glink::ConnectionState::Disconnected);
    }
}

}  // namespace drive::viewmodel
