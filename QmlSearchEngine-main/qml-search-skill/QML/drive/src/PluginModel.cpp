/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "PluginModel.h"
#include "CaseListModel.h"
#include "DriveScreenshots.h"
#include "CaseSummaryModel.h"
#include "PluginInfoListModel.h"
#include "util.h"

#include <drive/app/core/UserCaseReport.hpp>
#include <drive/com/propertysource/CasesPropertySource.h>
#include <drive/com/propertysource/ModelSource.h>
#include <drive/com/propertysource/UserModelPropertySource.h>
#include <drive/itf/plugin/ISettingsPluginGui.h>
#include <drive/itf/plugin/ISystemSettingsPluginGui.h>
#include <drive/itf/plugin/IWorkFlowPluginGui.h>
#include <drive/licensing/util.h>
#include <drive/model/common/serialization.h>
#include <drive/plugin/registry/PluginRegistryFactory.h>
#include <drive/plugin/shell/PluginShellFactory.h>
#include <drive/scanmanager/DriveScanManager.h>
#include <gm/arch/ContainerDictionary.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <gm/util/qt/typeconv/qstring_conv.h>
#include <procd/common/util/services/CaseSensorhubLoggingService.h>
#include <sys/config/config.h>
#include <sys/envvars/EnvVarsFactory.h>
#include <sys/licensing/client/KeyManagerFactory.h>
#include <sys/licensing/client/LicenseManagerFactory.h>
#include <sys/licensing/client/LicensedUserFactory.h>
#include <sys/report.h>
#include <sys/log/sys_log.h>
#include <legacy/licensing/settingsAccessor.h>

#include <imfusionrendering/ImFusionClient.h>
#include <cereal/archives/json.hpp>

#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQuickItem>
#include <QDebug>
#include <QProcessEnvironment>
#include <QProcess>
#include <QString>

using gm::util::typeconv::convert;

const auto PLUGIN_SCAN_DIR = "plugin_scan";

PluginModel::PluginModel(
    sys::config::SystemType systemType,
    std::shared_ptr<drive::plugin::registry::IPluginRegistry> pluginRegistry,
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
    std::shared_ptr<gos::itf::scanmanager::IManualScanManager> scanManager,
    std::shared_ptr<drive::itf::settings::ISystemSettings> systemSettings,
    std::shared_ptr<gos::itf::watchdog::IWatchdog> watchdog,
    QObject* parent)
    : QObject(parent)
    , m_systemType{systemType}
    , m_pluginRegistry(std::move(pluginRegistry))
    , m_pluginPropertySource(std::make_unique<PluginPropertySource>())
    , m_alertViewRegistry(std::move(alertViewRegistry))
    , m_scanManager(std::move(scanManager))
    , m_systemSettings(std::move(systemSettings))
    , m_watchdog{std::move(watchdog)}
    , m_scanPath(
          (sys::config::Config::instance()->config.apps().drive().data() /
           PLUGIN_SCAN_DIR)
              .string())
    , m_surgeonId(m_pluginPropertySource->getSurgeonId())
{}

void PluginModel::windowCreated(QObject* window)
{
    QQuickWindow* quickWindow = qobject_cast<QQuickWindow*>(window);

    if (!quickWindow)
    {
        QQuickItem* quickItem = qobject_cast<QQuickItem*>(window);

        if (quickItem)
        {
            quickWindow = quickItem->window();
        }
    }

    if (quickWindow)
    {
        QOpenGLContext* openGlContext = quickWindow->openglContext();

        if (openGlContext)
        {
            ImFusionClient::instance().qtQuickOpenglContextCreated(
                openGlContext);
        }
        else
        {
            connect(quickWindow, &QQuickWindow::openglContextCreated,
                    &ImFusionClient::instance(),
                    &ImFusionClient::qtQuickOpenglContextCreated);
        }
    }
}

