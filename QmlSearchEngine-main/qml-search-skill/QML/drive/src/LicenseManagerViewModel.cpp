#include "DriveAlerts.h"
#include "LicenseManagerViewModel.h"

#include <drive/licensemanager/LicenseManager.h>
#include <sys/alerts/AlertManagerFactory.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <drive/licensing/driveFeatures.h>

#include <QString>

/**
 * Constructor
 *
 * @param alertViewRegistry Alert aggregator
 * @param parent Qapp
 */
LicenseManagerViewModel::LicenseManagerViewModel(
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
    QObject* parent)
    : QObject(parent)
    , m_alertViewRegistry(alertViewRegistry)
    , m_alertManager(sys::alerts::AlertManagerFactory::createInstance())
{
    gm::util::qt::connect(m_alertManager->clearRequested, this,
                          &LicenseManagerViewModel::handleAlertResponse);

    m_alertViewRegistry->addAlertView(m_alertManager);
}

/**
 * Verifies license file exists and has valid license based on serial number.
 *
 * @param plugin Name of plugin to be checked
 * @return True if plugin has a valid icense
 */
bool LicenseManagerViewModel::licenseFileValid(const QString& plugin) const
{
    return drive::LicenseManager::isLicenseFileValid(plugin);
}

/**
 * Create an alert that the license is invalid.
 */
void LicenseManagerViewModel::alertInvalidLicense() const
{
    m_alertManager->createAlert(drive::alerts::alertsMap.at(
        drive::alerts::DriveAlerts::InvalidLicense));
}

/**
 * Handles alert dismissal
 */
void LicenseManagerViewModel::handleAlertResponse(
    const sys::alerts::Alert& alert, const sys::alerts::Option&)
{
    m_alertManager->clearAlert(alert);
    return;
}

QStringList LicenseManagerViewModel::getFluoroFixtureLicensed() const
{
    QStringList fixtureLicensed = {"9''", "12''", "Flat Panel"};
    return fixtureLicensed;
}
