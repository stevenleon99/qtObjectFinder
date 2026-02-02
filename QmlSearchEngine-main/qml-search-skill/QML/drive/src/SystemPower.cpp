#include "SystemPower.h"
#include "DriveAlerts.h"

#include <sys/config/config.h>
#include <sys/alerts/AlertManagerFactory.h>
#include <gns/alerts.h>
#include <gps/alerts/AlertHandlerFactory.h>
#include <gps/alerts.h>
#include <gm/util/qt/qt_boost_signals2.h>

SystemPower::SystemPower(std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry, QObject* parent)
    : QObject(parent)
    , m_alertViewRegistry(alertViewRegistry)
    , m_alertManager(sys::alerts::AlertManagerFactory::createInstance())
{
    gm::util::qt::connect(m_alertViewRegistry->alertCreated, this, &SystemPower::onAlertCreated);
    gm::util::qt::connect(m_alertViewRegistry->alertCleared, this, &SystemPower::onAlertCleared);
    m_alertViewRegistry->addAlertView(m_alertManager);

    setAcPresentMuted(
        sys::config::Config::instance()->platform.systemType() ==
        sys::config::SystemType::DevelopmentComputer);
}

void SystemPower::setGpsAcPresent(const bool gpsAcPresent)
{
    if (m_gpsAcPresent == gpsAcPresent)
    {
        return;
    }

    m_gpsAcPresent = gpsAcPresent;
    emit acPresentChanged();
}

void SystemPower::setEHubAcPresent(const bool eHubAcPresent)
{
    if (m_eHubAcPresent == eHubAcPresent)
    {
        return;
    }

    m_eHubAcPresent = eHubAcPresent;
    emit acPresentChanged();
}

bool SystemPower::acPresent() const
{
    return m_gpsAcPresent && m_eHubAcPresent;
}

bool SystemPower::acPresentMuted() const
{
    return m_acPresentMuted;
}

void SystemPower::onAlertCreated(const sys::alerts::Alert& alert)
{
    if (alert == gns::alerts::noAcPower)
    {
        setEHubAcPresent(false);
    }
    else if (alert == gps::alerts::acPowerDisconnected)
    {
        setGpsAcPresent(false);
    }
}

void SystemPower::onAlertCleared(const sys::alerts::Alert& alert)
{
    if (alert == gns::alerts::noAcPower)
    {
        setEHubAcPresent(true);
    }
    else if (alert == gps::alerts::acPowerDisconnected)
    {
        setGpsAcPresent(true);
    }
}

void SystemPower::setAcPresentMuted(bool acPresentMuted)
{
    if (m_acPresentMuted == acPresentMuted)
    {
        return;
    }

    m_acPresentMuted = acPresentMuted;
    emit acPresentMutedChanged(m_acPresentMuted);
}
