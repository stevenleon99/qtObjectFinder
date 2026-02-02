/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "ApplicationViewModel.h"
#include "DriveAlerts.h"

#ifndef Q_MOC_RUN

#include <gm/util/qt/typeconv.h>
#include <sys/alerts/Alert.h>
#include <sys/alerts/AlertManagerFactory.h>
#include <sys/config/config.h>
#include <gm/util/qt/qt_boost_signals2.h>

#include <filesystem>

#include <gos/launcher/ExitCodes.h>

#endif

#include <QGuiApplication>
#include <QStorageInfo>

namespace drive::viewmodel {

constexpr auto IDEAL_SCREEN_WIDTH = 1920;
constexpr auto IDEAL_SCREEN_HEIGHT = 1080;
constexpr auto TWENTY_PERCENT = 0.2;

ApplicationViewModel::ApplicationViewModel(
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
    std::shared_ptr<drive::itf::settings::ISystemSettings> systemSettings,
    QObject* parent)
    : QObject(parent)
    , m_alertViewRegistry(alertViewRegistry)
    , m_alertManager(sys::alerts::AlertManagerFactory::createInstance())
    , m_systemSettings(systemSettings)
    , m_node(glink::node::NodeFactory::createInstance())
    , m_desktopResolutionIncompatible(
          LegacyDesktopResolutionIncompatibleProxyFactory::createInstance(
              m_node, m_node->systemId()))
{
    m_alertViewRegistry->addAlertView(m_alertManager);

    // DRIVE-549
    if (sys::config::Config::instance()->platform.systemType() !=
        sys::config::SystemType::Ehub)
    {
        connect(qApp, &QGuiApplication::primaryScreenChanged, this,
                &ApplicationViewModel::onPrimaryScreenChanged);
        onPrimaryScreenChanged(QGuiApplication::primaryScreen());
    }

    gm::util::qt::connect(m_systemSettings->screenTimeoutChanged, this,
                          &ApplicationViewModel::updateScreenTimeout);
    updateScreenTimeout(m_systemSettings->getScreenTimeout());

    gm::util::qt::connect(
        m_desktopResolutionIncompatible->resolutionIncompatible, this,
        &ApplicationViewModel::onResolutionIncompatible);

    alertIfDiskFreeSpaceLow();
}

void ApplicationViewModel::quitToAdmin() const
{
    int exitCode = gos::launcher::toInt(gos::launcher::ExitCode::Logout);
    qApp->exit(exitCode);
}

void drive::viewmodel::ApplicationViewModel::shutdownSystem() const
{
    int exitCode = gos::launcher::toInt(gos::launcher::ExitCode::Shutdown);
    qApp->exit(exitCode);
}

void drive::viewmodel::ApplicationViewModel::enterRemoteDeployment() const
{
    std::system("taskkill /f /im launcher.exe");
    int exitCode =
        gos::launcher::toInt(gos::launcher::ExitCode::QuitToRemoteDeploy);
    qApp->exit(exitCode);
}

void ApplicationViewModel::onPrimaryScreenChanged(const QScreen* screen)
{
    // zwassall: This signal seems to be emitted not simply when the primary
    // screen in the OS changes, but specifically when it changes and the
    // application is forced to move to the new primary screen.

    disconnect(m_alertIfScreenScaledConnection);

    if (!screen)
        return;

    m_alertIfScreenScaledConnection =
        connect(screen, &QScreen::geometryChanged, this,
                &ApplicationViewModel::alertIfScreenScaled);
    alertIfScreenScaled(screen->geometry());
}

void ApplicationViewModel::alertIfScreenScaled(const QRect& screenSize)
{
    if ((screenSize.width() != IDEAL_SCREEN_WIDTH) ||
        (screenSize.height() != IDEAL_SCREEN_HEIGHT))
    {
        m_alertManager->createAlert(drive::alerts::alertsMap.at(
            drive::alerts::DriveAlerts::ScreenScaled));
    }
    else
    {
        m_alertManager->clearAlert(drive::alerts::alertsMap.at(
            drive::alerts::DriveAlerts::ScreenScaled));
    }
}

void ApplicationViewModel::updateScreenTimeout(std::chrono::minutes timeout)
{
    if (m_screenTimeout != timeout)
    {
        m_screenTimeout = timeout;
        Q_EMIT screenTimeoutChanged();
    }
}

void ApplicationViewModel::alertIfDiskFreeSpaceLow()
{
    std::filesystem::path systemDataPath =
        sys::config::Config::instance()->config.apps().drive().data();

    if (systemDataPath.empty())
    {
        return;
    }

    QStorageInfo storageInfo;
    storageInfo.setPath(gm::util::typeconv::convert<QString>(systemDataPath));

    if (!storageInfo.isReady())
    {
        return;
    }

    auto bytesAvailable = static_cast<double>(storageInfo.bytesAvailable());
    auto bytesTotal = static_cast<double>(storageInfo.bytesTotal());
    auto diskFreeSpace = bytesAvailable / bytesTotal;

    if (diskFreeSpace < TWENTY_PERCENT)
    {
        m_alertManager->createAlert(drive::alerts::alertsMap.at(
            drive::alerts::DriveAlerts::DiskFreeSpaceLow));
    }
}

void ApplicationViewModel::onResolutionIncompatible(bool isIncompatible)
{
    if (m_isResolutionIncompatible == isIncompatible)
        return;

    m_isResolutionIncompatible = isIncompatible;
    auto incompatibleResAlert = drive::alerts::alertsMap.at(
        drive::alerts::DriveAlerts::ResolutionIncompatible);
    if (m_isResolutionIncompatible)
    {
        m_alertManager->createAlert(incompatibleResAlert);
    }
    else
    {
        m_alertManager->clearAlert(incompatibleResAlert);
    }
}

}  // namespace drive::viewmodel
