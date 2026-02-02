#pragma once

#include <sys/alerts/itf/IAlertAggregator.h>
#include <sys/alerts/itf/IAlertManager.h>

#include <QTimer>
#include <QObject>

class SystemPower : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool acPresent READ acPresent NOTIFY acPresentChanged)
    Q_PROPERTY(bool acPresentMuted READ acPresentMuted NOTIFY acPresentMutedChanged)

public:
    explicit SystemPower(std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
                         QObject* parent = nullptr);

    void setGpsAcPresent(bool gpsAcPresent);
    void setEHubAcPresent(bool eHubAcPresent);

    // Q_PROPERTY READ
    bool acPresent() const;
    bool acPresentMuted() const;

private slots:
    void onAlertCreated(const sys::alerts::Alert& alert);
    void onAlertCleared(const sys::alerts::Alert& alert);

signals:
    // Q_PROPERTY NOTIFY
    void acPresentChanged();
    void acPresentMutedChanged(bool acPresentMuted);

private:
    void setAcPresentMuted(bool acPresentMuted);

private:
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> m_alertViewRegistry;
    std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertManager;

    // Q_PROPERTY MEMBER
    bool m_gpsAcPresent{true};
    bool m_eHubAcPresent{true};
    bool m_acPresentMuted{false};
};