void PluginModel::newCase(const QString& pluginName)
{
    auto drivePatientData = m_pluginPropertySource->getPatientData();

    if (drivePatientData.has_value())
    {
        if (auto pluginHandle =
                m_pluginRegistry->lookupPlugin(pluginName.toStdString()))
        {
            if (auto* plugin = pluginHandle->getPluginInstance())
            {
                auto pluginDataModel = plugin->getWorkflowDataModel();
                auto caseDetailsPair =
                    pluginDataModel->createNewCase(drivePatientData.value());

                if (caseDetailsPair.has_value())
                {
                    auto&& [workflowID, driveCaseData] =
                        caseDetailsPair.value();
                    auto caseId = m_pluginPropertySource->addCase(
                        workflowID, driveCaseData);

                    if (caseId.has_value())
                    {
                        m_pluginPropertySource->selectCase(caseId.value());
                        emit openWorkflowPlugin(
                            QString::fromStdString(workflowID.type));
                    }
                    else
                    {
                        qDebug() << "Failed to create new case: unable to add "
                                    "case for plugin"
                                 << pluginName;
                    }
                }
                else
                {
                    qDebug() << "Failed to create new case: unable to create "
                                "case for plugin"
                             << pluginName;
                }
            }
            else
            {
                qDebug() << "Failed to create new case: unable to create plugin"
                         << pluginName;
            }
        }
        else
        {
            qDebug() << "Failed to create new case: unable to load plugin"
                     << pluginName;
        }
    }
    else
    {
        qDebug() << "Failed to create new case: unable to get patient data.";
    }
}

void PluginModel::launchSettingsPlugin(QQuickItem* containerItem,
                                       const QString& pluginName)
{
    auto pluginHandle =
        m_pluginRegistry->lookupPlugin(pluginName.toStdString());
    if (!pluginHandle)
    {
        SYS_LOG_INFO(
            "Failed to launch workflow plugin: Plugin lookup failed for plugin "
            "{}",
            pluginName.toStdString());
        return;
    }
    SYS_LOG_INFO("PluginModel::LaunchSettingsPlugin {}",
                 pluginName.toStdString());
    auto* plugin = pluginHandle->getPluginInstance();
    if (!plugin)
    {
        SYS_LOG_INFO(
            "Failed to launch settings plugin: unable to create    instance "
            "for plugin {}",
            pluginName.toStdString());
        return;
    }

    auto pluginAlertViewer = plugin->getAlertView();
    if (pluginAlertViewer)
    {
        m_alertViewRegistry->addAlertView(pluginAlertViewer);
    }

    const auto pluginGui = plugin->getGui();
    auto settingGui =
        std::dynamic_pointer_cast<drive::itf::plugin::ISettingsPluginGui>(
            pluginGui);
    if (!settingGui)
    {
        SYS_LOG_INFO(
            "Failed to launch workflow plugin: unable to create gui  for "
            "plugin {}",
            pluginName.toStdString());
        return;
    }

    if (auto systemSettingsPlugin = std::dynamic_pointer_cast<
            drive::itf::plugin::ISystemSettingsPluginGui>(settingGui))
    {
        systemSettingsPlugin->setSystemSettings(m_systemSettings);
    }

    const auto pluginShell =
        drive::plugin::shell::PluginShellFactory::createInstance(
            pluginName, QUrl(pluginGui->getQmlPath().c_str()), containerItem);

    m_surgeonId = m_pluginPropertySource->getSurgeonId();
    if (pluginShell && m_surgeonId.has_value())
    {
        settingGui->runSettings(std::move(pluginShell),  //
                                getAllSoftwareFeatures(),  //
                                m_surgeonId.value());
    }
    else
    {
        SYS_LOG_INFO(
            "Failed to launch settings plugin: unable to create shell for "
            "plugin {}",
            pluginName.toStdString());
    }

    auto engine = qobject_cast<QQmlApplicationEngine*>(
        qmlContext(containerItem)->engine());
    std::optional<drive::settings::menu::MenuModel*> menu =
        settingGui->settingsMenu();
    engine->rootContext()->setContextProperty("menuModel",
                                              menu.value_or(nullptr));

    gm::util::qt::connect(settingGui->pluginQuitAcknowledged, this,
                          &PluginModel::onSettingsQuitAcknowledged);
}

