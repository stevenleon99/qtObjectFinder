/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#ifndef Q_MOC_RUN
#include <sys/alerts/itf/IAlertAggregator.h>
#include <sys/alerts/AlertManagerFactory.h>
#include <sys/alerts/Alert.h>
#include <drive/itf/settings/ISystemSettings.h>
#include <gos/itf/sys/INetworkConfig.h>
#include <sys/glink/IConnectionHandler.h>
#include <gm/util/enum.h>
#include <gm/util/typeconv.h>
#include <gm/util/boost_signals2.h>
#include <optional>
#include "DriveAlerts.h"
#endif
#include <QObject>
#include <QRegularExpressionValidator>

namespace drive::networksettings {  // namespace drive::networksettings
Q_NAMESPACE
enum class IpAddressType
{
    Static = gm::util::toUType(gos::itf::sys::IpAddressType::Static),
    Dynamic = gm::util::toUType(gos::itf::sys::IpAddressType::Dynamic)
};
Q_ENUM_NS(IpAddressType)
}  // namespace drive::networksettings


namespace drive::viewmodel {

class NetworkSettingsViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(
        QString networkStatus READ networkStatus NOTIFY networkStatusChanged)
    Q_PROPERTY(QString macAddress READ macAddress NOTIFY macAddressChanged)
    Q_PROPERTY(
        QString ipAddressType READ ipAddressType NOTIFY ipAddressTypeChanged)
    Q_PROPERTY(QString ipAddress READ ipAddress NOTIFY ipAddressChanged)
    Q_PROPERTY(QString subnet READ subnet NOTIFY subnetChanged)
    Q_PROPERTY(QString gateway READ gateway NOTIFY gatewayChanged)
    Q_PROPERTY(QString dnsServerA READ dnsServerA NOTIFY dnsServerAChanged)
    Q_PROPERTY(QString dnsServerB READ dnsServerB NOTIFY dnsServerBChanged)
    Q_PROPERTY(bool isApplyChangesPending READ isApplyChangesPending WRITE
                   setApplyChangesPending NOTIFY isApplyChangesPendingChanged)
    Q_PROPERTY(bool isApplyButtonActivated READ isApplyButtonActivated WRITE
                   setIsApplyButtonActivated NOTIFY
                       isApplyButtonActivatedChanged FINAL)
    Q_PROPERTY(
        QString nwStatusColor READ nwStatusColor NOTIFY nwStatusColorChanged)
    Q_PROPERTY(bool isGlinkConnected READ isGlinkConnected NOTIFY
                   glinkConnectionChanged FINAL)
    Q_PROPERTY(bool isEthernetConnected READ isEthernetConnected NOTIFY
                   ethernetConnectionChanged FINAL)
    Q_PROPERTY(
        QString glinkLabel READ glinkLabel NOTIFY glinkLabelChanged FINAL)
    Q_PROPERTY(bool isEhub READ isEhub NOTIFY isEhubChanged FINAL)

    enum class NetworkStatesUi
    {
        Init,
        Disconnected,
        Connected,
        Connecting,
        NotConfigured,
        WrongConfiguration
    };

    // What set of data is currently being displayed on the UI.
    enum class NetworkTypeDisplayed
    {
        Ethernet,
        Glink
    };

public:
    static NetworkSettingsViewModel* instance(
        const std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertVwr,
        const std::shared_ptr<drive::itf::settings::ISystemSettings>
            nwSettings);

    const QString& networkStatus();
    const QString& nwStatusColor() const;
    const QString& macAddress() const;
    const QString& ipAddressType() const;
    const QString& ipAddress() const;
    const QString& subnet() const;
    const QString& gateway() const;
    const QString& dnsServerA() const;
    const QString& dnsServerB() const;
    bool isApplyChangesPending() const;

