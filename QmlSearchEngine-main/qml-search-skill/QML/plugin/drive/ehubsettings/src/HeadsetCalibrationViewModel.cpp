#include "HeadsetCalibrationViewModel.h"

#ifndef Q_MOC_RUN
#include <sys/log.h>
#include <gos/itf/nav/TrackerRole.h>
#include <sys/envvars/EnvVarsFactory.h>
#endif

#include <sys/config/config.h>

#include <QObject>

namespace drive::viewmodel {

constexpr char CAL_FILE_EXTN[] = ".xlsx";

HeadsetCalibrationViewModel::HeadsetCalibrationViewModel(
    std::shared_ptr<ehubsettings::imageprovider::HeadsetFeedProvider> headsetFeedProvider,
    QObject* parent)
    : QObject(parent)
    , m_headsetType(ehubsettings::types::HeadsetFeedType::HeadsetA_Stereo)
    , m_showCalPopup(false)
    , m_calInProgress(false)
    , m_successfulCompletion(false)
    , m_closeWhenComplete(false)
    , m_numImgSaved(0)
    , m_node(glink::node::NodeFactory::createInstance())
    , m_sensorhub(gos::nav::SensorHubProxyFactory::createInstance(m_node))
    , m_headsetFeedProvider(headsetFeedProvider)
    , m_curHeadsetTypeStr(ehubsettings::types::to_string(m_headsetType))
    , m_reqdNumImages(0)
{
    auto& settings = sys::config::Config::instance()->settings;
    if (settings.headset.calPlateFileDir != m_calFileBaseDir)
    {
        settings.headset.calPlateFileDir = m_calFileBaseDir.string();
        sys::config::Settings::save(settings);
    }
    using namespace gos::itf::nav;
    status_to_string(OpticalCalibrationEvent::Status::Uninitialized);
    gm::util::qt::connect(m_sensorhub->opticalCalEventReceived, this,
                          &HeadsetCalibrationViewModel::onOpticalCalEventReceived);
    gm::util::qt::connect(m_sensorhub->exportFieldCalibrationEventReceived, this,
                          &HeadsetCalibrationViewModel::onExportEventReceived);

    m_sensorhub->connect();

    scanCalFilesDir();

    m_headsetFeedProvider->selectFeed(m_headsetType);
}

void HeadsetCalibrationViewModel::scanCalFilesDir()
{
    auto&& envVars = sys::envvars::EnvVarsFactory::createInstance();
    auto& settings = sys::config::Config::instance()->settings;
    auto calFileDir = envVars->dataStorageDir() / settings.headset.calPlateFileDir;
    if (std::filesystem::exists(calFileDir))
    {
        m_calFilesFutr = std::async(std::launch::async, [&] {
            SYS_LOG_INFO("calPlateFileDir is {}", calFileDir.string());

            std::ranges::for_each(
                std::filesystem::directory_iterator{calFileDir},
                [&](const std::filesystem::path& dir_entry) {
                    if (std::filesystem::is_regular_file(dir_entry) &&
                        dir_entry.extension().string() == CAL_FILE_EXTN)
                    {
                        std::lock_guard<std::mutex> lk(m_calFilesMutex);
                        m_calPlateStrs.append(QString::fromStdString(dir_entry.stem().string()));
                    }
                });
        });

        // Get on Ehubsettingsplugin object creation
        if (m_calFilesFutr.valid())
            m_calFilesFutr.get();
    }
    m_calPlateStrs.append(m_defaultCalPlateStr);

    SYS_LOG_INFO("m_calPlateStrs size is {}", m_calPlateStrs.size());
}

QList<QVariant> HeadsetCalibrationViewModel::calPlateStrs()
{
    return m_calPlateStrs;
}

void HeadsetCalibrationViewModel::setHeadsetType(ehubsettings::types::HeadsetFeedType type)
{
    if (m_headsetType != type)
    {
        m_headsetType = type;
        m_headsetFeedProvider->selectFeed(type);

        emit headsetTypeChanged();
    }
}

void HeadsetCalibrationViewModel::setCurHeadsetTypeStr(QString headsetTypeStr)
{
    if (m_curHeadsetTypeStr != headsetTypeStr)
    {
        m_curHeadsetTypeStr = headsetTypeStr;

        auto headsetType = ehubsettings::types::to_headsetFeedType(headsetTypeStr);
        setHeadsetType(headsetType);

        emit curHeadsetTypeStrChanged();
    }
}

void HeadsetCalibrationViewModel::extendCalibration()
{
    SYS_LOG_INFO("headset type is {} ", to_string(m_headsetType).toStdString());
    using namespace gos::itf::nav;
    auto trackerRole = static_cast<gos::itf::nav::TrackerRole>(static_cast<int>(m_headsetType) + 2);
    // gos::itf::nav::TrackerRole  has headsetA starting at 2;

    m_sensorhub->extendExtrinsicsCalibration(trackerRole);
}

void HeadsetCalibrationViewModel::startCalibration()
{
    m_showCalPopup = true;
    emit showCalPopupChanged();

    SYS_LOG_INFO("headset type is {} ", to_string(m_headsetType).toStdString());
    using namespace gos::itf::nav;
    auto trackerRole = static_cast<gos::itf::nav::TrackerRole>(static_cast<int>(m_headsetType) + 2);
    // gos::itf::nav::TrackerRole  has headsetA starting at 2;
    std::filesystem::path calFileDir =
        sys::config::Config::instance()->settings.headset.calPlateFileDir;

    auto&& envVars = sys::envvars::EnvVarsFactory::createInstance();
    std::filesystem::path calFilePath;
    if (!m_curCalPlate.isEmpty() && m_curCalPlate != m_defaultCalPlateStr)
    {
        calFilePath = envVars->dataStorageDir() /
                      sys::config::Config::instance()->settings.headset.calPlateFileDir /
                      m_curCalPlate.toStdString();
        calFilePath.replace_extension(CAL_FILE_EXTN);
    }

    m_sensorhub->startExtrinsicsCalibration(trackerRole, calFilePath);
}

QString HeadsetCalibrationViewModel::getCalState() const
{
    using Status = gos::itf::nav::OpticalCalibrationEvent::Status;
    switch (m_calStatus)
    {
    case Status::Uninitialized:
    case Status::BaselineCalNotFound:
    case Status::CalibratorNotFound:
    case Status::CalibratorSetupError:
    case Status::NoExtrinsicsDefinition:
    case Status::NoExtrinsicsDefinitionFound:
    case Status::TooManyExtrinsicsDefinitionCandidates:
    case Status::NoHeadsetAssignment: return "Can Not Start Calibration";
    case Status::Running: return "Analyzing Images";
    case Status::CollectingImages: return "Collecting Images";
    case Status::CalibrationError:
    case Status::InvalidIMUExtrinsics:
    case Status::UnifiedCalFileNotFound:
    case Status::ExtrinsicPoorCoverage:
    case Status::RmseTooHigh: return "Failed";
    case Status::NotEnoughNearFieldData:
    case Status::NotEnoughMidFieldData:
    case Status::NotEnoughFarFieldData: return "Not Enough Data";
    case Status::Complete: return "Complete";
    }
}

QString HeadsetCalibrationViewModel::getExportMessage() const
{
    switch (m_exportStatus)
    {
    case ExportStatus::NotStarted: return "Export Results";
    case ExportStatus::InProgress: return "Exporting...";
    case ExportStatus::Success: return "Export Successful";
    case ExportStatus::Failure: return "Export Failed\nTry Again";
    }
}

bool HeadsetCalibrationViewModel::shouldAllowExport() const
{
    return m_exportStatus == ExportStatus::NotStarted || m_exportStatus == ExportStatus::Failure;
}

bool HeadsetCalibrationViewModel::shouldExtendCalibration() const
{
    using Status = gos::itf::nav::OpticalCalibrationEvent::Status;
    return m_calStatus == Status::NotEnoughNearFieldData ||
           m_calStatus == Status::NotEnoughMidFieldData ||
           m_calStatus == Status::NotEnoughFarFieldData;
}

void HeadsetCalibrationViewModel::resetVars()
{
    m_exportStatus = ExportStatus::NotStarted;
    emit exportStatusChanged();
    m_showCalPopup = false;
    emit showCalPopupChanged();
    m_calInProgress = false;
    emit calInProgressChanged();
    m_successfulCompletion = false;
    emit successfulCompletionChanged();
    m_numImgSaved = 0;
    emit numImgSavedChanged();
    m_reqdNumImages = 0;
    emit reqdNumImagesChanged();
    m_closeWhenComplete = false;
}

void HeadsetCalibrationViewModel::calActionButton(bool forceClose)
{
    if (!m_calInProgress || forceClose)
    {
        resetVars();
    }
    else
    {
        m_closeWhenComplete = true;
        using namespace gos::itf::nav;
        status_to_string(OpticalCalibrationEvent::Status::CalibrationError);
    }

    cancelCalibration();
}

void HeadsetCalibrationViewModel::cancelCalibration()
{
    using namespace gos::itf::nav;
    // gos::itf::nav::TrackerRole  has headsetA starting at 2;
    auto trackerRole = static_cast<gos::itf::nav::TrackerRole>(static_cast<int>(m_headsetType) + 2);
    m_sensorhub->stopExtrinsicsCalibration(trackerRole);
}

void HeadsetCalibrationViewModel::exportResults()
{
    m_exportStatus = ExportStatus::InProgress;
    emit exportStatusChanged();
    m_sensorhub->exportFieldCalibrations();
    emit exportStatusChanged();
}

QVariantList HeadsetCalibrationViewModel::getVideoFeedsVariantList(
    ehubsettings::types::HeadsetFeedType feedType)
{
    return m_headsetFeedProvider->getVideoFeedsVariantList(feedType);
}

void HeadsetCalibrationViewModel::onOpticalCalEventReceived(
    std::shared_ptr<const gos::itf::nav::OpticalCalibrationEvent> event)
{
    using namespace gos::itf::nav;
    SYS_LOG_INFO("Event Received - {}", event->numImagesTaken);
    status_to_string(event->status);

    bool inProgress = event->status == OpticalCalibrationEvent::Status::CollectingImages ||
                      event->status == OpticalCalibrationEvent::Status::Running;
    if (m_calInProgress != inProgress)
    {
        m_calInProgress = inProgress;
        if (m_closeWhenComplete && !m_calInProgress)
        {
            resetVars();
            return;
        }
        emit calInProgressChanged();
    }

    if (m_reqdNumImages != event->numImagesRequired)
    {
        m_reqdNumImages = event->numImagesRequired;
        emit reqdNumImagesChanged();
    }
    if (m_numImgSaved != event->numImagesRequired)
    {
        m_numImgSaved = event->numImagesTaken;
        emit numImgSavedChanged();
    }

    bool successfulCompletion = event->status == OpticalCalibrationEvent::Status::Complete;
    if (m_successfulCompletion != successfulCompletion)
    {
        m_successfulCompletion = true;
        m_exportStatus = ExportStatus::NotStarted;
        emit successfulCompletionChanged();
        emit exportStatusChanged();
    }
}

void HeadsetCalibrationViewModel::onExportEventReceived(bool success)
{
    m_exportStatus = success ? ExportStatus::Success : ExportStatus::Failure;
    emit exportStatusChanged();
}

}  // namespace drive::viewmodel