void PluginModel::launchHeaderPlugin(QQuickItem* headerContainer,
                                     const QString& pluginName)
{
    if (auto pluginHandle =
            m_pluginRegistry->lookupPlugin(pluginName.toStdString()))
    {
        if (auto* plugin = pluginHandle->getPluginInstance())
        {
            const auto pluginGui = plugin->getGui();

            auto workflowGui = std::dynamic_pointer_cast<
                drive::itf::plugin::IWorkFlowPluginGui>(pluginGui);

            const auto shell =
                drive::plugin::shell::PluginShellFactory::createInstance(
                    pluginName, QUrl(workflowGui->getHeaderQmlPath().c_str()),
                    headerContainer);

            if (workflowGui)
            {
                m_surgeonId = m_pluginPropertySource->getSurgeonId();
                if (shell && m_surgeonId.has_value())
                {
                    // Allow QML update before further processing
                    QCoreApplication::processEvents();
                    workflowGui->runHeader(shell, m_surgeonId.value());
                }
                else
                {
                    qDebug() << "Failed to launch header plugin: unable to "
                                "create shell for plugin"
                             << pluginName;
                }
            }
            else
            {
                qDebug() << "Failed to launch header plugin: unable to create "
                            "gui for plugin"
                         << pluginName;
            }
        }
        else
        {
            qDebug()
                << "Failed to launch header plugin: unable to create plugin"
                << pluginName;
        }
    }
    else
    {
        qDebug() << "Failed to launch header plugin: unable to load plugin"
                 << pluginName;
    }
}

// Anonymous namespace to avoid name collisions
namespace {
void logUserCaseReport(const std::string& procedure)
{
    const auto caseProperties =
        std::make_unique<drive::com::propertysource::CasesPropertySource>();
    const auto userProperties =
        std::make_unique<drive::com::propertysource::UserModelPropertySource>();

    const auto rep = UserCaseReport{
        .case_uuid = caseProperties->selectedCaseIdStr().toStdString(),
        .user_uuid = userProperties->loggedInSurgeonId().toStdString(),
        .user_name = userProperties->loggedInSurgeonName().toStdString(),
        .procedure = procedure};

    sys::report::logReport(rep);
}
}  // namespace

