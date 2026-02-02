/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#define GM_GEOM_DEFINE_AFFINES

#include "CranialImportModel.h"

#include <drive/itf/plugin/IPluginGui.h>
#include <drive/itf/plugin/IPluginShell.h>
#include <drive/itf/plugin/IWorkFlowPluginGui.h>
#include <drive/itf/plugin/IWorkflowPluginDataModel.h>
#include <drive/scanimport/ImportViewModelSource.h>

#ifndef Q_MOC_RUN
#include <procd/cranial/model/CaseModel.h>
#include <procd/cranial/atoms/AtomOwner.h>

#include <procd/cranial/tasks/VolumeRegistrationTaskFactory.h>

#include <procd/cranial/actions/MergeActions.h>
#include <procd/cranial/actions/PlanActions.h>
#include <procd/cranial/actions/PostOpActions.h>
#include <procd/cranial/actions/RenderActions.h>
#include <procd/cranial/actions/CaseActions.h>
#include <procd/cranial/actions/DriveActions.h>
#include <procd/cranial/actions/TrackedToolActions.h>

#include <procd/cranial/components/ImageViewport.h>

#include <procd/cranial/proxy/GnsSensorhubProxy.h>

#include <procd/cranial/services/ActiveToolsSensorhubService.h>
#include <procd/cranial/services/FluoroCTViewportService.h>
#include <procd/cranial/services/IgeeVerificationService.h>
#include <procd/cranial/services/ImFusionACPCService.h>
#include <procd/cranial/services/ImFusionIctFiducialsService.h>
#include <procd/cranial/services/ImFusionTrackedToolService.h>
#include <procd/cranial/services/ImFusionTrajectoryLandmarkService.h>
#include <procd/cranial/services/ImFusionTrajectoryService.h>
#include <procd/cranial/services/ImFusionVolumeService.h>
#include <procd/cranial/services/MotionService.h>
#include <procd/cranial/services/MotionSessionAlertService.h>
#include <procd/cranial/services/PatientRegistrationFluoroCtService.h>
#include <procd/cranial/services/PatientRegistrationIctNotTransferredService.h>
#include <procd/cranial/services/PatientRegistrationIctService.h>
#include <procd/cranial/services/PersistenceService.h>
#include <procd/cranial/services/ReachabilityService.h>
#include <procd/cranial/services/StraysSensorhubService.h>
#include <procd/cranial/services/SurveillanceMarkerSensorhubService.h>
#include <procd/cranial/services/TrackedToolsSensorhubService.h>
#include <procd/cranial/services/TaskService.h>
#include <procd/cranial/services/ToolVerificationService.h>
#include <procd/cranial/services/PatientRegistrationIctService.h>
#include <procd/cranial/services/PatientRegistrationIctNotTransferredService.h>
#include <procd/cranial/services/PatientRegistrationE3DService.h>
#include <procd/cranial/services/PatientRegistrationFiducialService.h>
#include <procd/cranial/services/PatientRegistrationSurfaceService.h>
#include <procd/cranial/services/ReachabilityService.h>
#include <procd/cranial/services/TransformACPCService.h>
#include <procd/cranial/services/TransformSensorhubService.h>
#include <procd/cranial/services/TransformTrajectoryService.h>
#include <procd/cranial/services/TransformVolumeMergeService.h>
#include <procd/cranial/services/TransformVolumeService.h>
#include <procd/cranial/services/ViewPositionToolFollowingService.h>
#include <procd/cranial/services/imfusion/Center3DService.h>
#include <procd/cranial/services/FluoroCTCaptureService.h>
#include <procd/cranial/services/imfusion/FiducialWorkflowService.h>
#include <procd/cranial/services/imfusion/SurfaceInitService.h>
#include <procd/cranial/services/imfusion/SurfaceMapService.h>
#include <procd/cranial/services/MotionLockingService.h>
#include <procd/cranial/services/imfusion/LabelTransformsService.h>

#include <imfusionrendering/ImFusionClient.h>


#include <service/glink/node/INode.h>
#include <service/glink/node/NodeFactory.h>
#include <gos/itf/nav.h>
#include <gos/motion/armmotion/ArmMotionSessionManagerProxyFactory.h>
#include <gos/motion/armmotion/ArmMotionSessionManagerSourceFactory.h>
#include <gos/motion/armmotion/ArmReachabilityProxyFactory.h>
#include <gos/motion/armmotion/ArmReachabilitySourceFactory.h>
#include <gos/nav/SensorHubProxyFactory.h>
#include <sys/alerts/itf/IAlertAggregator.h>
#include <sys/alerts/itf/IAlertManager.h>
#include <sys/alerts/Alert.h>

