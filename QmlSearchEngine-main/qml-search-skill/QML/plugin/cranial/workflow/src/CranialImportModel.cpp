#include "CranialImportModel.h"

#include <procd/cranial/actions/DriveActions.h>
#include <procd/cranial/alerts/VolumeMissingSlicesAlertFactory.h>
#include <procd/cranial/managers/AlertManager.h>
#include <procd/cranial/managers/IocManager.h>
#include <procd/cranial/managers/ToolboxManager.h>
#include <procd/cranial/propertysources/AppDataPropertySource.h>
#include <procd/cranial/atoms/CaseDataReader.h>
#include <procd/cranial/tools/log.h>

#include <imfusionrendering/ImFusionClient.h>
#include <imfusionrendering/ImFusionTools.h>

#include <ImFusion/Base/HistogramDataComponent.h>
#include <ImFusion/Dicom/DicomLoader.h>

#include <gm/geom/qt/typeconv.h>
// #include <gm/util/typeconv.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <gm/util/continuation.h>
#include <boost/uuid/uuid_io.hpp>
#include <QDebug>


CranialImportModel::CranialImportModel(
    drive::scanimport::ImportViewModelSource* importViewModelSource, QObject* parent)
    : QObject(parent)
    , m_importViewModelSource(importViewModelSource)
{
    gm::util::qt::connect(m_importViewModelSource->scansImportedSignal, this,
                          &CranialImportModel::onScanImported);
    gm::util::qt::connect(scanImportSuccessSignal, this, &CranialImportModel::onScanImportSuccess,
                          Qt::ConnectionType::QueuedConnection);

    connect(&cranial::propertysources::AppDataPropertySource::instance(),
            &cranial::propertysources::AppDataPropertySource::driveCaseDataChanged, this,
            [this](drive::model::DriveCaseData driveCaseData) {
                G_EMIT driveCaseDataUpdateSignal(driveCaseData);
            });
}

void CranialImportModel::onScanImported(const FileInfo& fileInfo,
                                        const std::variant<ScanId, ScanError>& importStatus)
{
    if (!std::holds_alternative<ScanId>(importStatus))
    {
        return;
    }
    auto scanId = std::get<ScanId>(importStatus);
    if (auto iocContainer = cranial::managers::getContainer())
    {
        if (auto scanManager = iocContainer->resolve<gos::itf::scanmanager::IScanManager>())
        {
            if (std::holds_alternative<DicomScan>(fileInfo.scan))
            {
                auto dicomScan = std::get<DicomScan>(fileInfo.scan);
                SYS_LOG_INFO("Importing {} volume from drive with series number {}",
                             dicomScan.modality, dicomScan.seriesNumber);
            }
            else
            {
                SYS_LOG_ERROR("Importing volume from drive that is not a DICOM");
            }

            scanManager->resolve(
                scanId,
                gm::util::trackedContinuation(
                    shared_from_this(),
                    [this, scanId](std::optional<gos::itf::scanmanager::ManagedScan> optScan) {
                        auto volumeWithId = std::make_pair(scanId, optScan.value());
                        G_EMIT scanImportSuccessSignal(volumeWithId);
                    }));
        }
    }
}

static bool verifySliceCount(const DicomScan& dicomScan)
{
    /**
     * TODO: For E3D running v.1.6 or later, use private tag to obtain the expected number of
     * slices instead of looking them up in the below map.
     */
    static const std::unordered_map<int, int> widthToHeight = {
        {512, 512}, {640, 640}, {864, 480}, {1024, 568}};
    if (auto iter = widthToHeight.find(dicomScan.imageWidth); iter != widthToHeight.end())
    {
        return static_cast<int>(dicomScan.imageCount) == iter->second;
    }
    return false;
}