void PluginModel::launchWorkflowPlugin(QQuickItem* workflowContainer,
                                       const QString& pluginName)
{
    auto pluginHandle =
        m_pluginRegistry->lookupPlugin(pluginName.toStdString());
    if (!pluginHandle)
    {
        qDebug() << "Failed to launch workflow plugin: Plugin lookup failed "
                    "for plugin "
                 << pluginName;
        return;
    }

    auto* plugin = pluginHandle->getPluginInstance();
    if (!plugin)
    {
        qDebug() << "Failed to launch workflow plugin: unable to create "
                    "instance for plugin"
                 << pluginName;
        return;
    }

    if (const auto watchdogFile = plugin->getWatchdogFile(m_systemType))
    {
        try
        {
            m_watchdog->loadConfig(watchdogFile.value());
        }
        catch (...)
        {
            // TODO: Consider notifying the user about an error
            qDebug() << "Failed to launch workflow plugin: unable to load "
                        "watchdog config for plugin"
                     << pluginName;
            return;
        }
    }

    auto pluginDataModel = plugin->getWorkflowDataModel();

    auto workflowCaseDependencies = m_pluginPropertySource->getCaseData();
    if (!workflowCaseDependencies)
    {
        qDebug() << "Failed to launch workflow plugin: unable to get case data "
                    "for plugin"
                 << pluginName;
        return;
    }

    auto& [workflowID, driveCaseData, series] = *workflowCaseDependencies;

    if (auto runningCase = m_pluginPropertySource->isCaseRunning())
    {
        if (auto pluginCaseDataUpdater =
                pluginDataModel->recoverCase(runningCase->id))
        {
            driveCaseData = (*pluginCaseDataUpdater)(driveCaseData);

            qDebug() << "Recovery success for workflow case "
                     << QString::fromStdString(
                            drive::model::id_to_string(runningCase->id));
            logDriveCaseData(driveCaseData);

            qDebug() << drive::util::workflowEndMessage(
                m_pluginPropertySource->selectedCase().value());

            m_pluginPropertySource->updateCase(runningCase->id, driveCaseData);
        }
        else
        {
            qDebug() << "Workflow case recovery failed, using last known "
                        "workflow case"
                     << pluginName;
        }
    }

    m_updatedWorkflowId = workflowID;

    //  Lock EDGE Log Service on plugin launch
    createEdgeLockFile();

    m_pluginPropertySource->setCaseRunning(m_updatedWorkflowId, pluginName);
    const auto pluginGui = plugin->getGui();
    auto workflowGui =
        std::dynamic_pointer_cast<drive::itf::plugin::IWorkFlowPluginGui>(
            pluginGui);
    if (!workflowGui)
    {
        qDebug() << "Failed to launch workflow plugin: unable to create gui "
                    "for plugin"
                 << pluginName;
        return;
    }

    const auto shell = drive::plugin::shell::PluginShellFactory::createInstance(
        pluginName, QUrl(pluginGui->getQmlPath().c_str()), workflowContainer);
    if (!shell)
    {
        qDebug() << "Failed to launch workflow plugin: unable to create shell "
                    "for plugin"
                 << pluginName;
        return;
    }

    gm::util::qt::connect(workflowGui->pluginQuitAcknowledged, this,
                          &PluginModel::onWorkflowQuitAcknowledged);
    gm::util::qt::connect(workflowGui->pluginQuitRequested, this,
                          &PluginModel::onWorkflowQuitRequested);
    auto scanManager = std::make_shared<drive::scanmanager::DriveScanManager>(
        m_scanPath, m_scanManager);

    logDriveCaseData(driveCaseData);

    qDebug() << drive::util::workflowBeginMessage(
        m_pluginPropertySource->selectedCase().value());

    std::vector<std::string> features = getAllSoftwareFeatures();

    logUserCaseReport(pluginName.toStdString());

    m_surgeonId = m_pluginPropertySource->getSurgeonId();
    m_surgeonName = m_pluginPropertySource->getSurgeonName();
    if (m_surgeonId.has_value())
    {
        // Allow QML update before further processing
        QCoreApplication::processEvents();
        workflowGui->runCase(
            m_updatedWorkflowId, driveCaseData, std::move(features),
            gm::arch::createDictionary(series), std::move(scanManager),
            std::move(shell), m_surgeonId.value(), m_surgeonName);
    }

    if (auto pluginAlertViewer = plugin->getAlertView())
    {
        m_alertViewRegistry->addAlertView(pluginAlertViewer);
    }
}

QString PluginModel::systemName()
{
    auto& platform = sys::config::Config::instance()->platform;
    sys::config::access::ConfigPlatformAccessor cpa{platform};

    return QString::fromStdString(cpa.cp.systemName());
}

std::vector<std::string> PluginModel::getAllSoftwareFeatures()
{
    using namespace sys::licensing::client;
    using namespace drive::licensing;

    auto keyManager = KeyManagerFactory::createInstance();

    auto licenseManager =
        LicenseManagerFactory::createInstance(keyManager->publicKey());

    auto& platform = sys::config::Config::instance()->platform;
    sys::config::access::ConfigPlatformAccessor cpa{platform};
    auto json = cpa.cp.suiteLicense();

    if (json.empty())
    {
        qDebug() << "Current License is empty in config_platform.json";
        return {};
    }

    std::istringstream iss(json);
    licenseManager->deserialize(iss);

    auto systemName = cpa.cp.systemName();
    auto licensedUserEntity = LicensedUserFactory::createInstance(systemName);

    auto license = licenseManager->license(*licensedUserEntity);

    return drive::licensing::util::getSoftwareFeaturesFromLicense(
        license.get());
}

QStringList PluginModel::getAllSoftwareFeaturesList()
{
    std::vector<std::string> features = getAllSoftwareFeatures();

    QStringList featureList;
    for (auto feature : features)
    {
        featureList.append(QString::fromStdString(feature));
    }

    return featureList;
}

