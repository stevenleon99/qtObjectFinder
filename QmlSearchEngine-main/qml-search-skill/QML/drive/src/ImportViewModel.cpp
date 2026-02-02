#include "ImportViewModel.h"
#include "DriveAlerts.h"
#include "DriveScreenshots.h"
#include <drive/common/DriveCommon.h>
#include <sys/alerts/Alert.h>
#include <sys/alerts/AlertManagerFactory.h>
#include <drive/scanimport/VolumeImportAlerts.h>
#include <drive/scanimport/Predicates.h>
#include <drive/archiving/CaseArchiving.h>
#include <drive/common/DriveCommon.h>
#include <drive/common/PatientName.h>
#include <drive/com/propertysource/ModelSource.h>
#include <sys/config/config.h>
#include <gm/util/functional/optional.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <boost/uuid/uuid_io.hpp>
#include <boost/algorithm/string.hpp>
#include <QDateTime>
#include <QDebug>

#include <chrono>

using namespace drive::scanimport::alerts;
using namespace drive::archiving;
using namespace drive::viewmodel;

ImportViewModel::ImportViewModel(
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
    std::shared_ptr<drive::plugin::registry::IPluginRegistry> pluginRegistry,
    std::shared_ptr<gos::itf::scanmanager::IScanManagerHandle> scanManager,
    drive::scanimport::ImportViewModelSource* importViewModelSource,
    drive::caseimport::CaseImportViewModel* caseImportViewModel,
    QObject* parent)
    : QObject(parent)
    , m_alertViewRegistry(alertViewRegistry)
    , m_pluginRegistry(pluginRegistry)
    , m_scanManager(scanManager)
    , m_importViewModelSource(importViewModelSource)
    , m_caseImportViewModel(caseImportViewModel)
    , m_patientsPropertySource(std::make_unique<PatientsPropertySource>(parent))
    , m_casesPropertySource(std::make_unique<CasesPropertySource>())
    , m_alertManager(sys::alerts::AlertManagerFactory::createInstance())
    , m_patientMatchListModel(new PatientMatchListModel(this))
    , m_caseImportPath(
          sys::config::Config::instance()->config.apps().drive().data() /
          CASE_IMPORT_FOLDER)
{
    gm::util::qt::connect(m_importViewModelSource->scansImportedSignal, this,
                          &ImportViewModel::scanImportedStatus);
    gm::util::qt::connect(m_caseImportViewModel->caseImportRequested, this,
                          &ImportViewModel::onCaseImportRequested);
    gm::util::qt::connect(m_alertManager->clearRequested, this,
                          &ImportViewModel::handleAlertResponse);
    gm::util::qt::connect(m_scanManager->scanManagerConnectStateChanged, this,
                          &ImportViewModel::handleScanManagerConnectState);

    connect(m_patientsPropertySource.get(),
            &PatientsPropertySource::activePatientChanged, this,
            &ImportViewModel::handleActivePatientChanged);

    connect(m_patientsPropertySource.get(),
            &PatientsPropertySource::patientActiveChanged, this,
            &ImportViewModel::patientActiveChanged);

    connect(&m_importerFutureWatcher, &QFutureWatcher<void>::finished, this,
            &ImportViewModel::handleImporterExit);

    int actualExpiryTime = QThreadPool::globalInstance()->expiryTimeout();
    connect(
        &m_importerFutureWatcher, &QFutureWatcher<void>::finished, this,
        [actualExpiryTime]() {
            QThreadPool::globalInstance()->setExpiryTimeout(actualExpiryTime);
        });

    m_alertViewRegistry->addAlertView(m_alertManager);
    m_alertViewRegistry->addAlertView(importViewModelSource->getAlertView());
}

void ImportViewModel::handleActivePatientChanged(
    std::optional<drive::model::DataModel::PatientDetails> const& maybePatient)
{
    if (maybePatient)
    {
        auto&& patient = *maybePatient;
        m_importViewModelSource->setDestinationPatient(
            drive::scanimport::patientMatcher(
                {patient.patientName, patient.dateOfBirth, patient.gender,
                 patient.height, patient.weight, patient.medicalId}));
    }
    else
    {
        m_importViewModelSource->setDestinationPatient(
            gm::util::functional::predicate::alwaysTrue);
    }
}

PatientMatchListModel* ImportViewModel::patientMatchList() const
{
    return m_patientMatchListModel;
}

bool ImportViewModel::patientMatchFound() const
{
    return m_patientMatchFound;
}

