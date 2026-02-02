/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "CaseExportViewModel.h"
#include "DriveAlerts.h"
#include "DriveScreenshots.h"
#include "util.h"

#ifndef Q_MOC_RUN
#include <drive/plugin/shell/PluginShellFactory.h>
#include <module/archiving/management.h>
#include <drive/archiving/CaseArchiving.h>
#include <utilities/scriptHandling.h>
#include <gm/util/time.h>
#include <sys/alerts/AlertManagerFactory.h>
#include <sys/log.h>
#include <sys/config/config.h>
#include <sys/envvars/EnvVarsFactory.h>
#include <boost/algorithm/string.hpp>
#include <boost/uuid/random_generator.hpp>
#include <boost/uuid/uuid_io.hpp>
#endif

#include <gm/util/qt/qt_boost_signals2.h>
#include <gm/util/qt/qtContinuation.h>
#include <gm/util/qt/debug.h>
#include <gm/util/qt/typeconv/qstring_conv.h>
#include <procd/common/util/services/CaseSensorhubLoggingService.h>
#include <QDateTime>
#include <QDebug>

#include <chrono>

using namespace drive::archiving;
using namespace std::filesystem;
using namespace drive::alerts;
using gm::util::typeconv::convert;

CaseExportViewModel::CaseExportViewModel(
    std::shared_ptr<drive::plugin::registry::IPluginRegistry> pluginRegistry,
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
    std::shared_ptr<gos::itf::scanmanager::IScanManagerHandle> scanManager,
    std::shared_ptr<IDeviceIO> deviceIo,
    QObject* parent)
    : QObject(parent)
    , m_pluginRegistry(pluginRegistry)
    , m_alertViewRegistry(alertViewRegistry)
    , m_scanManager(scanManager)
    , m_alertManager(sys::alerts::AlertManagerFactory::createInstance())
    , m_casesPropertySource(std::make_unique<CasesPropertySource>())
    , m_deviceIo{deviceIo}
    , m_archiveLocations{deviceIo->exportLocations()}
    , m_exportLocations(new drive::archiving::LocationsViewModel(this))
{
    connect(this, &CaseExportViewModel::archiveLocationsChanged, this,
            &CaseExportViewModel::updateLocations);
    connect(&m_exporterFutureWatcher, &QFutureWatcher<void>::finished, this,
            &CaseExportViewModel::handleExporterExit);
    int actualExpiryTime = QThreadPool::globalInstance()->expiryTimeout();
    connect(
        &m_exporterFutureWatcher, &QFutureWatcher<void>::finished, this,
        [actualExpiryTime]() {
            QThreadPool::globalInstance()->setExpiryTimeout(actualExpiryTime);
        });

    gm::util::qt::connect(m_alertManager->clearRequested, this,
                          &CaseExportViewModel::handleAlertResponse);
    gm::util::qt::connect(m_scanManager->scanManagerConnectStateChanged, this,
                          &CaseExportViewModel::handleScanManagerConnectState);

    m_archiveLocations->changed.connect(
        [this](auto const&) { Q_EMIT archiveLocationsChanged(); });

    m_alertViewRegistry->addAlertView(m_alertManager);

    connect(this, &CaseExportViewModel::notifyExporterStep, this,
            &CaseExportViewModel::updateExportStep,
            Qt::ConnectionType::QueuedConnection);
    connect(this, &CaseExportViewModel::notifyExporterState, this,
            &CaseExportViewModel::updateExportState,
            Qt::ConnectionType::QueuedConnection);

    qRegisterMetaType<CaseExportViewModel::CaseExportState>("CaseExportState");
}

void CaseExportViewModel::exportCase(const QString& pluginName,
                                     const QString& caseId,
                                     const QString& location)
{
    std::chrono::milliseconds newExpiryTimeMs(1);
    QThreadPool::globalInstance()->setExpiryTimeout(
        static_cast<int>(newExpiryTimeMs.count()));

    m_exporterFuture = QtConcurrent::run(
        this, &CaseExportViewModel::caseExporter, pluginName, caseId, location);
    m_exporterFutureWatcher.setFuture(m_exporterFuture);
}