void PluginModel::quitPlugin(const QString& pluginName)
{
    auto pluginHandle =
        m_pluginRegistry->lookupPlugin(pluginName.toStdString());
    if (!pluginHandle)
    {
        qDebug()
            << "Failed to request plugin quit: Plugin lookup failed for plugin "
            << pluginName;
        return;
    }

    auto* plugin = pluginHandle->getPluginInstance();
    if (!plugin)
    {
        qDebug() << "Failed to request plugin quit: unable to create instance "
                    "for plugin"
                 << pluginName;
        return;
    }

    //  Unlock EDGE Log Service on quitting plugin
    removeEdgeLockFile();

    const auto pluginGui = plugin->getGui();
    pluginGui->quitPlugin();

    if (const auto watchdogFile = plugin->getWatchdogFile(m_systemType))
    {
        try
        {
            m_watchdog->unloadConfig(watchdogFile.value());
        }
        catch (...)
        {
            // TODO: Consider notifying the user about an error
            qDebug() << "Failed to clean up after plugin: unable to unload "
                        "watchdog config for plugin"
                     << pluginName;
        }
    }
}

// This can not use deletePluginCase because the plugin destruction is
// asynchronus
void PluginModel::deleteAllCases()
{
    auto clm = CaseListModel();

    int totalCases = clm.count();

    auto pilm = drive::viewmodel::PluginInfoListModel();

    auto csm = CaseSummaryModel();

    QList<QPair<QString, QString>> cases;
    QSet<QString> pluginTypes;
    QStringList screenshotsIds;
    for (int i = 0; i < totalCases; i++)
    {
        auto caseIdRole =
            clm.data(clm.index(i, 0), CaseListModel::RoleNames::CaseId);

        auto caseIdTup =
            drive::model::string_to_id<drive::model::CaseOrStudyIdentifier>(
                caseIdRole.toString().toStdString());

        if (std::holds_alternative<drive::model::CaseIdentifier>(caseIdTup))
        {
            clm.selectCase(caseIdRole.toString());

            auto pluginInfoForWorkflow =
                pilm.pluginInfoForWorkflow(csm.caseType());
            drive::viewmodel::PluginInfo pluginInfo =
                pluginInfoForWorkflow.value<drive::viewmodel::PluginInfo>();

            QPair<QString, QString> casePair = {pluginInfo.pluginName,
                                                csm.caseId()};
            cases.push_back(casePair);

            pluginTypes.insert(pluginInfo.pluginName);

            for (auto screenshotId : csm.screenshotsIds())
            {
                screenshotsIds.push_back(screenshotId);
            }
        }
    }

    if (!cases.empty())
    {
        for (auto pluginType : pluginTypes)
        {
            if (auto pluginHandle =
                    m_pluginRegistry->lookupPlugin(pluginType.toStdString()))
            {
                if (auto* plugin = pluginHandle->getPluginInstance())
                {
                    auto pluginDataModel = plugin->getWorkflowDataModel();

                    for (auto theCase : cases)
                    {
                        if (theCase.first == pluginType)
                        {
                            auto caseDetailsPair =
                                m_pluginPropertySource->getCaseData(
                                    theCase.second);

                            if (caseDetailsPair.has_value())
                            {
                                auto& workflowID = caseDetailsPair->workflowId;
                                pluginDataModel->deleteCase(workflowID);
                                qDebug() << "Deleting case " << theCase.second;
                                m_pluginPropertySource->deleteCase(
                                    theCase.second);
                                deleteSensorhubLogs(
                                    boost::uuids::to_string(workflowID));
                            }
                        }
                    }

                    if (!pluginHandle->unload())
                    {
                        qDebug() << "Unload failed for settings plugin ";
                    }
                }
            }
        }

        if (!screenshotsIds.empty())
        {
            deleteScreenshots(screenshotsIds);
        }
    }
}