void ImportViewModel::scanImportedStatus(
    FileInfo fileInfo, std::variant<ScanId, ScanError> importStatus)
{
    if (std::holds_alternative<DicomScan>(fileInfo.scan))
    {
        DicomScan dicomScan = std::get<DicomScan>(fileInfo.scan);
        qDebug() << "Printing import status from drive for series number: "
                 << QString::number(dicomScan.seriesNumber);
    }

    std::visit(gm::util::functional::visitor{
                   [&](ScanId scanId) {
                       qDebug() << "    Import Success. ScanId: "
                                << QString::fromStdString(to_string(scanId.id));
                       addScan(fileInfo, scanId);
                   },
                   [&](ScanError scanError) {
                       qDebug() << "    Import Failed. ScanError: "
                                << static_cast<size_t>(scanError);
                   }},
               importStatus);
}

void ImportViewModel::onCaseImportRequested(
    drive::archiving::CaseArchiveInfo archiveInfo,
    std::filesystem::path archiveFile)
{
    m_caseArchiveInfo = archiveInfo;
    m_archiveFilePath = archiveFile;

    if (patientActive() &&
        (m_casesPropertySource->selectedPatientId() != archiveInfo.patientId))
    {
        m_alertManager->createAlert(drive::alerts::alertsMap.at(
            drive::alerts::DriveAlerts::CaseImportMismatch));
        return;
    }

    importCase();
}

void ImportViewModel::handleImporterExit()
{
    if (m_importerFuture.result())
    {
        // same thread as GUI/QML thread hence directly updating QProperty
        m_caseImportViewModel->updateImportState(
            drive::caseimport::CaseImportViewModel::IMPORT_DATA);
        m_caseImportViewModel->updateImportStep(tr("Importing patient data"));
        auto surgeonName =
            QString::fromStdString(m_caseArchiveInfo.surgeonName);
        auto archiveRoot = m_caseImportPath;

        auto caseId = [&] {
            if (patientActive() &&
                !m_patientsPropertySource->selectedPatientIdStr().isEmpty())
                return m_casesPropertySource->importCase(
                    archiveRoot,
                    m_patientsPropertySource->selectedPatientIdStr(),
                    surgeonName);
            else
                return m_casesPropertySource->importCase(archiveRoot,
                                                         surgeonName);
        }();

        if (caseId.has_value())
        {
            m_caseImportViewModel->updateImportState(
                drive::caseimport::CaseImportViewModel::IMPORT_SUCCESS);
            m_caseImportViewModel->updateImportStep(tr("Success"));
            m_alertManager->createAlert(drive::alerts::alertsMap.at(
                drive::alerts::DriveAlerts::CaseImported));

            // Update persistence data
            auto theCase = drive::com::propertysource::ModelSource::instance()
                               .driveModel()
                               ->getCase(caseId.value());
            if (theCase.has_value())
            {
                drive::com::propertysource::ModelSource::instance()
                    .driveModel()
                    ->updateCase(caseId.value(),
                                 m_caseArchiveInfo.workflowCaseId,
                                 theCase.value().driveCaseData);
            }
            return;
        }
    }
    else
    {
        qDebug() << "Failed to import case archive";
    }

    m_caseImportViewModel->notifyImporterState(
        drive::caseimport::CaseImportViewModel::IMPORT_FAILED);
    m_caseImportViewModel->notifyImporterStep(tr("Failure"));
    if (drive::alerts::alertsMap.find(
            drive::alerts::DriveAlerts::CaseImportFailed) !=
        drive::alerts::alertsMap.end())
    {
        m_alertManager->createAlert(drive::alerts::alertsMap.at(
            drive::alerts::DriveAlerts::CaseImportFailed));
    }
}

void ImportViewModel::addScan(const FileInfo& fileInfo, const ScanId& scanId)
{
    if (fileInfo.fileType != ScanTypeFormat::DICOM ||
        !std::holds_alternative<DicomScan>(fileInfo.scan))
        return;

    DicomScan dicomScan = std::get<DicomScan>(fileInfo.scan);

    m_importedScanInfo = fileInfo;
    m_importedScanId = scanId;

    if (patientActive() &&
        !m_patientsPropertySource->selectedPatientIdStr().isEmpty())
    {
        mergePatientScan(m_patientsPropertySource->selectedPatientIdStr());
        return;
    }

    auto matchList = m_patientsPropertySource->matchPatient(
        QString::fromStdString(dicomScan.medicalRecordId),
        QString::fromStdString(dicomScan.patientName),
        getDate(dicomScan.patientDateOfBirth));
    if (matchList.empty())
    {
        addNewPatientScan();
        return;
    }

    m_patientMatchListModel->replacePatients(matchList);
    m_patientMatchFound = true;
    emit patientMatchChanged();
}