#include <stdexcept>
#include <immer/flex_vector.hpp>

#include <lager/cursor.hpp>
#include <lager/lenses.hpp>
#include <lager/extra/qt.hpp>
#include <lager/state.hpp>

#include <memory>

#include <QtPlugin>
#include <QQmlContext>
#include <QObject>
#include <QMatrix4x4>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QFontDatabase>
#endif


using namespace drive::itf;
using namespace drive::model;


namespace gos::itf::uaib {
struct IUaibControllerService;
}  // namespace gos::itf::uaib


class CranialPluginGui final : public QObject, public drive::itf::plugin::IWorkFlowPluginGui
{
    Q_OBJECT
    Q_INTERFACES(drive::itf::plugin::IWorkFlowPluginGui)
    Q_INTERFACES(drive::itf::plugin::IPluginGui)

public:
    explicit CranialPluginGui(QObject* parent = nullptr);
    ~CranialPluginGui() override;

    Q_INVOKABLE void requestQuit();

    std::string getQmlPath() const override;
    std::string getHeaderQmlPath() const override;

    void runCase(WorkflowCaseId id,
                 DriveCaseData data,
                 std::vector<std::string> featureSet,
                 IWorkFlowPluginGui::ReachableScans reachableScans,
                 std::shared_ptr<gos::itf::scanmanager::IScanManager> scanManager,
                 std::shared_ptr<plugin::IPluginShell> shell,
                 drive::model::SurgeonIdentifier surgeonId,
                 std::optional<std::string> surgeonName) override;

    void runHeader(std::shared_ptr<plugin::IPluginShell> shell,
                   drive::model::SurgeonIdentifier surgeonId) override;

    void cleanupPluginQml() override;

    void quitPlugin() override;

    /**
     * Returns a viewer for alerts created by this plugin
     */
    [[nodiscard]] std::shared_ptr<gos::itf::alerts::IAlertView> getAlertView() const;

private:
    void setupContext(QPointer<QQmlContext> context);
    void createServices();
    void createBuilder(drive::model::SurgeonIdentifier surgeonId);
    void createProviders();
    void createContextProperties();
    void showLoadingAlert();
    void hideLoadingAlert();
    void showCaseDriveDifferentAlert();

private slots:
    void onDriveCaseDataUpdate(const DriveCaseData& driveCaseData);

private:
    DriveCaseData m_driveCaseData;
    std::shared_ptr<gos::itf::scanmanager::IScanManager> m_scanManager;
    std::shared_ptr<gm::arch::ICollection<ScanId>> m_reachableScanIds;

    QPointer<QQmlContext> m_pluginContext;

    std::shared_ptr<glink::node::INode> m_gLinkNode;
    std::shared_ptr<gos::itf::motion::IGpsArmMotionSessionManager> m_armMotion;
    std::shared_ptr<gos::itf::motion::IArmReachability> m_armReachability;
    std::shared_ptr<gos::itf::nav::ISensorHub> m_sh;
    std::shared_ptr<gos::itf::uaib::IUaibControllerService> m_uaibController;

    std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertManager;

    cranial::tasks::VolumeRegistrationTaskFactory m_volumeRegistrationTaskFactory;

    std::shared_ptr<cranial::proxy::GnsSensorhubProxy> m_gnsSensorhubProxy;