void PluginModel::deleteScreenshots(const QStringList& screenshotsIds)
{
    if (!screenshotsIds.empty())
    {
        auto screenshotsPath = drive::viewmodel::screenshotPersistenceDir(
            sys::config::Config::instance()->config.apps().drive().data());

        for (auto screenshot : screenshotsIds)
        {
            std::filesystem::path fileName = drive::viewmodel::screenshotFile(
                screenshotsPath, screenshot.toStdString());
            qDebug() << "Removing screenshot " << screenshot;
            try
            {
                if (std::filesystem::remove(fileName))
                {
                    qDebug() << "Removed screenshot " << screenshot;
                }
                else
                {
                    qDebug() << "Cannot remove screenshot " << screenshot;
                }
            }
            catch (const std::filesystem::filesystem_error& err)
            {
                qDebug() << "filesystem error: " << err.what();
            }
        }
    }
}

void PluginModel::deletePluginCase(const QString& pluginName,
                                   const QString& caseId,
                                   const QStringList& screenshotsIds)
{
    auto caseDetailsPair = m_pluginPropertySource->getCaseData(caseId);

    if (caseDetailsPair.has_value())
    {
        auto& workflowID = caseDetailsPair->workflowId;
        if (auto pluginHandle =
                m_pluginRegistry->lookupPlugin(pluginName.toStdString()))
        {
            if (auto* plugin = pluginHandle->getPluginInstance())
            {
                auto pluginDataModel = plugin->getWorkflowDataModel();
                pluginDataModel->deleteCase(workflowID);
                m_pluginPropertySource->deleteCase(caseId);
                deleteSensorhubLogs(boost::uuids::to_string(workflowID));
                if (!screenshotsIds.empty())
                {
                    deleteScreenshots(screenshotsIds);
                }
            }
            else
            {
                qDebug() << "Failed to delete plugin case: unable to get "
                            "instance for plugin"
                         << pluginName;
            }

            if (!pluginHandle->unload())
            {
                qDebug() << "Unload failed for settings plugin " << pluginName;
            }
        }
        else
        {
            qDebug() << "Failed to delete plugin case: unable to load plugin"
                     << pluginName;
        }
    }
    else
    {
        qDebug()
            << "Failed to delete plugin case: unable to get case data plugin"
            << pluginName << "with case id" << caseId;
    }
}

void PluginModel::deleteSensorhubLogs(const std::string& caseId)
{
    auto logDir =
        procd::common::util::services::CaseSensorhubLoggingService::getLogDir(
            caseId);
    try
    {
        std::filesystem::remove_all(logDir);
    }
    catch (std::filesystem::filesystem_error const& e)
    {
        qWarning() << "Failed to remove tracking logs at \""
                   << logDir.string().c_str() << "\": " << e.what();
    }
}

void PluginModel::onSettingsQuitAcknowledged(std::string_view pluginName)
{
    if (auto pluginHandle = m_pluginRegistry->lookupPlugin(pluginName))
    {
        if (auto* plugin = pluginHandle->getPluginInstance())
        {
            const auto pluginAlertViewer = plugin->getAlertView();

            if (pluginAlertViewer)
            {
                m_alertViewRegistry->removeAlertView(pluginAlertViewer);
            }
        }

        if (!pluginHandle->unload())
        {
            qDebug() << "Unload failed for settings plugin "
                     << QString::fromStdString(pluginName.data());
        }
    }
}

void PluginModel::onWorkflowQuitRequested(
    std::string_view pluginName,
    drive::model::DriveCaseDataUpdater caseDataUpdater)
{
    emit workflowQuit();
    onWorkflowQuitAcknowledged(pluginName, caseDataUpdater);
}