QString ImportViewModel::patientName() const
{
    // This should be a DICOM ever
    if (m_importedScanInfo.fileType == ScanTypeFormat::DICOM &&
        std::holds_alternative<DicomScan>(m_importedScanInfo.scan))
    {
        DicomScan ds = std::get<DicomScan>(m_importedScanInfo.scan);
        return QString::fromStdString(ds.patientName);
    }

    return "";
}

bool ImportViewModel::patientActive() const
{
    return m_patientsPropertySource->patientActive();
}

void ImportViewModel::setPatientActive(bool active)
{
    m_patientsPropertySource->setpatientActive(active);
}

void ImportViewModel::clearPatientMatch()
{
    m_patientMatchFound = false;
    emit patientMatchChanged();
}

void ImportViewModel::addNewPatientScan()
{
    if (m_importedScanInfo.fileType == ScanTypeFormat::DICOM &&
        std::holds_alternative<DicomScan>(m_importedScanInfo.scan))
    {
        DicomScan ds = std::get<DicomScan>(m_importedScanInfo.scan);
        m_patientsPropertySource->addPatient(
            QString::fromStdString(ds.medicalRecordId),
            QString::fromStdString(ds.patientName),
            getDate(ds.patientDateOfBirth), studyName(), m_importedScanId);
    }
    else
    {
        qDebug() << "Error: Adding a scan that is NOT a DICOM ";
    }
}

void ImportViewModel::mergePatientScan(const QString& patientIdStr)
{
    m_patientsPropertySource->addScan(patientIdStr, m_importedScanId,
                                      studyName());
}

void ImportViewModel::importCase()
{
    // same thread as GUI/QML thread hence directly updating QProperty
    m_caseImportViewModel->updateImportState(
        drive::caseimport::CaseImportViewModel::WAITING);
    m_caseImportViewModel->updateImportStep("");

    std::chrono::milliseconds newExpiryTimeMs(1);
    QThreadPool::globalInstance()->setExpiryTimeout(
        static_cast<int>(newExpiryTimeMs.count()));

    m_importerFuture = QtConcurrent::run(this, &ImportViewModel::caseImporter);
    m_importerFutureWatcher.setFuture(m_importerFuture);
}

bool ImportViewModel::caseImporter()
{
    QDir archiveDir(QString::fromStdString(m_caseImportPath.string()));
    if (archiveDir.exists())
    {
        clearDirectory(archiveDir);
    }
    else
    {
        if (!archiveDir.mkpath(archiveDir.absolutePath()))
        {
            qDebug() << "Failed to create archive folder "
                     << archiveDir.absolutePath();
            return false;
        }
    }

    m_caseImportViewModel->notifyImporterState(
        drive::caseimport::CaseImportViewModel::IMPORT_ARCHIVE);
    m_caseImportViewModel->notifyImporterStep(tr("Unpacking archive"));
    if (!m_caseImportViewModel->importArchiveFile(m_archiveFilePath,
                                                  m_caseImportPath))
    {
        qDebug() << "Failed to import archive file "
                 << QString::fromStdString(m_archiveFilePath.string());
        return false;
    }

    auto oldUuid = m_caseArchiveInfo.workflowCaseId.id;
    m_caseArchiveInfo.workflowCaseId.id = boost::uuids::random_generator()();

    qDebug() << "Changing workflow case id "
             << QString::fromStdString(to_string(oldUuid)) << " to "
             << QString::fromStdString(
                    to_string(m_caseArchiveInfo.workflowCaseId.id));

    if (!importCaseData(QString::fromStdString(m_caseArchiveInfo.pluginName),
                        m_caseArchiveInfo.workflowCaseId, m_caseImportPath))
    {
        qDebug() << "Failed to import case data for workflow case id "
                 << QString::fromStdString(
                        to_string(m_caseArchiveInfo.workflowCaseId.id));
        return false;
    }

    if (!importScreenshots(m_caseArchiveInfo.screenshots, m_caseImportPath))
    {
        qDebug() << "Failed to import case screenshots";
        return false;
    }

    if (!importCaseSeries(m_caseArchiveInfo.series, m_caseImportPath))
    {
        qDebug() << "Failed to import case series";
        return false;
    }

    return true;
}