void CaseExportViewModel::handleAlertResponse(const sys::alerts::Alert& alert,
                                              const sys::alerts::Option&)
{
    m_alertManager->clearAlert(alert);
}

void CaseExportViewModel::handleExporterExit()
{
    auto result = m_exporterFuture.result();
    if (result != CaseExportResult::FAILURE)
    {
        // same thread as GUI/QML thread hence directly updating QProperty
        updateExportState(EXPORT_SUCCESS);
        updateExportStep(tr("Success"));
        if (result == CaseExportResult::NO_LOGS)
        {
            m_alertManager->createAlert(
                alertsMap.at(DriveAlerts::CaseLogsExportFailed));
        }
        else
        {
            m_alertManager->createAlert(
                alertsMap.at(DriveAlerts::CaseExported));
        }
        return;
    }

    updateExportState(EXPORT_FAILED);
    updateExportStep(tr("Failed"));
    m_alertManager->createAlert(alertsMap.at(DriveAlerts::CaseExportFailed));
}

void CaseExportViewModel::handleScanManagerConnectState(
    gos::itf::scanmanager::ScanManagerConnectState state)
{
    m_scanManagerConnected =
        (state == gos::itf::scanmanager::ScanManagerConnectState::Connected);
}

void CaseExportViewModel::updateLocations()
{
    auto locations =
        m_archiveLocations->get()->eval<std::vector<LabeledLocation>>();
    m_exportLocations->replaceLocations(locations);
}

auto unique_path()
{
    static auto uuid_gen = boost::uuids::random_generator{};
    using namespace std::filesystem;
    return sys::envvars::EnvVarsFactory::createInstance()->tempStorageDir() /
           "drive" / to_string(uuid_gen());
}

