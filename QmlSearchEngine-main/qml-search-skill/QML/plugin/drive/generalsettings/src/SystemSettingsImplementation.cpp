/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#include "SystemSettingsImplementation.h"
#include "SystemSettingsAlerts.h"

#include <service/fluorocapture/FluoroConfigStringConversion.h>
#include <sys/config/config.h>
#include <fmt/format.h>

#include <gm/util/qt/qt_boost_signals2.h>
#include <QDebug>

#include <vector>
#include <sys/log/sys_log.h>
using namespace drive::systemsettings;

SystemSettingsImplementation::SystemSettingsImplementation(
    std::shared_ptr<gos::itf::deviceio::IDeviceIO> deviceIo,
    std::shared_ptr<sys::alerts::itf::IAlertManager> alertManager)
    : m_alertManager(alertManager)
    , m_deviceIo{deviceIo}
    , m_archiveLocations{deviceIo->exportLocations()}
    , m_exportLocations(new drive::archiving::LocationsViewModel(this))
{
    gm::util::qt::connect(m_alertManager->clearRequested, this,
                          &SystemSettingsImplementation::handleAlertResponse);

    gm::util::qt::connect(m_archiveLocations->changed, this,
                          &SystemSettingsImplementation::updateLocations);

    gm::util::connect(m_alertManager->clearRequested, m_alertManager,
                      [](auto& alertManager_, sys::alerts::Alert const& alert,
                         sys::alerts::Option const&) { alertManager_.clearAlert(alert); });
}

SystemSettingsImplementation::~SystemSettingsImplementation()
{
    if (!m_exportThread.isNull())
    {
        m_exportThread->quit();
        m_exportThread->wait();
    }
}

void SystemSettingsImplementation::setPluginShell(
    std::shared_ptr<drive::itf::plugin::IPluginShell> shell)
{
    m_shell = std::move(shell);
}

std::shared_ptr<drive::itf::settings::ISystemSettings>
SystemSettingsImplementation::getSystemSettings()
{
    return m_systemSettings;
}

void SystemSettingsImplementation::setSystemSettings(
    const std::shared_ptr<ISystemSettings>& settings)
{
    m_systemSettings = settings;
}

void SystemSettingsImplementation::cleanupPlugin()
{
    m_shell->deletePluginComponent();
}

void SystemSettingsImplementation::requestPluginQuit()
{
    G_EMIT pluginQuit();
}

void SystemSettingsImplementation::resetMotion()
{
    m_systemSettings->resetMotion();
}

void SystemSettingsImplementation::resetSoftware()
{
    m_systemSettings->resetSoftware();
}

void SystemSettingsImplementation::exportLogs(const QString& exportLocation)
{
    if (!m_exportThread.isNull() && m_exportThread->isRunning())
        return;

    m_alertManager->createAlert(alertsMap.at(SystemSettingsAlerts::ExportingLogs));
    m_exportThread = QThread::create([=, this]() {
        auto result = m_systemSettings->exportLogs(exportLocation.toStdString());
        m_alertManager->clearAlert(alertsMap.at(SystemSettingsAlerts::ExportingLogs));

        if (!result)
        {
            m_alertManager->createAlert(alertsMap.at(SystemSettingsAlerts::ExportingLogsFailed));
        }
    });
    connect(m_exportThread, &QThread::finished, m_exportThread, &QThread::deleteLater);
    m_exportThread->start();
}

void SystemSettingsImplementation::exportScreenshots()
{
    m_systemSettings->exportScreenshots();
}

int SystemSettingsImplementation::audioVolume() const
{
    int val = -1;
    if (m_systemSettings)
    {
        val = m_systemSettings->getAudioVolume();
    }
    SYS_LOG_INFO("SystemSettingsImplementation:: audioVolume={}", val);
    return val;
}

int SystemSettingsImplementation::screenTimeout() const
{
    return m_systemSettings->getScreenTimeout().count();
}

QString SystemSettingsImplementation::videoFormat() const
{
    return QString::fromStdString(m_systemSettings->getVideoFormatOutput());
}