    std::shared_ptr<cranial::services::ImFusionVolumeService> m_imfusionVolumeService;
    std::shared_ptr<cranial::services::TransformVolumeService> m_transformVolumeService;
    std::shared_ptr<cranial::services::TransformVolumeMergeService> m_transformVolumeMergeService;
    std::shared_ptr<cranial::services::ImFusionTrajectoryService> m_imFusionTrajService;
    std::shared_ptr<cranial::services::ImFusionTrackedToolService> m_imFusionTrackedToolService;
    std::shared_ptr<cranial::services::ImFusionTrajectoryLandmarkService>
        m_imFusionTrajectoryLandmarkService;
    std::shared_ptr<cranial::services::TransformTrajectoryService> m_transformTrajectoryService;
    std::shared_ptr<cranial::services::PatientRegistrationIctService>
        m_patientRegistrationIctService;
    std::shared_ptr<cranial::services::PatientRegistrationIctNotTransferredService>
        m_patientRegistrationIctNotTrasnferredService;
    std::shared_ptr<cranial::services::PatientRegistrationE3DService>
        m_patientRegistrationE3DService;
    std::shared_ptr<cranial::services::PatientRegistrationFluoroCtService>
        m_patientRegistrationFluoroCtService;
    std::shared_ptr<cranial::services::PatientRegistrationFiducialService>
        m_patientRegistrationFiducialService;
    std::shared_ptr<cranial::services::PatientRegistrationSurfaceService>
        m_patientRegistrationSurfaceService;
    std::shared_ptr<cranial::services::PersistenceService> m_persistenceService;
    std::shared_ptr<cranial::services::ToolVerificationService> m_toolVerificationService;
    std::shared_ptr<cranial::services::ActiveToolsSensorhubService> m_activeToolsSensorhubService;
    std::shared_ptr<cranial::services::StraysSensorhubService> m_straysSensorhubService;
    std::shared_ptr<cranial::services::SurveillanceMarkerSensorhubService>
        m_surveillanceMarkerSensorhubService;
    std::shared_ptr<cranial::services::TransformSensorhubService> m_transformSensorhubService;
    std::shared_ptr<cranial::services::TrackedToolsSensorhubService> m_trackedToolsSensorhubService;
    std::shared_ptr<cranial::services::TransformACPCService> m_transformACPCService;
    std::shared_ptr<cranial::services::ImFusionACPCService> m_imFusionACPCService;
    std::shared_ptr<cranial::services::MotionService> m_motionService;
    std::shared_ptr<cranial::services::ReachabilityService> m_reachabilityService;
    std::shared_ptr<cranial::services::ImFusionIctFiducialsService> m_imFusionIctFiducialsService;
    std::shared_ptr<cranial::services::imfusion::FiducialWorkflowService> m_fiducialWorkflowService;
    std::shared_ptr<cranial::services::imfusion::SurfaceInitService> m_surfaceInitService;
    std::shared_ptr<cranial::services::imfusion::SurfaceMapService> m_surfaceMapService;
    std::shared_ptr<cranial::services::FluoroCTViewportService> m_fluoroCTViewportService;
    std::shared_ptr<cranial::services::ViewPositionToolFollowingService>
        m_viewPositionToolFollowingService;
    std::shared_ptr<cranial::services::IgeeVerificationService> m_igeeVerificationService;
    std::shared_ptr<cranial::services::MotionSessionAlertService> m_motionSessionAlertService;
    std::shared_ptr<cranial::services::imfusion::Center3DService> m_center3dService;
    std::shared_ptr<cranial::services::FluoroCTCaptureService> m_fluoroCTCaptureService;
    std::shared_ptr<cranial::services::MotionLockingService> m_motionLockingService;
    std::shared_ptr<cranial::services::LabelTransformsService> m_labelTransformsService;

    drive::scanimport::ImportViewModelSource* m_importViewModelSource;
    std::shared_ptr<CranialImportModel> m_cranialImportModel;
    std::vector<std::shared_ptr<plugin::IPluginShell>> m_pluginShellList;

    // needs to be initialized last to collect all alert managers
    const std::shared_ptr<sys::alerts::itf::IAlertAggregator> m_alertView;

    std::optional<sys::alerts::Alert> m_loadingAlertOpt;

    /**
     * Compare the drive data with the application drive data
     * Compare the date of birth and medical record number to check that are the
     * same patient. If there are the same patient, compare the series to be
     * sure that both are using the same.
     * @param dataFromDrive data that comes from drive
     * @param dataFromApp data that comes from the application data model
     * @return the data to use or error if is nullopt
     */
    std::optional<DriveCaseData> compareDriveAppData(DriveCaseData dataFromDrive,
                                                     DriveCaseData dataFromApp);

    /**
     * Compare the drive data scans with scans in the data model
     * The comparation is in both directions. Scans that are in the drive data
     * but not in the data model are being deleted. Error if there are scans in
     * the data model that there are not in drive.
     * @return The correct drive data or error (nullopt)
     */
    std::optional<DriveCaseData> compareDriveCaseData(DriveCaseData dataFromDrive);
};