CaseExportViewModel::CaseExportResult CaseExportViewModel::caseExporter(
    const QString& pluginName, const QString& caseId, const QString& location)
{
    notifyExporterState(WAITING);
    notifyExporterStep(tr("Starting export"));

    qDebug() << "Exporting case for uuid " << caseId << " to location "
             << location;

    auto archivePath = unique_path();
    try
    {
        create_directories(archivePath);
    }
    catch (std::filesystem::filesystem_error const& e)
    {
        qDebug() << "Failed to create archive directory:" << e.what()
                 << e.path1();
        return CaseExportResult::FAILURE;
    }

    notifyExporterState(EXPORT_DATA);
    notifyExporterStep(tr("Collecting patient data"));
    auto caseInfo = m_casesPropertySource->exportCase(archivePath, caseId);

    if (!caseInfo)
    {
        qDebug() << "Could not export drive case";
        std::filesystem::remove_all(archivePath.parent_path());
        return CaseExportResult::FAILURE;
    }

    if (!exportCaseData(pluginName, caseInfo->workflowCaseId, archivePath))
    {
        qDebug() << "Failed to export plugin case data for the archive";
        std::filesystem::remove_all(archivePath.parent_path());
        return CaseExportResult::FAILURE;
    }

    if (!exportCaseSeries(caseInfo->series, archivePath))
    {
        qDebug() << "Failed to export series for the archive";
        std::filesystem::remove_all(archivePath.parent_path());
        return CaseExportResult::FAILURE;
    }
    if (!exportScreenshots(caseInfo->screenshots, archivePath))
    {
        qDebug() << "Failed to export screenshots for the archive";
        std::filesystem::remove_all(archivePath.parent_path());
        return CaseExportResult::FAILURE;
    }

    auto result = CaseExportResult::SUCCESS;

    notifyExporterState(EXPORT_LOGS);
    notifyExporterStep(tr("Collecting case logs"));

    exportSensorhubLogs(boost::uuids::to_string(caseInfo->workflowCaseId.id),
                        archivePath);

    if (!utilities::scripting::exportLogsToCSVHelper(
            archivePath / LOGS_ARCHIVE_FILE,
            utilities::scripting::exportLogsOptions::exportCase,
            drive::util::workflowBeginMessage(caseId),
            drive::util::workflowEndMessage(caseId)))
    {
        qDebug() << "Could not export logs, skipping";
        result = CaseExportResult::NO_LOGS;
    }

    CaseArchiveInfo archiveInfo{
        caseInfo->patientId,
        caseInfo->workflowCaseId,
        caseInfo->series,
        caseInfo->caseDetails,
        caseInfo->patientData,
        caseInfo->archiveId,
        m_casesPropertySource->surgeonName().toStdString(),
        std::chrono::system_clock::now(),
        pluginName.toStdString(),
        caseInfo->screenshots};

    auto archiveFile = path(location.toStdString()) / archiveFileName();
    try
    {
        notifyExporterState(EXPORT_ARCHIVE);
        auto reporter = [this](auto step, auto msg, size_t, size_t) {
            auto stepMessage = [](auto step_) -> QString {
                using Step = module::archiving::ArchivingStep;
                switch (step_)
                {
                case Step::AddingFile: return tr("Adding file: ");
                case Step::Finalizing: return tr("Finalizing archive");
                case Step::Compressing:
                    return tr("Compressing archive (this may take a while)");
                case Step::Packaging:
                    return tr("Packaging archive (this may take a while)");
                case Step::Cleanup: return tr("Cleaning up temporary files");
                default: return "";
                }
            };
            notifyExporterStep(tr("Archiving into destination"),
                               stepMessage(step) + convert<QString>(msg));
        };
        auto busyGuard = m_deviceIo->deviceActivity(archiveFile)->busyGuard();
        module::archiving::exportArchive(archiveInfo, archivePath, archiveFile,
                                         ARCHIVE_PASSWORD, reporter);
        std::filesystem::remove_all(archivePath.parent_path());
        return result;
    }
    catch (std::filesystem::filesystem_error const& e)
    {
        qDebug() << "Filesystem exception on exporting archive:" << e.what()
                 << e.path1() << e.path2();
        std::filesystem::remove_all(archivePath.parent_path());
        return CaseExportResult::FAILURE;
    }
    catch (const std::exception& e)
    {
        SYS_LOG_EXCEPTION(e);
        qDebug() << "Exception on exporting archive" << archivePath
                 << archiveFile << "- Error:" << e.what();
        std::filesystem::remove_all(archivePath.parent_path());
        return CaseExportResult::FAILURE;
    }
}

bool CaseExportViewModel::exportCaseData(
    const QString& pluginName,
    const drive::model::WorkflowCaseId& workflowId,
    const std::filesystem::path& archivePath)
{
    notifyExporterState(EXPORT_CASE);
    notifyExporterStep(tr("Collecting case data"));

    auto caseDir = archivePath / CASE_ARCHIVE_FOLDER;

    try
    {
        create_directories(caseDir);
    }
    catch (std::filesystem::filesystem_error const& e)
    {
        qDebug() << "Failed to create workflow case directory:" << e.what()
                 << e.path1();
        return false;
    }

    auto pluginHandle =
        m_pluginRegistry->lookupPlugin(pluginName.toStdString());
    if (!pluginHandle)
    {
        qDebug() << "Plugin lookup failed for plugin " << pluginName;
        return false;
    }

    auto* plugin = pluginHandle->getPluginInstance();
    if (!plugin)
    {
        qDebug() << "Unable to create instance for plugin" << pluginName;
        return false;
    }

    const auto pluginAlertViewer = plugin->getAlertView();
    if (pluginAlertViewer)
    {
        m_alertViewRegistry->addAlertView(pluginAlertViewer);
    }

    auto pluginDataModel = plugin->getWorkflowDataModel();
    auto result = pluginDataModel->exportCase(workflowId, caseDir);
    if (!result)
    {
        qDebug() << "Failed to export workflow case data to directory "
                 << QString::fromStdString(caseDir.string());
    }

    pluginHandle->unload();
    return result;
}