bool ImportViewModel::importCaseData(
    const QString& pluginName,
    const drive::model::WorkflowCaseId& workflowId,
    const std::filesystem::path& archivePath)
{
    m_caseImportViewModel->notifyImporterState(
        drive::caseimport::CaseImportViewModel::IMPORT_CASE);
    m_caseImportViewModel->notifyImporterStep(tr("Importing case data"));
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
    if (pluginDataModel->caseExists(workflowId))
    {
        qDebug() << "Importing case data already exists"
                 << ", proceeding import without overwriting the case data";
        pluginHandle->unload();
        return true;
    }

    auto caseDir = archivePath / drive::archiving::CASE_ARCHIVE_FOLDER;
    if (!pluginDataModel->importCase(workflowId, caseDir))
    {
        qDebug() << "Failed to import workflow case data from directory "
                 << QString::fromStdString(caseDir.string());
        return false;
    }

    pluginHandle->unload();

    return true;
}

bool ImportViewModel::importCaseSeries(
    immer::vector<gos::itf::scanmanager::ScanId> series,
    const std::filesystem::path& archivePath)
{
    QString message = tr("Importing images");
    m_caseImportViewModel->notifyImporterState(
        drive::caseimport::CaseImportViewModel::IMPORT_SERIES);
    m_caseImportViewModel->notifyImporterStep(message);
    auto seriesDir = archivePath / drive::archiving::SERIES_ARCHIVE_FOLDER;

    if (!series.empty() && !m_scanManagerConnected)
    {
        qDebug() << "Failed to import series, scan manager not connected";
        return false;
    }

    for (auto scanId : series)
    {
        auto strId = to_string(scanId.id);
        m_caseImportViewModel->notifyImporterStep(
            message, QString::fromStdString(strId));
        auto scanDir = seriesDir / strId;
        m_scanManager->importInternal(scanId, scanDir);
    }

    return true;
}

bool ImportViewModel::importScreenshots(
    immer::vector<drive::model::ScreenshotId> screenshotIds,
    const std::filesystem::path& archivePath)
{
    QString message = tr("Importing screenshots");
    m_caseImportViewModel->notifyImporterState(
        drive::caseimport::CaseImportViewModel::IMPORT_SCREENSHOTS);
    m_caseImportViewModel->notifyImporterStep(message);

    auto screenshotFolder =
        archivePath / drive::archiving::SCREENSHOTS_ARCHIVE_FOLDER;

    auto persistenceDir = screenshotPersistenceDir(
        sys::config::Config::instance()->config.apps().drive().data());
    try
    {
        for (auto screenshotId : screenshotIds)
        {
            auto strId = to_string(screenshotId.id);
            m_caseImportViewModel->notifyImporterStep(
                message, QString::fromStdString(strId));
            auto source = screenshotFile(screenshotFolder, strId);

            auto destination = screenshotFile(
                persistenceDir, boost::uuids::to_string(screenshotId));

            if (exists(destination))
            {
                qDebug() << "Screenshot already exists, skip copying "
                         << QString::fromStdString(source.string());
                continue;
            }

            copy(source, destination);
        }
    }
    catch (std::filesystem::filesystem_error const& e)
    {
        qDebug() << "Failed to import screenshots :" << e.what();
        return false;
    }

    return true;
}

void ImportViewModel::handleAlertResponse(const sys::alerts::Alert& alert,
                                          const sys::alerts::Option& option)
{
    if (alert == drive::alerts::alertsMap.at(
                     drive::alerts::DriveAlerts::CaseImportMismatch))
    {
        if (option == drive::alerts::confirmOption)
        {
            importCase();
        }
    }
    m_alertManager->clearAlert(alert);
}

void ImportViewModel::handleScanManagerConnectState(
    gos::itf::scanmanager::ScanManagerConnectState state)
{
    m_scanManagerConnected =
        (state == gos::itf::scanmanager::ScanManagerConnectState::Connected);
}

QString ImportViewModel::studyName() const
{
    return "Study " +
           drive::common::formatDateTime(QDateTime::currentDateTime(),
                                         drive::common::EXTENDED_TIME_FORMAT);
}

QDateTime ImportViewModel::getDate(
    const std::chrono::system_clock::time_point& timePoint) const
{
    auto timeSinceEpoch =
        std::chrono::time_point_cast<std::chrono::milliseconds>(timePoint)
            .time_since_epoch()
            .count();
    return QDateTime::fromMSecsSinceEpoch(timeSinceEpoch);
}

void ImportViewModel::clearDirectory(QDir& directory) const
{
    directory.setFilter(QDir::NoDotAndDotDot | QDir::Files);
    foreach (QString dirItem, directory.entryList())
    {
        directory.remove(dirItem);
    }

    directory.setFilter(QDir::NoDotAndDotDot | QDir::Dirs);
    foreach (QString dirItem, directory.entryList())
    {
        QDir subDir(directory.absoluteFilePath(dirItem));
        subDir.removeRecursively();
    }
}
