/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/archiving/LocationsViewModel.h>
#include <drive/com/propertysource/CasesPropertySource.h>

#ifndef Q_MOC_RUN
#include <drive/model/common.h>
#include <drive/plugin/registry/IPluginRegistry.h>
#include <gos/itf/scanmanager/IScanManagerHandle.h>
#include <gos/itf/deviceio/IDeviceIO.h>
#include <sys/alerts/itf/IAlertAggregator.h>
#include <sys/alerts/itf/IAlertManager.h>
#include <QtConcurrent>
#endif

#include <QObject>

using gos::itf::deviceio::IDeviceIO;

class CaseExportViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QAbstractListModel* locationList READ locationList CONSTANT)
    Q_PROPERTY(
        CaseExportState exportState READ exportState NOTIFY exportStateChanged)
    Q_PROPERTY(QString exportStep READ exportStep NOTIFY exportStepChanged)
    Q_PROPERTY(QString exportStepDetail READ exportStepDetail NOTIFY
                   exportStepDetailChanged)

    using CasesPropertySource =
        ::drive::com::propertysource::CasesPropertySource;

public:
    enum CaseExportState
    {
        WAITING = 0,
        EXPORT_DATA,
        EXPORT_CASE,
        EXPORT_SERIES,
        EXPORT_SCREENSHOTS,
        EXPORT_LOGS,
        EXPORT_ARCHIVE,
        EXPORT_SUCCESS,
        EXPORT_FAILED
    };
    Q_ENUMS(CaseExportState)

    enum class CaseExportResult
    {
        SUCCESS,
        FAILURE,
        NO_LOGS
    };


    explicit CaseExportViewModel(
        std::shared_ptr<drive::plugin::registry::IPluginRegistry>
            pluginRegistry,
        std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
        std::shared_ptr<gos::itf::scanmanager::IScanManagerHandle> scanManager,
        std::shared_ptr<IDeviceIO>,
        QObject* parent = nullptr);

    QAbstractListModel* locationList() const { return m_exportLocations; }

    CaseExportState exportState() const { return m_exportState; }
    QString exportStep() const { return m_exportStep; }
    QString exportStepDetail() const { return m_exportStepDetail; }

    Q_INVOKABLE void exportCase(const QString& pluginName,
                                const QString& caseId,
                                const QString& path);

signals:
    void archiveLocationsChanged();
    void exportStateChanged();
    void exportStepChanged();
    void exportStepDetailChanged();
    void notifyExporterStep(const QString& step, const QString& detail = "");
    void notifyExporterState(const CaseExportState& state);

private slots:
    void handleAlertResponse(const sys::alerts::Alert& alert,
                             const sys::alerts::Option&);
    void handleExporterExit();
    void handleScanManagerConnectState(
        gos::itf::scanmanager::ScanManagerConnectState state);
    void updateExportState(CaseExportState exportState);
    void updateExportStep(QString const& step, QString const& detail = "");
    std::string archiveFileName();

private:
    void updateLocations();
    CaseExportResult caseExporter(const QString& pluginName,
                                  const QString& caseId,
                                  const QString& path);

    bool exportCaseData(const QString& pluginName,
                        const drive::model::WorkflowCaseId& workflowId,
                        const std::filesystem::path& archivePath);
    bool exportCaseSeries(immer::vector<gos::itf::scanmanager::ScanId> series,
                          const std::filesystem::path& archivePath);
    bool exportScreenshots(
        immer::vector<drive::model::ScreenshotId> screenshotIds,
        const std::filesystem::path& archivePath);
    void exportSensorhubLogs(const std::string& caseId,
                             const std::filesystem::path& archivePath);


    std::shared_ptr<drive::plugin::registry::IPluginRegistry> m_pluginRegistry;
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> m_alertViewRegistry;
    std::shared_ptr<gos::itf::scanmanager::IScanManagerHandle> m_scanManager;
    std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertManager;
    std::unique_ptr<CasesPropertySource> m_casesPropertySource;

    std::shared_ptr<IDeviceIO> m_deviceIo;
    std::shared_ptr<gm::arch::IObservable<std::shared_ptr<
        gm::arch::ICollection<gos::itf::deviceio::LabeledLocation>>>>
        m_archiveLocations;
    drive::archiving::LocationsViewModel* m_exportLocations;
    CaseExportState m_exportState = WAITING;
    QString m_exportStep = "";
    QString m_exportStepDetail = "";
    bool m_scanManagerConnected = false;

    QFuture<CaseExportResult> m_exporterFuture;
    QFutureWatcher<CaseExportResult> m_exporterFutureWatcher;
};