void PluginModel::onWorkflowQuitAcknowledged(
    std::string_view pluginName,
    drive::model::DriveCaseDataUpdater caseDataUpdater)
{
    emit workflowPluginClosed();

    auto qstrPluginName = convert<QString>(pluginName);

    if (auto pluginHandle = m_pluginRegistry->lookupPlugin(pluginName))
    {
        if (auto* plugin = pluginHandle->getPluginInstance())
        {
            const auto pluginAlertViewer = plugin->getAlertView();

            if (pluginAlertViewer)
            {
                m_alertViewRegistry->removeAlertView(pluginAlertViewer);
            }
        }

        if (!pluginHandle->unload())
        {
            qDebug() << "Unload failed for workflow plugin " << qstrPluginName;
        }
    }

    auto workflowCaseDependencies = m_pluginPropertySource->getCaseData();
    if (!workflowCaseDependencies)
    {
        qDebug() << "Unable to get case data for plugin" << qstrPluginName;
        return;
    }

    auto& [workflowID, driveCaseData, series] = *workflowCaseDependencies;

    qDebug() << "Updating case data for exiting case "
             << QString::fromStdString(
                    drive::model::id_to_string(m_updatedWorkflowId));

    driveCaseData = caseDataUpdater(driveCaseData);
    logDriveCaseData(driveCaseData);

    qDebug() << drive::util::workflowEndMessage(
        m_pluginPropertySource->selectedCase().value());
    m_pluginPropertySource->updateCase(m_updatedWorkflowId, driveCaseData);
    m_pluginPropertySource->removeCaseRunning();
}


void PluginModel::recoverCases()
{
    try
    {
        auto runningCases = m_pluginPropertySource->runningCases();
        for (auto runningCase : runningCases)
        {
            auto pluginName = convert<QString>(runningCase.second.pluginName);

            auto pluginHandle =
                m_pluginRegistry->lookupPlugin(runningCase.second.pluginName);
            if (!pluginHandle)
            {
                qDebug() << "Plugin lookup failed for plugin " << pluginName;
                continue;
            }

            auto* plugin = pluginHandle->getPluginInstance();
            if (!plugin)
            {
                qDebug() << "Unable to create instance for plugin"
                         << pluginName;
                continue;
            }

            auto workflowCaseDependencies =
                m_pluginPropertySource->getSurgeonCaseData(runningCase.first);
            if (!workflowCaseDependencies)
            {
                qDebug() << "Unable to get case data for plugin" << pluginName;
                return;
            }

            auto& [workflowID, driveCaseData, series] =
                *workflowCaseDependencies;

            auto pluginDataModel = plugin->getWorkflowDataModel();
            if (auto pluginCaseDataUpdater =
                    pluginDataModel->recoverCase(runningCase.second.id))
            {
                auto updatedCase = (*pluginCaseDataUpdater)(driveCaseData);
                qDebug() << "Recovery success for case "
                         << QString::fromStdString(drive::model::id_to_string(
                                runningCase.second.id));
                logDriveCaseData(updatedCase);

                if (m_pluginPropertySource->updateSurgeonCase(
                        runningCase.first, runningCase.second.id, updatedCase))
                {
                    m_pluginPropertySource->removeCaseRunning(
                        runningCase.first);
                }
            }

            pluginHandle->unload();
        }
    }
    catch (const std::exception& e)
    {
        qDebug() << "Failed to recover cases, exception: " << e.what();
    }
}

void PluginModel::logDriveCaseData(const drive::model::DriveCaseData& data)
{
    std::stringstream logged;
    {
        cereal::JSONOutputArchive ar(logged);
        ar(data);
    }
}

//  Lock EDGE Log Service on plugin launch
bool PluginModel::createEdgeLockFile()
{
    QStringList arguments;
    arguments << "state"
              << "lock";

    return doLockFileCommands(arguments);
}

//  Unlock EDGE Log Service on quitting plugin
bool PluginModel::removeEdgeLockFile()
{
    QStringList arguments;
    arguments << "state"
              << "unlock";

    return doLockFileCommands(arguments);
}

bool PluginModel::doLockFileCommands(const QStringList& arguments)
{
    auto env = sys::envvars::EnvVarsFactory::createInstance();
    std::filesystem::path cli =
        env->installationDir() / "bin" / "client_services_cli.exe";

    QProcess process;
    process.start(QString::fromStdString(cli.string()), arguments);
    process.waitForFinished(5000);

    QByteArray output = process.readAllStandardOutput();
    QString outputStr(output);

    return outputStr.contains("success", Qt::CaseInsensitive);
}
