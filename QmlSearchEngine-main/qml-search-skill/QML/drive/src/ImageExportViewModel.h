/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/archiving/LocationsViewModel.h>
#include <gm/util/typeconv/conversion.h>

#ifndef Q_MOC_RUN
#include <drive/model/common.h>
#include <gos/itf/scanmanager/IScanManager.h>
#include <gos/itf/scanmanager/IScanManagerHandle.h>
#include <gos/itf/deviceio/IDeviceIO.h>
#include <sys/alerts/itf/IAlertAggregator.h>
#include <sys/alerts/itf/IAlertManager.h>
#endif

#include <QObject>


namespace gm::util::typeconv {

template <>
struct Conversion<gos::itf::scanmanager::ScanTypeFormat, QString>
{
    QString operator()(gos::itf::scanmanager::ScanTypeFormat value) const;
};

template <>
struct Conversion<QString, gos::itf::scanmanager::ScanTypeFormat>
{
    gos::itf::scanmanager::ScanTypeFormat operator()(
        const QString& value) const;
};

}  // namespace gm::util::typeconv


namespace drive::viewmodel {

class ImageExportViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QAbstractListModel* locationList READ locationList CONSTANT)
    Q_PROPERTY(QStringList imageTypeList READ imageTypeList CONSTANT)
    Q_PROPERTY(QString selectedImageType READ selectedImageType WRITE
                   selectImageType NOTIFY selectedImageTypeChanged)
    Q_PROPERTY(QString selectedLocation READ selectedLocation WRITE
                   selectLocation NOTIFY selectedLocationChanged)
    Q_PROPERTY(
        int locationsCount READ locationsCount NOTIFY locationsCountChanged)
    Q_PROPERTY(
        QString exportWarning READ exportWarning NOTIFY exportWarningChanged)
    Q_PROPERTY(bool exporting READ exporting NOTIFY exportingChanged)
    Q_PROPERTY(float progress READ progress NOTIFY progressChanged)


public:
    explicit ImageExportViewModel(
        std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
        std::shared_ptr<gos::itf::scanmanager::IScanManagerHandle> scanManager,
        std::shared_ptr<gos::itf::deviceio::IDeviceIO> deviceIo,
        QObject* parent = nullptr);

    QAbstractListModel* locationList() const { return m_exportLocations; }

    QStringList imageTypeList() const { return m_imageTypeList; };

    QString selectedImageType() const { return m_selectedImageType; }

    QString selectedLocation() const { return m_selectedLocation; }

    int locationsCount() const { return m_locationsCount; }

    QString exportWarning() const { return m_exportWarning; }

    bool exporting() const { return m_exporting; }
    float progress() const { return m_progress; }

    void selectImageType(const QString& typeStr);

    void selectLocation(const QString& locationStr);

    Q_INVOKABLE void exportImage(const QString& scanId);

signals:
    void archiveLocationsChanged();
    void selectedImageTypeChanged();
    void selectedLocationChanged();
    void locationsCountChanged();
    void exportWarningChanged();
    void exportingChanged();
    void progressChanged();

private slots:
    void handleAlertResponse(const sys::alerts::Alert& alert,
                             const sys::alerts::Option&);
    void handleScanManagerConnectState(
        gos::itf::scanmanager::ScanManagerConnectState state);

private:
    void updateLocations();
    void setLocationsCount(int count);
    void setProgress(float progress);
    void setExporting(bool isExporting);
    void setExportWarning(QString warning);

    std::shared_ptr<sys::alerts::itf::IAlertAggregator> m_alertViewRegistry;
    std::shared_ptr<gos::itf::scanmanager::IScanManagerHandle> m_scanManager;
    std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertManager;
    std::shared_ptr<gos::itf::deviceio::IDeviceIO> m_deviceIo;
    std::shared_ptr<gm::arch::IObservable<std::shared_ptr<
        gm::arch::ICollection<gos::itf::deviceio::LabeledLocation>>>>
        m_archiveLocations;

    drive::archiving::LocationsViewModel* m_exportLocations;

    QStringList m_imageTypeList;
    QString m_selectedLocation;
    QString m_selectedImageType;
    QString m_exportWarning;
    bool m_scanManagerConnected{false};
    bool m_exporting{false};
    int m_locationsCount{0};
    float m_progress{0.0};
};

}  // namespace drive::viewmodel