QString SystemSettingsImplementation::fluoroFixtureSize() const
{
    return QString::fromStdString(m_systemSettings->getFluoroFixtureSize());
}

QString SystemSettingsImplementation::fluoroSensitivity() const
{
    return QString::fromStdString(m_systemSettings->getFluoroSensitivity());
}

void SystemSettingsImplementation::setAudioVolume(const int volume)
{
    if (m_systemSettings)
    {
        m_systemSettings->setAudioVolume(volume);
    }
    else
    {
        qDebug() << "Error: Drive could not set application volume";
    }
}

void SystemSettingsImplementation::setScreenTimeout(const int screenTimeout)
{
    m_systemSettings->setScreenTimeout(std::chrono::minutes(screenTimeout));

    Q_EMIT screenTimeoutChanged(screenTimeout);
}

void SystemSettingsImplementation::setVideoFormat(const QString& videoFormat)
{
    m_systemSettings->setVideoFormatOutput(videoFormat.toStdString());

    Q_EMIT videoFormatChanged(videoFormat);
}

void SystemSettingsImplementation::setFluoroFixtureSize(const QString& fluoroFixtureSize)
{
    m_systemSettings->setFluoroFixtureSize(fluoroFixtureSize.toStdString());

    Q_EMIT fluoroFixtureSizeChanged(fluoroFixtureSize);
}

void SystemSettingsImplementation::setFluoroSensitivity(const QString& fluoroSensitivity)
{
    m_systemSettings->setFluoroSensitivity(fluoroSensitivity.toStdString());

    Q_EMIT fluoroSensitivityChanged(fluoroSensitivity);
}

QString SystemSettingsImplementation::aeTitle() const
{
    return QString::fromStdString(m_systemSettings->getAETitle());
}

bool SystemSettingsImplementation::usingLaptop() const
{
    return sys::config::Config::instance()->platform.systemType() ==
           sys::config::SystemType::Laptop;
}

void SystemSettingsImplementation::setAeTitle(const QString& title)
{
    m_systemSettings->setAETitle(title.toStdString());

    Q_EMIT aeTitleChanged(title);
}

void SystemSettingsImplementation::handleAlertResponse(const sys::alerts::Alert& alert,
                                                       const sys::alerts::Option&)
{
    m_alertManager->clearAlert(alert);
}

void SystemSettingsImplementation::updateLocations(
    std::shared_ptr<gm::arch::ICollection<gos::itf::deviceio::LabeledLocation>> const&
        labeledLocations)
{
    m_exportLocations->replaceLocations(
        labeledLocations->eval<std::vector<gos::itf::deviceio::LabeledLocation>>());
}

void SystemSettingsImplementation::applyLicenseCode(const QString& licenseCode)
{
    auto result = m_systemSettings->applyLicenseCode(licenseCode.toStdString());
    setLicenseCode(licenseCode);
    qInfo() << "License code applied: " << licenseCode;

    if (result)
    {
        auto licenses = m_systemSettings->getLicensesFromResponse(licenseCode.toStdString());

        if (licenses.empty())
        {
            qInfo() << "Valid license code returned empty license";
            m_alertManager->createAlert(alertsMap.at(SystemSettingsAlerts::LicenseAppliedFail));
            return;
        }

        std::string formattedLicenses = "\n";
        for (auto& license : licenses)
        {
            formattedLicenses += ("\n" + license);
        }

        qInfo() << "License code valid. Activated licenses:"
                << QString::fromStdString(formattedLicenses);

        auto alert = alertsMap.at(SystemSettingsAlerts::LicenseAppliedSuccess);
        alert.message = fmt::format(alert.message, formattedLicenses);
        m_alertManager->createAlert(alert);

        // Clear the current license code if a license is applied successfully
        setLicenseCode("");
    }
    else
    {
        qInfo() << "License code invalid";

        m_alertManager->createAlert(alertsMap.at(SystemSettingsAlerts::LicenseAppliedFail));
    }
}

void SystemSettingsImplementation::setLicenseCode(const QString& licenseCode)
{
    if (licenseCode == m_licenseCode)
        return;

    m_licenseCode = licenseCode;

    Q_EMIT licenseCodeChanged(licenseCode);
}