bool CaseExportViewModel::exportCaseSeries(
    immer::vector<gos::itf::scanmanager::ScanId> series,
    const std::filesystem::path& archivePath)
{
    notifyExporterState(EXPORT_SERIES);
    QString message = tr("Collecting images");
    notifyExporterStep(message);

    auto seriesDir = (archivePath / SERIES_ARCHIVE_FOLDER);
    try
    {
        create_directories(seriesDir);
    }
    catch (std::filesystem::filesystem_error const& e)
    {
        qDebug() << "Failed to create series directory:" << e.what()
                 << e.path1();
        return false;
    }

    if (!series.empty() && !m_scanManagerConnected)
    {
        qDebug() << "Failed to export series, scan manager not connected";
        return false;
    }

    for (auto scanId : series)
    {
        auto strId = to_string(scanId.id);
        auto scanDir = seriesDir / strId;
        notifyExporterStep(message, convert<QString>(strId));
        qDebug() << "Exporting series:" << scanDir;

        using gos::itf::scanmanager::Status;
        if (m_scanManager->exportInternal(scanId, scanDir) == Status::Failure)
        {
            qDebug() << "Failed to export series with Id "
                     << to_string(scanId.id);
            return false;
        }
    }

    return true;
}

bool CaseExportViewModel::exportScreenshots(
    immer::vector<drive::model::ScreenshotId> screenshotIds,
    const std::filesystem::path& archivePath)
{
    QString message = tr("Collecting screenshots");
    notifyExporterState(EXPORT_SCREENSHOTS);
    notifyExporterStep(message);

    auto screenshotFolder = (archivePath / SCREENSHOTS_ARCHIVE_FOLDER);

    try
    {
        create_directories(screenshotFolder);
        auto persistenceDir = drive::viewmodel::screenshotPersistenceDir(
            sys::config::Config::instance()->config.apps().drive().data());

        for (auto screenshotId : screenshotIds)
        {
            using drive::viewmodel::screenshotFile;

            auto strId = to_string(screenshotId.id);
            notifyExporterStep(message, convert<QString>(strId));
            auto source = screenshotFile(persistenceDir, strId);
            auto destination = screenshotFile(screenshotFolder, strId);

            copy(source, destination);
        }
    }
    catch (std::filesystem::filesystem_error const& e)
    {
        qDebug() << "Failed to export screenshots :" << e.what() << e.path1();
        return false;
    }

    return true;
}

void CaseExportViewModel::exportSensorhubLogs(
    const std::string& caseId, const std::filesystem::path& archivePath)
{
    auto logDir =
        procd::common::util::services::CaseSensorhubLoggingService::getLogDir(
            caseId);
    auto trackingLogsFolder = (archivePath / TRACKING_LOGS_FOLDER);
    try
    {
        std::filesystem::copy(logDir, trackingLogsFolder,
                              std::filesystem::copy_options::recursive);
    }
    catch (std::filesystem::filesystem_error const& e)
    {
        qWarning() << "Failed to copy tracking logs :" << e.what() << e.path1();
    }
}

void CaseExportViewModel::updateExportState(CaseExportState exportState)
{
    if (m_exportState != exportState)
    {
        m_exportState = exportState;
        emit exportStateChanged();
    }
}

void CaseExportViewModel::updateExportStep(QString const& step,
                                           QString const& detail)
{
    if (m_exportStep != step)
    {
        m_exportStep = step;
        emit exportStepChanged();
    }
    if (m_exportStepDetail != detail)
    {
        m_exportStepDetail = detail;
        emit exportStepDetailChanged();
    }
}

std::string CaseExportViewModel::archiveFileName()
{
    auto currentTime =
        QDateTime::currentDateTime().toString(" dd-MMM-yyyy_hh-mm-ss");
    std::string archiveName =
        m_casesPropertySource->surgeonName().toStdString() +
        currentTime.toStdString() + CASE_ARCHIVE_EXTN;

    boost::replace_all(archiveName, " ", "-");
    return archiveName;
}
