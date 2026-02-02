/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include "PatientMatchListModel.h"
#include <drive/scanimport/ImportViewModelSource.h>
#include <drive/scanimport/VolumeImportViewModel.h>
#include <drive/caseimport/CaseImportViewModel.h>
#include <drive/com/propertysource/PatientsPropertySource.h>
#include <drive/com/propertysource/CasesPropertySource.h>

#ifndef Q_MOC_RUN
#include "drive/archiving/CaseArchiving.h"
#include <drive/plugin/registry/IPluginRegistry.h>
#include <sys/alerts/itf/IAlertAggregator.h>
#include <sys/alerts/itf/IAlertManager.h>
#include <gos/itf/scanmanager/IScanManagerHandle.h>
#include <QtConcurrent>
#endif

#include <QObject>

class ImportViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(
        QAbstractListModel* patientMatchList READ patientMatchList CONSTANT)
    Q_PROPERTY(bool patientMatchFound READ patientMatchFound NOTIFY
                   patientMatchChanged)
    Q_PROPERTY(QString patientName READ patientName NOTIFY patientNameChanged)
    Q_PROPERTY(bool patientActive READ patientActive WRITE setPatientActive
                   NOTIFY patientActiveChanged)

    using PatientsPropertySource =
        ::drive::com::propertysource::PatientsPropertySource;
    using CasesPropertySource =
        ::drive::com::propertysource::CasesPropertySource;

public:
    explicit ImportViewModel(
        std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
        std::shared_ptr<drive::plugin::registry::IPluginRegistry>
            pluginRegistry,
        std::shared_ptr<gos::itf::scanmanager::IScanManagerHandle> scanManager,
        drive::scanimport::ImportViewModelSource* importViewModelSource,
        drive::caseimport::CaseImportViewModel* caseImportViewModel,
        QObject* parent = nullptr);
    PatientMatchListModel* patientMatchList() const;
    bool patientMatchFound() const;
    QString patientName() const;
    bool patientActive() const;
    void setPatientActive(bool active);

    Q_INVOKABLE void clearPatientMatch();
    Q_INVOKABLE void addNewPatientScan();
    Q_INVOKABLE void mergePatientScan(const QString& patientIdStr);

signals:
    void patientMatchChanged();
    void patientNameChanged();
    void patientActiveChanged();

private slots:
    void scanImportedStatus(FileInfo fileInfo,
                            std::variant<ScanId, ScanError> importStatus);
    void onCaseImportRequested(drive::archiving::CaseArchiveInfo,
                               std::filesystem::path archiveFile);
    void handleImporterExit();
    void handleAlertResponse(const sys::alerts::Alert& alert,
                             const sys::alerts::Option& option);
    void handleScanManagerConnectState(
        gos::itf::scanmanager::ScanManagerConnectState state);
    void handleActivePatientChanged(
        std::optional<drive::model::DataModel::PatientDetails> const&);

private:
    void addScan(const FileInfo& fileInfo, const ScanId& scanId);
    void importCase();
    bool caseImporter();
    bool importCaseData(const QString& pluginName,
                        const drive::model::WorkflowCaseId& workflowId,
                        const std::filesystem::path& archivePath);
    bool importCaseSeries(immer::vector<gos::itf::scanmanager::ScanId> series,
                          const std::filesystem::path& archivePath);
    bool importScreenshots(
        immer::vector<drive::model::ScreenshotId> screenshotIds,
        const std::filesystem::path& archivePath);
    QString studyName() const;
    QDateTime getDate(
        const std::chrono::system_clock::time_point& timePoint) const;
    void clearDirectory(QDir& directory) const;

    std::shared_ptr<sys::alerts::itf::IAlertAggregator> m_alertViewRegistry;
    std::shared_ptr<drive::plugin::registry::IPluginRegistry> m_pluginRegistry;
    std::shared_ptr<gos::itf::scanmanager::IScanManagerHandle> m_scanManager;
    drive::scanimport::ImportViewModelSource* m_importViewModelSource;
    drive::caseimport::CaseImportViewModel* m_caseImportViewModel;
    std::unique_ptr<PatientsPropertySource> m_patientsPropertySource;
    std::unique_ptr<CasesPropertySource> m_casesPropertySource;
    std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertManager;
    PatientMatchListModel* m_patientMatchListModel;
    bool m_patientMatchFound = false;
    FileInfo m_importedScanInfo;
    ScanId m_importedScanId;

    drive::archiving::CaseArchiveInfo m_caseArchiveInfo;
    std::filesystem::path m_archiveFilePath;
    std::filesystem::path m_caseImportPath;
    bool m_scanManagerConnected = false;

    QFuture<bool> m_importerFuture;
    QFutureWatcher<bool> m_importerFutureWatcher;
};