void CranialImportModel::onScanImportSuccess(const std::pair<ScanId, ManagedScan>& volumeWithId)
{
    SYS_LOG_INFO("Volume imported from drive. Importing to the case");
    cranial::model::Volume volume;
    volume.id = gm::util::typeconv::convert<QUuid>(volumeWithId.first.id);
    if (cranial::atoms::isVolumeInCase(volume.id) ||
        !std::holds_alternative<DicomScan>(volumeWithId.second.info.scan))
    {
        SYS_LOG_INFO("Trying to import a volume to the case that is already loaded");
        return;
    }

    auto dicomScan = std::get<DicomScan>(volumeWithId.second.info.scan);  // All are DICOMS

    // In E3D auto-registration workflows, compare received slice count with expected slices, and if
    // they don't match, do not load the scan.

    auto sliceCountVerified = verifySliceCount(dicomScan);
    if (dicomScan.e3dPatientReference_x_volume.has_value() && !sliceCountVerified)
    {
        if (auto iocContainer = cranial::managers::getContainer();
            auto alertManager = iocContainer->resolve<cranial::managers::AlertManager>())
        {
            auto missingSlicesAlert = cranial::alerts::VolumeMissingSlicesFactory::createInstance();
            alertManager->registerAlert(missingSlicesAlert);
            return;
        }
    }

    volume.description =
        QString::fromStdString(dicomScan.patientName + " " + dicomScan.description);
    volume.modality = QString::fromStdString(dicomScan.modality);
    volume.equipment = QString::fromStdString(dicomScan.equipment);
    auto timeSinceEpoch =
        std::chrono::time_point_cast<std::chrono::milliseconds>(dicomScan.seriesDateTime)
            .time_since_epoch()
            .count();
    volume.creationDate = QDateTime::fromMSecsSinceEpoch(timeSinceEpoch);
    volume.lpsCenteredUid = QUuid::createUuid();
    volume.rasCenteredUid = QUuid::createUuid();

    // **** E3D Data
    if (dicomScan.e3dPatientReference_x_volume.has_value())
    {
        std::optional<gm::geom::Transform3d> e3dMatrix =
            dicomScan.e3dPatientReference_x_volume.value();

        cranial::model::TransformE3D transformE3D;
        transformE3D.patientReference_x_lpsCentered =
            gm::util::typeconv::convert<QMatrix4x4>(e3dMatrix.value());
        QString patRef = QString::fromStdString(dicomScan.e3dPatReference);

        auto drbUuid = cranial::managers::ToolboxManager::getUuid(
            cranial::types::TrackedToolTypes::CranialDrb);
        auto leksellUuid = cranial::managers::ToolboxManager::getUuid(
            cranial::types::TrackedToolTypes::LeksellFra);
        auto crwUuid =
            cranial::managers::ToolboxManager::getUuid(cranial::types::TrackedToolTypes::CrwFra);

        auto patRefUuid = QUuid(patRef);

        if (patRefUuid == drbUuid)
        {
            transformE3D.patientReference = cranial::types::TrackedToolTypes::CranialDrb;
            volume.transformE3D = transformE3D;
        }
        else if (patRefUuid == leksellUuid)
        {
            transformE3D.patientReference = cranial::types::TrackedToolTypes::LeksellFra;
            volume.transformE3D = transformE3D;
        }
        else if (patRefUuid == crwUuid)
        {
            transformE3D.patientReference = cranial::types::TrackedToolTypes::CrwFra;
            volume.transformE3D = transformE3D;
        }
        else
        {
            SYS_LOG_WARN("Worng E3D patient reference. Deleting E3D registration matrix");
            volume.transformE3D = std::nullopt;
        }
    }
    else
    {
        volume.transformE3D = std::nullopt;
    }

    // ****
    QString uuid = volume.id.toString(QUuid::WithoutBraces);

    bool isLoaded = ImFusionClient::instance().isDicomLoaded(uuid);
    QVector3D translationDicom;
    if (!isLoaded)
    {
        SYS_LOG_INFO("Volume {} loading in memory", volume.id);
        isLoaded = ImFusionClient::instance().addDicom(
            uuid, gm::util::typeconv::convert<QString>(volumeWithId.second.imageDirectory),
            translationDicom);
    }
    else
    {
        SYS_LOG_DEBUG("Volume {} already loaded in memory", volume.id);
    }

    if (!isLoaded)
    {
        SYS_LOG_WARN("Volume {} can not be loaded in Memory", volume.id);
        return;
    }

    ImFusion::SharedImageSet* theScan = ImFusionClient::instance().scan(uuid);

    if (!theScan)
    {
        SYS_LOG_WARN("Can not retrieve volume {} from memory", uuid);
        return;
    }

    ImFusion::SharedImage* si = theScan->get(0);
    if (si)
    {
        volume.dimensions[0] = si->width();
        volume.dimensions[1] = si->height();
        volume.dimensions[2] = si->slices();

        auto matToWorld = theScan->matrixToWorld();

        volume.iDir[0] = static_cast<float>(matToWorld(0, 0));
        volume.iDir[1] = static_cast<float>(matToWorld(1, 0));
        volume.iDir[2] = static_cast<float>(matToWorld(2, 0));

        volume.jDir[0] = static_cast<float>(matToWorld(0, 1));
        volume.jDir[1] = static_cast<float>(matToWorld(1, 1));
        volume.jDir[2] = static_cast<float>(matToWorld(2, 1));

        volume.kDir[0] = static_cast<float>(matToWorld(0, 2));
        volume.kDir[1] = static_cast<float>(matToWorld(1, 2));
        volume.kDir[2] = static_cast<float>(matToWorld(2, 2));

        volume.translationDicom = translationDicom;

        volume.ijkSpacingMm[0] = si->spacing().x();
        volume.ijkSpacingMm[1] = si->spacing().y();
        volume.ijkSpacingMm[2] = si->spacing().z();

        ImFusion::HistogramDataComponent hdc(theScan);
        ImFusion::vec2 winLev = hdc.computeAutoWindowing(0.01, 0.01, 0);
        QVector2D winMinMax(static_cast<float>(winLev[1] - winLev[0] / 2),
                            static_cast<float>(winLev[1] + winLev[0] / 2));
        volume.windowMinMax_2D = winMinMax;
        volume.windowMinMax_3D = winMinMax;

        if (si->slices() <= 2)
        {
            SYS_LOG_WARN("Discarting volume {} from case because number of slices is {}", volume.id,
                         si->slices());
            return;
        }


        immer::map<QString, cranial::model::VolumeCoordinateSystem> newCoordinateSystems;
        cranial::model::GenericCoordinateSystem dicomSpace{
            QUuid::createUuid(), ImFusionTools::convertMatrix(theScan->matrix())};
        newCoordinateSystems = newCoordinateSystems.set(QString("PATIENT_SPACE"), dicomSpace);
        volume.coordinateSystems = newCoordinateSystems;

        SYS_LOG_DEBUG("Adding volume {} to case", volume.id);
        cranial::actions::addVolumeToCase(volume);
    }
}