    Q_INVOKABLE QRegularExpressionValidator* validator() const;
    Q_INVOKABLE void applyNwSettings(const QVariant& ipAddressType,
                                     const QString& ipAddress,
                                     const QString& subnet,
                                     const QString& gateway,
                                     const QString& dnsServerA = {},
                                     const QString& dnsServerB = {});
    Q_INVOKABLE void getUpdatedNwSettings();
    Q_INVOKABLE void handleIPTypeSwitch(bool isChecked);
    Q_INVOKABLE void setApplyChangesPending(bool isApplyPending);
    Q_INVOKABLE void btnNwTypeClicked(QString name);
    Q_INVOKABLE bool isIPAddressExcluded(QString text);

    const std::tuple<QString, QString, QString, QString, QString> m_nwStatusStr{
        "Connected", "Connected (Not Configured)",
        "Connected (Not Configured) (Invalid IP)", "Connecting...",
        "Disconnected"};
    const std::pair<QString, QString> m_ipAddrTypeStr{"Static Address",
                                                      "Dynamic Address"};
    const std::tuple<QString, QString, QString> m_nwStatusColors{
        "#00CC66", "#ffCA00", "#fA0200"};
    const std::pair<QString, QString> m_nwTypeDisplayedStr{"Ethernet", "Glink"};

    bool isGlinkConnected() const { return m_isGlinkConnection; };
    bool isEthernetConnected() const { return m_isCableConnected; };
    QString glinkLabel() const;

    bool isApplyButtonActivated() const;
    void setIsApplyButtonActivated(bool newIsApplyButtonActivated);

    bool isEhub();
public slots:
    void updateNetworkConfiguration();
    void updateNetworkStatus(bool isConnected);
    void updateNetworkConfigRequestState(gos::itf::sys::RequestState state);
    void handleAlertResponse(const sys::alerts::Alert& alert,
                             const sys::alerts::Option& option);

signals:
    void macAddressChanged();
    void networkStatusChanged();
    void ipAddressTypeChanged(const networksettings::IpAddressType type);
    void ipAddressChanged();
    void subnetChanged();
    void gatewayChanged();
    void isApplyChangesPendingChanged();
    void nwStatusColorChanged();
    void dnsServerAChanged();
    void dnsServerBChanged();

    void ethernetConnectionChanged();
    void glinkConnectionChanged();

    void glinkLabelChanged();

    void isApplyButtonActivatedChanged();
    void isEhubChanged();

private slots:
    void updateGlinkConnectionStateChanged(sys::glink::ConnectionState state);
    void updatePeerChanged(std::optional<gos::glink::util::GosPeer> peer);
    void checkRequestState(gos::itf::sys::RequestState requestState);

private:
    void refreshFrontEnd();
    void getUpdatedConfigSettings();
    void setIsGlinkConnection(bool newIsGlinkConnection);
    void setNetworkStatusUi(NetworkStatesUi networkStatusUi);
    NetworkStatesUi updateNetworkStatus2(bool prevConnected);

    const std::shared_ptr<drive::itf::settings::ISystemSettings>
        m_systemSettings;
    const std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertMgr =
        sys::alerts::AlertManagerFactory::createInstance();
    explicit NetworkSettingsViewModel(
        const std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertVwr,
        const std::shared_ptr<drive::itf::settings::ISystemSettings>
            systemSettings);

    QString m_networkStatus{""};
    QString m_nwStatusColor;
    QString m_macAddress{""};
    QString m_ipAddressType{""};
    QString m_ipAddress{""};
    QString m_subNet{""};
    QString m_gateWay{""};
    QString m_dnsServerA{""};
    QString m_dnsServerB{""};
    QRegularExpressionValidator* m_validator;
    QRegularExpressionValidator* m_IPExcluder;
    bool m_isApplyChangesPending{false};
    bool m_isGlinkConnection{false};
    bool m_isCableConnected{false};
    bool m_isFirstAlertConnected{true};
    QString m_glinkLabel;
    bool m_isApplyButtonActivated;
    bool m_isStaticIP{false};
    NetworkStatesUi m_networkStateUi{NetworkStatesUi::Init};
    NetworkTypeDisplayed m_nwTypeDisplayed{NetworkTypeDisplayed::Ethernet};
    bool m_isEhub{false};
    const std::shared_ptr<sys::alerts::itf::IAlertAggregator> m_alertVwr;
};

}  // namespace drive::viewmodel
