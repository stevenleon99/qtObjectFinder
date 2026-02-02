/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "ImageExportViewModel.h"
#include "DriveAlerts.h"

#include <sys/alerts/AlertManagerFactory.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <gm/util/typeconv.h>
#include <gm/util/qt/typeconv/qstring_conv.h>
#include <gm/util/qt/typeconv/uuid_conv.h>
#include <sys/log.h>

#include <QDebug>


namespace gm::util::typeconv {

QString Conversion<gos::itf::scanmanager::ScanTypeFormat, QString>::operator()(
    const gos::itf::scanmanager::ScanTypeFormat value) const
{
    switch (value)
    {
    case gos::itf::scanmanager::ScanTypeFormat::DICOM: return "DICOM";
    case gos::itf::scanmanager::ScanTypeFormat::NIFTI: return "NIFTI";
    default: return "Invalid Scan Type";
    }
}

gos::itf::scanmanager::ScanTypeFormat
Conversion<QString, gos::itf::scanmanager::ScanTypeFormat>::operator()(
    const QString& value) const
{
    if (value == "NIFTI")
    {
        return gos::itf::scanmanager::ScanTypeFormat::NIFTI;
    }

    return gos::itf::scanmanager::ScanTypeFormat::DICOM;
}

}  // namespace gm::util::typeconv


