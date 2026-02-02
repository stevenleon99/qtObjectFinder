/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#ifndef Q_MOC_RUN
#include <sys/alerts/itf/IAlertAggregator.h>
#include <drive/model/common.h>
#include <drive/plugin/registry/IPluginRegistry.h>
#include <gos/itf/scanmanager/IManualScanManager.h>
#include <gos/itf/watchdog/IWatchdog.h>
#include <drive/itf/settings/ISystemSettings.h>
#endif

#include <drive/com/propertysource/PluginPropertySource.h>

#include <QObject>
#include <QQuickItem>
#include <QStringList>
#include <QString>

class PluginModel : public QObject
{
    Q_OBJECT

    using PluginPropertySource =
        ::drive::com::propertysource::PluginPropertySource;

public:
    explicit PluginModel(
        sys::config::SystemType systemType,
        std::shared_ptr<drive::plugin::registry::IPluginRegistry>
            pluginRegistry,
        std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
        std::shared_ptr<gos::itf::scanmanager::IManualScanManager> scanManager,
        std::shared_ptr<drive::itf::settings::ISystemSettings> systemSettings,
        std::shared_ptr<gos::itf::watchdog::IWatchdog> watchdog,
        QObject* parent = nullptr);

    Q_INVOKABLE void newCase(const QString& pluginName);

    Q_INVOKABLE void launchSettingsPlugin(QQuickItem* containerItem,
                                          const QString& pluginName);
    Q_INVOKABLE void launchHeaderPlugin(QQuickItem* headerContainer,
                                        const QString& pluginName);
    Q_INVOKABLE void launchWorkflowPlugin(QQuickItem* workflowContainer,
                                          const QString& pluginName);
    Q_INVOKABLE void quitPlugin(const QString& pluginName);

    Q_INVOKABLE void windowCreated(QObject* window);

    Q_INVOKABLE void deletePluginCase(const QString& pluginName,
                                      const QString& caseId,
                                      const QStringList& screenshotsIds);

    Q_INVOKABLE void deleteAllCases();

    Q_INVOKABLE QStringList getAllSoftwareFeaturesList();

    Q_INVOKABLE QString systemName();

    void recoverCases();
    bool createEdgeLockFile();
    bool removeEdgeLockFile();

signals:
    void openWorkflowPlugin(QString workflow);
    void workflowQuit();
    void workflowPluginClosed();

public slots:
    void onSettingsQuitAcknowledged(std::string_view pluginName);
    void onWorkflowQuitRequested(std::string_view,
                                 drive::model::DriveCaseDataUpdater);
    void onWorkflowQuitAcknowledged(std::string_view,
                                    drive::model::DriveCaseDataUpdater);

private:
    void logDriveCaseData(const drive::model::DriveCaseData& data);
    std::vector<std::string> getAllSoftwareFeatures();
    void deleteScreenshots(const QStringList& screenshotsIds);
    bool doLockFileCommands(const QStringList& arguments);
    void deleteSensorhubLogs(const std::string& caseId);

private:
    sys::config::SystemType m_systemType;
    drive::model::WorkflowCaseId m_updatedWorkflowId{};
    const std::shared_ptr<drive::plugin::registry::IPluginRegistry>
        m_pluginRegistry;
    const std::unique_ptr<PluginPropertySource> m_pluginPropertySource;
    const std::shared_ptr<sys::alerts::itf::IAlertAggregator>
        m_alertViewRegistry;
    const std::shared_ptr<gos::itf::scanmanager::IManualScanManager>
        m_scanManager;
    const std::shared_ptr<drive::itf::settings::ISystemSettings>
        m_systemSettings;
    const std::shared_ptr<gos::itf::watchdog::IWatchdog> m_watchdog;
    std::string m_scanPath;
    std::optional<drive::model::SurgeonIdentifier> m_surgeonId;
    std::optional<std::string> m_surgeonName;
};