namespace drive::viewmodel {

using namespace drive::alerts;
using gm::util::typeconv::convert;

constexpr auto NIFTI_EXPORT_WARNING =
    "NIFTI files exclude patient and some image data.";
constexpr auto IMAGE_EXPORT_SUCCESS_PROGRESS = 1;

ImageExportViewModel::ImageExportViewModel(
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
    std::shared_ptr<gos::itf::scanmanager::IScanManagerHandle> scanManager,
    std::shared_ptr<gos::itf::deviceio::IDeviceIO> deviceIo,
    QObject* parent)
    : QObject(parent)
    , m_alertViewRegistry(alertViewRegistry)
    , m_scanManager(scanManager)
    , m_alertManager(sys::alerts::AlertManagerFactory::createInstance())
    , m_deviceIo{deviceIo}
    , m_archiveLocations{deviceIo->exportLocations()}
    , m_exportLocations(new drive::archiving::LocationsViewModel(this))
    , m_imageTypeList(
          {convert<QString>(gos::itf::scanmanager::ScanTypeFormat::DICOM),
           convert<QString>(gos::itf::scanmanager::ScanTypeFormat::NIFTI)})
    , m_selectedImageType(
          convert<QString>(gos::itf::scanmanager::ScanTypeFormat::DICOM))
{
    connect(this, &ImageExportViewModel::archiveLocationsChanged, this,
            &ImageExportViewModel::updateLocations);

    gm::util::qt::connect(m_alertManager->clearRequested, this,
                          &ImageExportViewModel::handleAlertResponse);
    gm::util::qt::connect(m_scanManager->scanManagerConnectStateChanged, this,
                          &ImageExportViewModel::handleScanManagerConnectState);

    m_archiveLocations->changed.connect(
        [this](auto const&) { Q_EMIT archiveLocationsChanged(); });
    updateLocations();

    m_alertViewRegistry->addAlertView(m_alertManager);
}

void ImageExportViewModel::selectImageType(const QString& typeStr)
{
    if (m_selectedImageType != typeStr)
    {
        m_selectedImageType = typeStr;
        Q_EMIT selectedImageTypeChanged();

        QString warning;
        if (convert<gos::itf::scanmanager::ScanTypeFormat>(typeStr) ==
            gos::itf::scanmanager::ScanTypeFormat::NIFTI)
        {
            warning = NIFTI_EXPORT_WARNING;
        }
        setExportWarning(warning);
    }
}

void ImageExportViewModel::selectLocation(const QString& locationStr)
{
    if (m_selectedLocation != locationStr)
    {
        m_selectedLocation = locationStr;
        SYS_LOG_DEBUG("Selecting new location: {}", locationStr.toStdString());
        Q_EMIT selectedLocationChanged();
    }
}

void ImageExportViewModel::exportImage(const QString& scanIdStr)
{
    SYS_LOG_INFO("Exporting image: {}", scanIdStr.toStdString());

    if (m_scanManagerConnected && !scanIdStr.isEmpty() &&
        !m_selectedImageType.isEmpty())
    {
        setExporting(true);
        auto scanId = gos::itf::scanmanager::ScanId();
        scanId.id = convert<boost::uuids::uuid>(scanIdStr);

        auto scanType =
            convert<gos::itf::scanmanager::ScanTypeFormat>(m_selectedImageType);

        m_scanManager->exportScan(
            scanId, m_selectedLocation.toStdString(), scanType,
            [=, this](gos::itf::scanmanager::ScanError err) {
                SYS_LOG_WARN("Image export failed, error: {}",
                             static_cast<size_t>(err));
                m_alertManager->createAlert(
                    alertsMap.at(DriveAlerts::ImageExportFailed));
                setExporting(false);
            },
            [=, this](gos::itf::scanmanager::Progress progress) {
                QMetaObject::invokeMethod(this,
                                          [=, this] { setProgress(progress); });
            });
    }
    else if (!m_scanManagerConnected)
    {
        SYS_LOG_WARN("Scanmanager not connected");
        m_alertManager->createAlert(
            alertsMap.at(DriveAlerts::ImageExportFailed));
    }
    else
    {
        SYS_LOG_WARN("Skip image export, invalid scan id or invalid scan type");
        m_alertManager->createAlert(
            alertsMap.at(DriveAlerts::ImageExportFailed));
    }
}

void ImageExportViewModel::handleAlertResponse(const sys::alerts::Alert& alert,
                                               const sys::alerts::Option&)
{
    m_alertManager->clearAlert(alert);
}

void ImageExportViewModel::handleScanManagerConnectState(
    gos::itf::scanmanager::ScanManagerConnectState state)
{
    m_scanManagerConnected =
        (state == gos::itf::scanmanager::ScanManagerConnectState::Connected);
}

void ImageExportViewModel::updateLocations()
{
    auto locations =
        m_archiveLocations->get()
            ->eval<std::vector<drive::archiving::LabeledLocation>>();

    if (!m_selectedLocation.isEmpty())
    {
        bool found = std::find_if(locations.begin(), locations.end(),
                                  [&](const auto& location) {
                                      return m_selectedLocation.toStdString() ==
                                             location.location;
                                  }) != locations.end();

        if (!found)
            selectLocation(QString());
    }

    if (m_selectedLocation.isEmpty() && !locations.empty())
        selectLocation(
            QString().fromStdString(locations.front().location.string()));

    setLocationsCount(static_cast<int>(locations.size()));
    m_exportLocations->replaceLocations(locations);
}

void ImageExportViewModel::setLocationsCount(int count)
{
    if (m_locationsCount != count)
    {
        m_locationsCount = count;
        Q_EMIT locationsCountChanged();
    }
}

void ImageExportViewModel::setProgress(float progress)
{
    if (m_progress != progress)
    {
        m_progress = progress;
        emit progressChanged();

        if (progress == IMAGE_EXPORT_SUCCESS_PROGRESS)
        {
            setExporting(false);
            m_alertManager->createAlert(
                alertsMap.at(DriveAlerts::ImageExported));
        }
    }
}

void ImageExportViewModel::setExporting(bool isExporting)
{
    if (m_exporting != isExporting)
    {
        m_exporting = isExporting;
        Q_EMIT exportingChanged();
    }
}

void ImageExportViewModel::setExportWarning(QString warning)
{
    if (m_exportWarning != warning)
    {
        m_exportWarning = warning;
        Q_EMIT exportWarningChanged();
    }
}

}  // namespace drive::viewmodel
