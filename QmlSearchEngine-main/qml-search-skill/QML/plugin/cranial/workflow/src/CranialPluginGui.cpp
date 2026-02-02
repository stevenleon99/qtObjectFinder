#include <cranialplugin/CranialPluginGui.h>
#include <cranialplugin/manifest.h>

#include <procd/cranial/types/TrackedToolTypes.h>
#include <procd/common/types/FluoroTypes.h>
#include <procd/cranial/types/AppPageTypes.h>
#include <procd/cranial/types/IctSnapshotStatesTypes.h>
#include <procd/cranial/types/IctMergeStatesTypes.h>
#include <procd/cranial/types/IctFiducialStatesTypes.h>
#include <procd/cranial/types/IctLandmarksStatesTypes.h>
#include <procd/cranial/types/E3DSetupStatesTypes.h>
#include <procd/cranial/types/E3DImageStatesTypes.h>
#include <procd/cranial/types/E3DMergeStatesTypes.h>
#include <procd/cranial/types/E3DLandmarksStatesTypes.h>
#include <procd/cranial/types/RegTransferStatesTypes.h>
#include <procd/cranial/types/CalculatorSmTypes.h>
#include <procd/cranial/types/CalculatorButtonTypes.h>
#include <procd/cranial/types/AcpcStatesTypes.h>
#include <procd/cranial/types/PlanStatesTypes.h>
#include <procd/cranial/types/VerifyStatesTypes.h>
#include <procd/cranial/types/IgeeTypes.h>
#include <procd/cranial/types/AccTestStatesTypes.h>
#include <procd/cranial/types/CadRenderTypes.h>
#include <procd/cranial/types/PatRegSelectStatesTypes.h>
#include <procd/cranial/types/VolumeMergeTypes.h>
#include <procd/cranial/types/FiducialMergeStatesTypes.h>

#include <procd/cranial/managers/AccTestManager.h>
#include <procd/cranial/managers/AlertManager.h>
#include <procd/cranial/managers/FeaturesManager.h>
#include <procd/cranial/managers/IgeeAtTargetManager.h>
#include <procd/cranial/managers/IgeeManager.h>
#include <procd/cranial/managers/IocManager.h>
#include <procd/cranial/managers/FluoroCtCaptureCarmManager.h>
#include <procd/cranial/managers/FluoroCtCaptureGisManager.h>
#include <procd/cranial/managers/LoadCellManager.h>
#include <procd/cranial/managers/LogManager.h>
#include <procd/cranial/managers/MotionSessionManager.h>
#include <procd/cranial/managers/ToolboxManager.h>
#include <procd/cranial/managers/TrajectoryPresetManager.h>
#include <procd/cranial/managers/TransformationManager.h>
#include <procd/cranial/managers/UaibManager.h>
#include <procd/cranial/managers/ToolMarkersSensorhubManager.h>
#include <procd/cranial/managers/E3dManager.h>
#include <procd/cranial/managers/FootpedalManager.h>
#include <procd/cranial/managers/SurgeonSettingsManager.h>
#include <procd/cranial/managers/SkinMeshManager.h>

#include <procd/cranial/viewmodels/ACPCOverlayViewModel.h>
#include <procd/cranial/viewmodels/AccTestNavViewModel.h>
#include <procd/cranial/viewmodels/AccTestSetupViewModel.h>
#include <procd/cranial/viewmodels/ApplicationViewModel.h>
#include <procd/cranial/viewmodels/CalculatorViewModel.h>
#include <procd/cranial/viewmodels/CalculatorLPSViewModel.h>
#include <procd/cranial/viewmodels/Center2DOverlayViewModel.h>
#include <procd/cranial/viewmodels/CheckerboardOverlayViewModel.h>
#include <procd/cranial/viewmodels/E3DImageViewModel.h>
#include <procd/cranial/viewmodels/E3DLandmarksViewModel.h>
#include <procd/cranial/viewmodels/E3DMergeViewModel.h>
#include <procd/cranial/viewmodels/E3DSetupViewModel.h>
#include <procd/cranial/viewmodels/E3DSetupCheckViewModel.h>
#include <procd/cranial/viewmodels/FiducialRegistrationViewModel.h>
#include <procd/cranial/viewmodels/FiducialSetupViewModel.h>
#include <procd/cranial/viewmodels/FluoroCaptureViewModel.h>
#include <procd/cranial/viewmodels/FluoroCentroidOverlayViewModel.h>
#include <procd/cranial/viewmodels/FluoroCentroidViewModel.h>
#include <procd/cranial/viewmodels/FluoroCtLandmarksViewModel.h>
#include <procd/cranial/viewmodels/FluoroCtManualMergeOverlayViewModel.h>
#include <procd/cranial/viewmodels/FluoroCtRegistrationViewModel.h>
#include <procd/cranial/viewmodels/FluoroCtSetupViewModel.h>
#include <procd/cranial/viewmodels/FluoroCtShotsViewModel.h>
#include <procd/cranial/viewmodels/FluoroMeterViewModel.h>
#include <procd/cranial/viewmodels/IctFiducialOverlayViewModel.h>
#include <procd/cranial/viewmodels/IctFiducialViewModel.h>
#include <procd/cranial/viewmodels/IctGetSnapshotViewModel.h>
#include <procd/cranial/viewmodels/IctLandmarksViewModel.h>
#include <procd/cranial/viewmodels/IctMergeViewModel.h>
#include <procd/cranial/viewmodels/IctSnapshotViewModel.h>
#include <procd/cranial/viewmodels/ImageDetailsViewModel.h>
#include <procd/cranial/viewmodels/ImportPopupLoaderViewModel.h>
#include <procd/cranial/viewmodels/InstrumentPlanningViewModel.h>
#include <procd/cranial/viewmodels/InstrumentVerificationViewModel.h>
#include <procd/cranial/viewmodels/LoadCellMeterViewModel.h>
#include <procd/cranial/viewmodels/MeasurementOverlayViewModel.h>
#include <procd/cranial/viewmodels/MergeOverlayViewModel.h>
#include <procd/cranial/viewmodels/NavigateHeaderViewModel.h>
#include <procd/cranial/viewmodels/OrientViewModel.h>
#include <procd/cranial/viewmodels/OrientationOverlayViewModel.h>
#include <procd/cranial/viewmodels/OverlayViewModel.h>
#include <procd/cranial/viewmodels/PatRegSelectViewModel.h>
#include <procd/cranial/viewmodels/PostOpFluoroOverlayViewModel.h>
#include <procd/cranial/viewmodels/PostOpLandmarkOverlayViewModel.h>
#include <procd/cranial/viewmodels/PostOpViewModel.h>
#include <procd/cranial/viewmodels/ProbeOffsetViewModel.h>
#include <procd/cranial/viewmodels/ReachabilityListViewModel.h>
#include <procd/cranial/viewmodels/RegTransferViewModel.h>
#include <procd/cranial/viewmodels/RegistrationResetViewModel.h>
#include <procd/cranial/viewmodels/RenderPositionViewModel.h>
#include <procd/cranial/viewmodels/RenderViewModel.h>
#include <procd/cranial/viewmodels/ShotSelectedViewModel.h>
#include <procd/cranial/viewmodels/SliceSliderOverlayViewModel.h>
#include <procd/cranial/viewmodels/SurveillanceMarkerViewModel.h>
#include <procd/cranial/viewmodels/ToolsVisibilityViewModel.h>
#include <procd/cranial/viewmodels/TopbarViewModel.h>
#include <procd/cranial/viewmodels/TrajectoryDistanceListViewModel.h>
#include <procd/cranial/viewmodels/TrajectoryModifyOverlayViewModel.h>
#include <procd/cranial/viewmodels/TrajectoryOptionsViewModel.h>
#include <procd/cranial/viewmodels/TrajectoryPositionControlViewModel.h>
#include <procd/cranial/viewmodels/TrajectoryPresetsViewModel.h>
#include <procd/cranial/viewmodels/TrajectorySelectorViewModel.h>
#include <procd/cranial/viewmodels/TrajectorySliderViewModel.h>
#include <procd/cranial/viewmodels/TrajectoryViewModel.h>
#include <procd/cranial/viewmodels/TrajectoryVisibilityOptionsViewModel.h>
#include <procd/cranial/viewmodels/UnregVolumeViewModel.h>
#include <procd/cranial/viewmodels/View2DCompareModeViewModel.h>
#include <procd/cranial/viewmodels/View2DCoordinateSystemViewModel.h>
#include <procd/cranial/viewmodels/View2DOrientationTypeViewModel.h>
#include <procd/cranial/viewmodels/View2DOrientationViewModel.h>
#include <procd/cranial/viewmodels/ViewLabelOverlayViewModel.h>
#include <procd/cranial/viewmodels/ViewportBorderOverlayViewModel.h>
#include <procd/cranial/viewmodels/ViewportListViewModel.h>
#include <procd/cranial/viewmodels/ViewportToolsViewModel.h>
#include <procd/cranial/viewmodels/AccTestSetupViewModel.h>
#include <procd/cranial/viewmodels/AccTestNavViewModel.h>
#include <procd/cranial/viewmodels/FluoroCentroidOverlayViewModel.h>
#include <procd/cranial/viewmodels/FluoroCentroidViewModel.h>
#include <procd/cranial/viewmodels/TrajectoryVisibilityOptionsViewModel.h>
#include <procd/cranial/viewmodels/ProbeOffsetViewModel.h>
#include <procd/cranial/viewmodels/InstrumentPlanningViewModel.h>
#include <procd/cranial/viewmodels/View2DCoordinateSystemViewModel.h>
#include <procd/cranial/viewmodels/View2DOrientationViewModel.h>
#include <procd/cranial/viewmodels/View2DOrientationTypeViewModel.h>
#include <procd/cranial/viewmodels/SliceSliderOverlayViewModel.h>
#include <procd/cranial/viewmodels/WorkflowSelectionSidebarViewModel.h>
#include <procd/cranial/viewmodels/E3DImageViewModel.h>
#include <procd/cranial/viewmodels/E3DSetupViewModel.h>
#include <procd/cranial/viewmodels/E3DSetupCheckViewModel.h>
#include <procd/cranial/viewmodels/E3DMergeViewModel.h>
#include <procd/cranial/viewmodels/E3DLandmarksViewModel.h>
#include <procd/cranial/viewmodels/VolumeListViewModel.h>
#include <procd/cranial/viewmodels/VolumeMergeCreateViewModel.h>
#include <procd/cranial/viewmodels/VolumeMergeListViewModel.h>
#include <procd/cranial/viewmodels/WindowLevelOverlayViewModel.h>
#include <procd/cranial/viewmodels/SkinMeshViewModel.h>
#include <procd/cranial/viewmodels/SurfaceSetupViewModel.h>
#include <procd/cranial/viewmodels/SurfaceFiducialViewModel.h>
#include <procd/cranial/viewmodels/SurfaceMapViewModel.h>
#include <procd/cranial/viewmodels/FiducialOverlayViewModel.h>
#include <procd/cranial/viewmodels/SurfaceInitOverlay3DViewModel.h>
#include <procd/cranial/viewmodels/SurfaceInitOverlay2DViewModel.h>
#include <procd/cranial/viewmodels/VolumeMergeStudyViewModel.h>
#include <procd/cranial/viewmodels/VolumeMergeSidebarViewModel.h>
#include <procd/cranial/viewmodels/SurfacePick3dOverlayViewModel.h>
#include <procd/cranial/viewmodels/Orientation3dOverlayViewModel.h>
#include <procd/cranial/viewmodels/FiducialMergeViewModel.h>
#include <procd/cranial/viewmodels/ClipSliceViewModel.h>
#include <procd/cranial/viewmodels/Rotation2dOverlayViewModel.h>
#include <procd/cranial/viewmodels/FastsurferViewModel.h>
#include <procd/cranial/viewmodels/HypothalamusViewModel.h>
#include <procd/cranial/viewmodels/LabelOverlayViewModel.h>
#include <procd/cranial/viewmodels/VesselsViewModel.h>

#include <procd/cranial/propertysources/statemachines/AccTestPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/AcpcPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/E3DImagePageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/E3DLandmarksPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/E3DMergePageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/E3DSetupPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/FiducialMergePageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/FiducialRegistrationPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/FiducialSetupPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/FluoroCtImagePageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/FluoroCtLandmarksPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/FluoroCtRegistrationPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/FluoroCtShotsPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/IctFiducialPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/IctLandmarksPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/IctMergePageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/IctSnapshotPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/MergePageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/NavigationPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/PlanPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/PostOpPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/AccTestPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/PatRegSelectPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/E3DImagePageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/E3DLandmarksPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/E3DMergePageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/E3DSetupPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/VerifyPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/SurfaceSetupPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/SurfaceFiducialPageStateMachinePropSource.h>
#include <procd/cranial/propertysources/statemachines/SurfaceMapPageStateMachinePropSource.h>

#include <procd/cranial/propertysources/FluoroCtPropertySource.h>
#include <procd/cranial/propertysources/PatRefPropertySource.h>
#include <procd/cranial/propertysources/AcpcPropertySource.h>
#include <procd/cranial/propertysources/FluoroSetupPropertySource.h>
#include <procd/cranial/propertysources/CasePropertySource.h>
#include <procd/cranial/propertysources/FluoroPostOpPropertySource.h>
#include <procd/cranial/propertysources/VolumeTreePropertySource.h>
#include <procd/cranial/propertysources/AppDataPropertySource.h>
#include <procd/cranial/propertysources/IctWorkflowPropertySource.h>
#include <procd/cranial/propertysources/E3DWorkflowPropertySource.h>
#include <procd/cranial/propertysources/OverlayStatesPropertySource.h>
#include <procd/cranial/propertysources/SurfaceWorkflowPropertySource.h>
#include <procd/cranial/propertysources/SurfaceSkinModelPropertySource.h>
#include <procd/cranial/propertysources/FiducialWorkflowPropertySource.h>

#include <procd/cranial/atoms/CaseDataReader.h>

#include <procd/cranial/calcprop/TrajLandmarkCalculatedProperty.h>
#include <procd/cranial/calcprop/FiducialSelectionCalculatedProperty.h>
#include <procd/cranial/calcprop/SurfaceInitSelectionCalculatedProperty.h>

#include <procd/cranial/tools/log.h>

#include <procd/cranial/components/VolumeThumbnailProvider.h>
#include <procd/cranial/managers/FluoroImageProvider.h>

#include <procd/cranial/components/ImageViewport.h>

#include <procd/cranial/alerts/LoadingAlertFactory.h>
#include <procd/cranial/alerts/CaseDriveDifferentAlertFactory.h>

#ifdef HOT_RELOAD
#include <procd/cranial/managers/CranialHotReloadManager.h>
#endif

#include <imfusionrendering/ImFusionCombinedBBRenderer.h>
#include <drive/common/PatientName.h>
#include <module/scanmanager/LocalScanManager.h>
#include <gm/arch/transform_to.h>
#include <gm/arch/ContainerDictionary.h>
#include <gm/arch/ioc.h>
#include <sys/config/config.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <gos/gps/endeffectorinfo/EndEffectorInfoProxyFactory.h>
#include <gos/gps/endeffectorinfo/EndEffectorInfoSourceFactory.h>
#include <gos/services/uaib/UaibCommunicationProxyFactory.h>
#include <gos/itf/motion/IGpsArmMotionSessionManager.h>
#include <sys/log/sys_log.h>
#include <sys/log/imfusion.h>
#include <sys/log/qt.h>
#include <uaibcontroller/UaibAdapterFactory.h>

#include <sys/alerts/AlertManagerFactory.h>
#include <sys/alerts/AlertAggregatorFactory.h>

#include <QQmlContext>

#include <boost/uuid/uuid_io.hpp>
#include <optional>

/* The constructor should be the minimum possible because it is called by drive
 * "runheader" runs before "runcase", so beware to put inits only in runcase
 * Check the destructor to be sure that all is being destructed correctly (new
 * variables!)
 *
 * */
CranialPluginGui::CranialPluginGui(QObject* parent)
    : QObject(parent)
    , m_gLinkNode(glink::node::NodeFactory::createInstance())
    , m_armMotion(gos::motion::armmotion::ArmMotionSessionManagerProxyFactory::createInstance<
                  gm::algo::robot::gps::RobotTraits>(
          m_gLinkNode, gos::roles::motion::armmotion::ArmMotionSessionManagerRole))
    , m_uaibController(gos::services::uaib::UaibCommunicationProxyFactory::createInstance(
          m_gLinkNode, gos::services::uaib::UaibAdapterFactory::OBJECT_ID))
    , m_alertManager(sys::alerts::AlertManagerFactory::createInstance())
    , m_importViewModelSource(new drive::scanimport::ImportViewModelSource(this))
    , m_alertView([&] {
        auto aggregator = sys::alerts::AlertAggregatorFactory::createInstance();
        aggregator->addAlertView(m_alertManager);
        aggregator->addAlertView(m_importViewModelSource->getAlertView());
        return aggregator;
    }())
{
    SYS_LOG_INFO("Cranial plugin created");
}

CranialPluginGui::~CranialPluginGui()
{
    SYS_LOG_INFO("Destroying cranial plugin...");

    m_patientRegistrationIctNotTrasnferredService.reset();
    m_patientRegistrationIctService.reset();
    m_patientRegistrationE3DService.reset();
    m_imfusionVolumeService.reset();
    m_imFusionTrackedToolService.reset();
    m_imFusionTrajectoryLandmarkService.reset();
    m_activeToolsSensorhubService.reset();
    m_straysSensorhubService.reset();
    m_surveillanceMarkerSensorhubService.reset();
    m_trackedToolsSensorhubService.reset();
    m_transformSensorhubService.reset();
    m_transformVolumeService.reset();
    m_transformVolumeMergeService.reset();
    m_imFusionTrajService.reset();
    m_transformTrajectoryService.reset();
    m_patientRegistrationFluoroCtService.reset();
    m_patientRegistrationFiducialService.reset();
    m_patientRegistrationSurfaceService.reset();
    m_persistenceService.reset();
    m_toolVerificationService.reset();
    m_transformACPCService.reset();
    m_imFusionACPCService.reset();
    m_motionService.reset();
    m_reachabilityService.reset();
    m_imFusionIctFiducialsService.reset();
    m_fiducialWorkflowService.reset();
    m_center3dService.reset();
    m_surfaceInitService.reset();
    m_surfaceMapService.reset();
    m_fluoroCTViewportService.reset();
    m_viewPositionToolFollowingService.reset();
    m_cranialImportModel.reset();
    m_center3dService.reset();
    m_fluoroCTCaptureService.reset();
    m_motionLockingService.reset();
    m_labelTransformsService.reset();

    cranial::managers::reset();

    if (m_sh)
    {
        m_sh->disconnect();
    }
    m_gLinkNode.reset();
    m_armMotion.reset();
    m_armReachability.reset();
    m_sh.reset();
    m_uaibController.reset();
    m_alertManager.reset();

    ImFusionClient::instance().resetMemory();
    SYS_LOG_INFO("Cranial plugin destroyed");
}

void CranialPluginGui::createBuilder(drive::model::SurgeonIdentifier surgeonId)
{
    // IOC updates

    auto builder = std::make_shared<gm::arch::ioc::ContainerBuilder>();
    builder->registerInstance(std::make_shared<cranial::atoms::AtomOwner>());
    cranial::managers::buildContainer(builder);


    builder = std::make_shared<gm::arch::ioc::ContainerBuilder>();

    builder
        ->registerType<cranial::propertysources::statemachines::MergePageStateMachinePropSource>();
    builder
        ->registerType<cranial::propertysources::statemachines::AcpcPageStateMachinePropSource>();
    builder
        ->registerType<cranial::propertysources::statemachines::PlanPageStateMachinePropSource>();
    builder
        ->registerType<cranial::propertysources::statemachines::VerifyPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::IctSnapshotPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::IctFiducialPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::IctMergePageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::IctLandmarksPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::E3DSetupPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::E3DImagePageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::E3DMergePageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::E3DLandmarksPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::FluoroCtShotsPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::FluoroCtImagePageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::FluoroCtRegistrationPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::FluoroCtLandmarksPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::SurfaceSetupPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::SurfaceFiducialPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::SurfaceMapPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::FiducialSetupPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::FiducialRegistrationPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::FiducialMergePageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::NavigationPageStateMachinePropSource>();
    builder
        ->registerType<cranial::propertysources::statemachines::PostOpPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::AccTestPageStateMachinePropSource>();
    builder->registerType<
        cranial::propertysources::statemachines::PatRegSelectPageStateMachinePropSource>();
    builder->registerInstance(std::make_shared<cranial::managers::ToolboxManager>());
    builder->registerInstance(std::make_shared<cranial::managers::LogManager>());
    builder->registerInstance(std::make_shared<cranial::managers::TransformationManager>());
    builder->registerInstance<gos::itf::gps::IEndEffectorInfo>(
        gos::gps::endeffectorinfo::EndEffectorInfoProxyFactory::createInstance(
            m_gLinkNode, gos::roles::gps::endeffectorinfo::EndEffectorInfoRole));

    builder->registerInstance(std::make_shared<cranial::propertysources::FluoroCtPropertySource>());
    builder->registerInstance(std::make_shared<cranial::propertysources::PatRefPropertySource>());
    builder->registerInstance(
        std::make_shared<cranial::propertysources::RenderModelPropertySource>());
    builder->registerInstance(std::make_shared<cranial::propertysources::AcpcPropertySource>());
    builder->registerInstance(std::make_shared<cranial::propertysources::AppDataPropertySource>());
    builder->registerInstance(
        std::make_shared<cranial::propertysources::OverlayStatesPropertySource>());
    builder->registerInstance(
        std::make_shared<cranial::propertysources::SelectedVolumesPropertySource>());
    builder->registerInstance(std::make_shared<cranial::services::TaskService>());
    builder->registerInstance(
        std::make_shared<cranial::propertysources::IctWorkflowPropertySource>());
    builder->registerInstance(
        std::make_shared<cranial::propertysources::E3DWorkflowPropertySource>());
    builder->registerInstance(
        std::make_shared<cranial::propertysources::SurfaceWorkflowPropertySource>());
    builder->registerInstance(
        std::make_shared<cranial::propertysources::SurfaceSkinModelPropertySource>());
    builder->registerInstance(
        std::make_shared<cranial::propertysources::FiducialWorkflowPropertySource>());

    builder->registerInstance(std::make_shared<cranial::propertysources::FluoroCtPropertySource>());
    builder->registerInstance(
        std::make_shared<cranial::propertysources::FluoroSetupPropertySource>());
    builder->registerInstance(std::make_shared<cranial::propertysources::CasePropertySource>());
    builder->registerInstance(
        std::make_shared<cranial::propertysources::FluoroPostOpPropertySource>());

    builder->registerInstance(
        std::make_shared<cranial::managers::SurgeonSettingsManager>(surgeonId));

    cranial::managers::buildContainer(builder);


    builder = std::make_shared<gm::arch::ioc::ContainerBuilder>();
    builder->registerInstance(
        std::make_shared<cranial::propertysources::VolumeTreePropertySource>());
    builder->registerInstance(std::make_shared<cranial::managers::TrajectoryPresetManager>());
    cranial::managers::buildContainer(builder);


    builder = std::make_shared<gm::arch::ioc::ContainerBuilder>();

    builder->registerInstance(std::make_shared<cranial::viewmodels::ApplicationViewModel>());

    builder->registerInstance(
        std::make_shared<cranial::managers::FluoroCtCaptureCarmManager>(m_gLinkNode));
    builder->registerInstance(
        std::make_shared<cranial::managers::FluoroCtCaptureGisManager>(m_gLinkNode));
    builder->registerInstance(std::make_shared<cranial::managers::IgeeAtTargetManager>());
    builder->registerInstance(std::make_shared<cranial::managers::IgeeManager>(m_gLinkNode));
    builder->registerInstance(std::make_shared<cranial::managers::E3dManager>(m_gLinkNode));
    builder->registerInstance(std::make_shared<cranial::managers::LoadCellManager>(m_gLinkNode));
    builder->registerInstance(std::make_shared<cranial::managers::FootpedalManager>(m_gLinkNode));
    builder->registerInstance(std::make_shared<cranial::managers::MotionSessionManager>());
    builder->registerInstance<sys::alerts::itf::IAlertManager>(m_alertManager);
    builder->registerInstance<cranial::managers::AlertManager>(
        std::make_shared<cranial::managers::AlertManager>(m_alertManager));
    builder->registerInstance(std::make_shared<cranial::managers::SkinMeshManager>());

    // This calls UaibManager, which queries the UAIB fw version. It compares the version number
    // portion only of the received actual version (the second of the four numbers in the version
    // string) to a hard-coded version number instead of the full, expected version string. If there
    // is a mismatch or the query times out without a response, then the "UAIB Version Outdated"
    // pop-up appears and trajectory motion for the Cranial case is prohibited.
    builder->registerInstance(std::make_shared<cranial::managers::UaibManager>(m_uaibController));

    builder->registerInstance(std::make_shared<cranial::managers::ToolMarkersSensorhubManager>());

    builder->registerInstance(
        std::make_shared<cranial::calcprop::TrajLandmarkCalculatedProperty>());

    builder->registerInstance(std::make_shared<cranial::proxy::GnsSensorhubProxy>(m_sh));

    builder->registerInstance(
        std::make_shared<cranial::calcprop::FiducialSelectionCalculatedProperty>());

    builder->registerInstance(
        std::make_shared<cranial::calcprop::SurfaceInitSelectionCalculatedProperty>());

    cranial::managers::buildContainer(builder);

    auto&& iocContainer = cranial::managers::getContainer();
    m_alertView->addAlertView(
        iocContainer->resolve<cranial::managers::FluoroCtCaptureCarmManager>()->getAlertView());
}

void CranialPluginGui::createServices()
{
    m_patientRegistrationIctNotTrasnferredService =
        std::make_shared<cranial::services::PatientRegistrationIctNotTransferredService>();
    m_patientRegistrationIctService =
        std::make_shared<cranial::services::PatientRegistrationIctService>();
    m_patientRegistrationE3DService =
        std::make_shared<cranial::services::PatientRegistrationE3DService>();
    m_imfusionVolumeService = std::make_shared<cranial::services::ImFusionVolumeService>();
    m_imFusionTrackedToolService =
        std::make_shared<cranial::services::ImFusionTrackedToolService>();
    m_imFusionTrajectoryLandmarkService =
        std::make_shared<cranial::services::ImFusionTrajectoryLandmarkService>();
    m_activeToolsSensorhubService =
        std::make_shared<cranial::services::ActiveToolsSensorhubService>();
    m_straysSensorhubService = std::make_shared<cranial::services::StraysSensorhubService>();
    m_surveillanceMarkerSensorhubService =
        std::make_shared<cranial::services::SurveillanceMarkerSensorhubService>();
    m_transformSensorhubService = std::make_shared<cranial::services::TransformSensorhubService>();
    m_trackedToolsSensorhubService =
        std::make_shared<cranial::services::TrackedToolsSensorhubService>();
    m_transformVolumeService = std::make_shared<cranial::services::TransformVolumeService>();
    m_transformVolumeMergeService =
        std::make_shared<cranial::services::TransformVolumeMergeService>();
    m_imFusionTrajService = std::make_shared<cranial::services::ImFusionTrajectoryService>();
    m_transformTrajectoryService =
        std::make_shared<cranial::services::TransformTrajectoryService>();
    m_patientRegistrationFluoroCtService =
        std::make_shared<cranial::services::PatientRegistrationFluoroCtService>();
    m_patientRegistrationFiducialService =
        std::make_shared<cranial::services::PatientRegistrationFiducialService>();
    m_patientRegistrationSurfaceService =
        std::make_shared<cranial::services::PatientRegistrationSurfaceService>();
    m_persistenceService = std::make_shared<cranial::services::PersistenceService>();
    m_toolVerificationService = std::make_shared<cranial::services::ToolVerificationService>();
    m_transformACPCService = std::make_shared<cranial::services::TransformACPCService>();
    m_imFusionACPCService = std::make_shared<cranial::services::ImFusionACPCService>();
    m_motionService = std::make_shared<cranial::services::MotionService>(m_armMotion);
    m_motionLockingService =
        std::make_shared<cranial::services::MotionLockingService>(m_armMotion, m_gLinkNode);
    m_reachabilityService =
        std::make_shared<cranial::services::ReachabilityService>(m_armReachability);
    m_imFusionIctFiducialsService =
        std::make_shared<cranial::services::ImFusionIctFiducialsService>();
    m_fiducialWorkflowService =
        std::make_shared<cranial::services::imfusion::FiducialWorkflowService>();
    m_surfaceInitService = std::make_shared<cranial::services::imfusion::SurfaceInitService>();
    m_surfaceMapService = std::make_shared<cranial::services::imfusion::SurfaceMapService>();
    m_fluoroCTViewportService = std::make_shared<cranial::services::FluoroCTViewportService>();
    m_viewPositionToolFollowingService =
        std::make_shared<cranial::services::ViewPositionToolFollowingService>();
    m_motionSessionAlertService =
        std::make_shared<cranial::services::MotionSessionAlertService>(m_gLinkNode);
    m_center3dService = std::make_shared<cranial::services::imfusion::Center3DService>();
    m_labelTransformsService = std::make_shared<cranial::services::LabelTransformsService>();

    m_cranialImportModel = std::make_shared<CranialImportModel>(m_importViewModelSource);
    m_igeeVerificationService = std::make_shared<cranial::services::IgeeVerificationService>();
    m_center3dService = std::make_shared<cranial::services::imfusion::Center3DService>();
    m_fluoroCTCaptureService = std::make_shared<cranial::services::FluoroCTCaptureService>();
}

void CranialPluginGui::createProviders()
{
    // Memory deleted when provider is deleted from the engine
    m_pluginContext->engine()->addImageProvider("volumeThumbnail",
                                                new cranial::components::VolumeThumbnailProvider());
    m_pluginContext->engine()->addImageProvider("combinedBB", new ImFusionCombinedBBRenderer());
    m_pluginContext->engine()->addImageProvider("fluoroimage",
                                                new cranial::managers::FluoroImageProvider());
}

void CranialPluginGui::requestQuit()
{
    G_EMIT pluginQuitRequested(cranial::plugin::manifest::PLUGIN_SHORT_NAME,
                               [res = m_driveCaseData](auto&&) { return res; });
}

std::string CranialPluginGui::getQmlPath() const
{
#ifdef HOT_RELOAD
    QString qmlPath = "file:///" + qgetenv("PLUGIN_QML");
#else
    QString qmlPath = "qrc:/cranial/qml/cranial.qml";
#endif
    SYS_LOG_INFO("Loading Cranial plugin QML from: {}", qmlPath);
    return qmlPath.toStdString();
}

std::string CranialPluginGui::getHeaderQmlPath() const
{
    return "qrc:/cranial/qml/components/applicationheader/cranialheader/CranialHeader.qml";
}

void CranialPluginGui::runCase(WorkflowCaseId id,
                               DriveCaseData driveData,
                               std::vector<std::string> featureSet,
                               IWorkFlowPluginGui::ReachableScans reachableScans,
                               std::shared_ptr<gos::itf::scanmanager::IScanManager> scanManager,
                               std::shared_ptr<plugin::IPluginShell> shell,
                               drive::model::SurgeonIdentifier surgeonId,
                               [[maybe_unused]] std::optional<std::string> surgeonName)
{
    namespace armmotion = gos::motion::armmotion;


    m_driveCaseData = driveData;
    m_scanManager = scanManager;
    m_pluginShellList.push_back(shell);

    m_sh = gos::nav::SensorHubProxyFactory::createInstance(m_gLinkNode);

    if (!m_pluginContext)
    {
        setupContext(shell->getQmlContext());
        createBuilder(surgeonId);
    }

    QString caseID = QString::fromStdString(boost::uuids::to_string(id.id));
    SYS_LOG_INFO("Running case {}", caseID);

    m_armMotion = armmotion::ArmMotionSessionManagerProxyFactory::createInstance<
        gm::algo::robot::gps::RobotTraits>(
        m_gLinkNode, gos::roles::motion::armmotion::ArmMotionSessionManagerRole);

    // Send Cranial EE Mass Model to GMAS
    const double IGEE_CRANIAL_FORCE_N = 13.6847;
    const gm::geom::Vector3d igeeCg{0.0567517, -0.00037282, 0.00363806};
    m_armMotion->setEndEffectorMassModel(IGEE_CRANIAL_FORCE_N, igeeCg);

    m_armReachability = armmotion::ArmReachabilityProxyFactory::createInstance(
        m_gLinkNode, gos::roles::motion::armmotion::ArmReachabilityRole);

    sys::log::redirectQDebugToSysLog();
    sys::log::redirectImFusionLogToSysLog(sys::log::LogLevel::Debug);

    createServices();
    createProviders();
    createContextProperties();
    cranial::viewmodels::ApplicationViewModel::instance().initGmDebug(m_gLinkNode);

    m_reachableScanIds =
        std::shared_ptr<gm::arch::ICollection<ScanId>>{gm::arch::transform_to<ScanId>(
            std::move(reachableScans), [](auto&& valuePair) { return GM_FWD(valuePair).first; })};
    auto importedScanIds = std::shared_ptr<gm::arch::ICollection<ScanId>>{
        gm::arch::transform_to<ScanId>(gm::arch::createDictionary(driveData.caseSeries),
                                       [](auto&& valuePair) { return GM_FWD(valuePair).first; })};
    auto localScans = module::scanmanager::localScanManager(
        scanManager, driveData.patientData.fullName, m_reachableScanIds);

    m_importViewModelSource->setVolumeImportSources({scanManager, localScans});
    m_importViewModelSource->setDestinationFilter(
        module::scanmanager::LocalScanFilter{importedScanIds});
    m_importViewModelSource->setDestinationPatient(
        drive::scanimport::patientMatcher(driveData.patientData));

    gm::util::qt::connect(m_cranialImportModel->driveCaseDataUpdateSignal, this,
                          &CranialPluginGui::onDriveCaseDataUpdate);
    m_pluginContext->setContextProperty("importViewModelSource", m_importViewModelSource);

    auto builder = std::make_shared<gm::arch::ioc::ContainerBuilder>();
    builder->registerInstance<gos::itf::scanmanager::IScanManager>(scanManager);

    QList<QString> featureSetQt;
    for (auto feature : featureSet)
    {
        featureSetQt.push_back(QString::fromStdString(feature));
    }

    builder->registerInstance(std::make_shared<cranial::managers::FeaturesManager>(featureSetQt));

    if (cranial::viewmodels::ApplicationViewModel::instance().testModeEnabled())
    {
        builder->registerInstance(std::make_shared<cranial::managers::AccTestManager>());
    }
    cranial::managers::buildContainer(builder);

    // TODO: Temporarily request loading with a delay
    //       Consider a solution with a worker thread to avoid heavy processing
    //       in the main thread
    showLoadingAlert();
    using namespace std::chrono_literals;
    QTimer::singleShot(200ms, this, [this, caseID, driveData, shell] {
        cranial::actions::restoreLatestSnapshot(
            caseID, cranial::actions::ApplicationDataLoad::AppDataRequired);
        auto driveDataOpt = compareDriveAppData(
            driveData, cranial::propertysources::AppDataPropertySource::instance().driveCaseData());
        if (driveDataOpt.has_value())
        {
            cranial::actions::setDriveCaseData(driveDataOpt.value());
            cranial::actions::saveStateSnapshot();

            shell->createPluginComponent(m_pluginContext.data());
            hideLoadingAlert();
        }
        else
        {
            hideLoadingAlert();
            showCaseDriveDifferentAlert();
            shell->deletePluginComponent();
        }
    });
}

void CranialPluginGui::runHeader(std::shared_ptr<plugin::IPluginShell> shell,
                                 drive::model::SurgeonIdentifier surgeonId)
{
    m_pluginShellList.push_back(shell);
    if (!m_pluginContext)
    {
        setupContext(shell->getQmlContext());
        createBuilder(surgeonId);
    }

    // Next line load TopBarViewmodel
    shell->createPluginComponent(m_pluginContext.data());
}

void CranialPluginGui::cleanupPluginQml()
{
    if (m_pluginContext && m_pluginContext->engine())
    {
        m_pluginContext->engine()->removeImageProvider(QLatin1String("volumeThumbnail"));
        m_pluginContext->engine()->removeImageProvider(QLatin1String("combinedBB"));
        m_pluginContext->engine()->removeImageProvider(QLatin1String("fluoroimage"));
    }

    for (auto& pluginShell : m_pluginShellList)
    {
        pluginShell->deletePluginComponent();
    }
}

void CranialPluginGui::quitPlugin()
{
    cranial::actions::saveStateSnapshot();
    G_EMIT pluginQuitAcknowledged(cranial::plugin::manifest::PLUGIN_SHORT_NAME,
                                  [res = m_driveCaseData](auto&&) { return res; });
}

[[nodiscard]] std::shared_ptr<gos::itf::alerts::IAlertView> CranialPluginGui::getAlertView() const
{
    return m_alertView;
}

void CranialPluginGui::createContextProperties()
{
    QVector<QQmlContext::PropertyPair> contextProperties;
    contextProperties.append(QQmlContext::PropertyPair{"pluginGui", QVariant::fromValue(this)});
    contextProperties.append(QQmlContext::PropertyPair{
        "volumeRegistrationTaskFactory", QVariant::fromValue(&m_volumeRegistrationTaskFactory)});
    contextProperties.append(QQmlContext::PropertyPair{
        "viewportListViewModel",
        QVariant::fromValue(new cranial::viewmodels::ViewportListViewModel(this))});
    contextProperties.append(QQmlContext::PropertyPair{
        "unregVolumeViewModel",
        QVariant::fromValue(new cranial::viewmodels::UnregVolumeViewModel(this))});
    contextProperties.append(QQmlContext::PropertyPair{
        "renderViewModel", QVariant::fromValue(new cranial::viewmodels::RenderViewModel(this))});
    contextProperties.append(QQmlContext::PropertyPair{
        "overlayViewModel", QVariant::fromValue(new cranial::viewmodels::OverlayViewModel(this))});
    contextProperties.append(QQmlContext::PropertyPair{
        "applicationViewModel",
        QVariant::fromValue(&cranial::viewmodels::ApplicationViewModel::instance())});

#ifdef HOT_RELOAD
    SYS_LOG_INFO("Cranial QML hot reload enabled");
    auto hotReloadManager = new CranialHotReloadManager(m_pluginContext->engine(), this);
#else
    SYS_LOG_INFO("Cranial QML hot reload disabled");
    auto hotReloadManager = new QObject(this);
#endif
    contextProperties.append(
        QQmlContext::PropertyPair{"hotReloadManager", QVariant::fromValue(hotReloadManager)});

    auto datapath = sys::config::Config::instance()->config.apps().gpsClientCranial().data();
    QString cranialDataPath = QString::fromStdString(datapath.string());
    contextProperties.append(QQmlContext::PropertyPair{"cranialDataPath", cranialDataPath});

    m_pluginContext->setContextProperties(contextProperties);
}

void CranialPluginGui::setupContext(QPointer<QQmlContext> context)
{
    m_pluginContext = context;

    m_pluginContext->engine()->addImportPath("qrc:/imports");

    qmlRegisterType<cranial::components::ImageViewport>("ViewModels", 1, 0, "ImageViewport");
    qmlRegisterType<cranial::viewmodels::OrientViewModel>("ViewModels", 1, 0, "OrientViewModel");
    qmlRegisterType<cranial::viewmodels::ApplicationViewModel>("ViewModels", 1, 0,
                                                               "ApplicationViewModel");
    qmlRegisterType<cranial::viewmodels::TrajectoryViewModel>("ViewModels", 1, 0,
                                                              "TrajectoryViewModel");
    qmlRegisterType<cranial::viewmodels::MergeOverlayViewModel>("ViewModels", 1, 0,
                                                                "MergeOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::VolumeListViewModel>("ViewModels", 1, 0,
                                                              "VolumeListViewModel");
    qmlRegisterType<cranial::viewmodels::VolumeMergeListViewModel>("ViewModels", 1, 0,
                                                                   "VolumeMergeListViewModel");
    qmlRegisterType<cranial::viewmodels::VolumeMergeCreateViewModel>("ViewModels", 1, 0,
                                                                     "VolumeMergeCreateViewModel");
    qmlRegisterType<cranial::viewmodels::ViewportListViewModel>("ViewModels", 1, 0,
                                                                "ViewportListViewModel");
    qmlRegisterType<cranial::viewmodels::Center2DOverlayViewModel>("ViewModels", 1, 0,
                                                                   "Center2DOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::SliceSliderOverlayViewModel>(
        "ViewModels", 1, 0, "SliceSliderOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::CheckerboardOverlayViewModel>(
        "ViewModels", 1, 0, "CheckerboardOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::OrientationOverlayViewModel>(
        "ViewModels", 1, 0, "OrientationOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::MeasurementOverlayViewModel>(
        "ViewModels", 1, 0, "MeasurementOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::ViewLabelOverlayViewModel>("ViewModels", 1, 0,
                                                                    "ViewLabelOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::ACPCOverlayViewModel>("ViewModels", 1, 0,
                                                               "ACPCOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::PostOpLandmarkOverlayViewModel>(
        "ViewModels", 1, 0, "PostOpLandmarkOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::TrajectoryModifyOverlayViewModel>(
        "ViewModels", 1, 0, "TrajectoryModifyOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::WindowLevelOverlayViewModel>(
        "ViewModels", 1, 0, "WindowLevelOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::IctFiducialViewModel>("ViewModels", 1, 0,
                                                               "IctFiducialViewModel");
    qmlRegisterType<cranial::viewmodels::IctSnapshotViewModel>("ViewModels", 1, 0,
                                                               "IctSnapshotViewModel");
    qmlRegisterType<cranial::viewmodels::IctGetSnapshotViewModel>("ViewModels", 1, 0,
                                                                  "IctGetSnapshotViewModel");
    qmlRegisterType<cranial::viewmodels::FiducialMergeViewModel>("ViewModels", 1, 0,
                                                                 "FiducialMergeViewModel");
    qmlRegisterType<cranial::viewmodels::IctMergeViewModel>("ViewModels", 1, 0,
                                                            "IctMergeViewModel");
    qmlRegisterType<cranial::viewmodels::IctLandmarksViewModel>("ViewModels", 1, 0,
                                                                "IctLandmarksViewModel");
    qmlRegisterType<cranial::viewmodels::E3DImageViewModel>("ViewModels", 1, 0,
                                                            "E3DImageViewModel");
    qmlRegisterType<cranial::viewmodels::E3DSetupViewModel>("ViewModels", 1, 0,
                                                            "E3DSetupViewModel");
    qmlRegisterType<cranial::viewmodels::E3DSetupCheckViewModel>("ViewModels", 1, 0,
                                                                 "E3DSetupCheckViewModel");
    qmlRegisterType<cranial::viewmodels::E3DMergeViewModel>("ViewModels", 1, 0,
                                                            "E3DMergeViewModel");
    qmlRegisterType<cranial::viewmodels::E3DLandmarksViewModel>("ViewModels", 1, 0,
                                                                "E3DLandmarksViewModel");
    qmlRegisterType<cranial::viewmodels::PatRegSelectViewModel>("ViewModels", 1, 0,
                                                                "PatRegSelectViewModel");
    qmlRegisterType<cranial::viewmodels::InstrumentVerificationViewModel>(
        "ViewModels", 1, 0, "InstrumentVerificationViewModel");
    qmlRegisterType<cranial::viewmodels::ToolsVisibilityViewModel>("ViewModels", 1, 0,
                                                                   "ToolsVisibilityViewModel");
    qmlRegisterType<cranial::viewmodels::FluoroCtSetupViewModel>("ViewModels", 1, 0,
                                                                 "FluoroCtSetupViewModel");
    qmlRegisterType<cranial::viewmodels::FluoroCtShotsViewModel>("ViewModels", 1, 0,
                                                                 "FluoroCtShotsViewModel");
    qmlRegisterType<cranial::viewmodels::FluoroCtRegistrationViewModel>(
        "ViewModels", 1, 0, "FluoroCtRegistrationViewModel");
    qmlRegisterType<cranial::viewmodels::FluoroCtLandmarksViewModel>("ViewModels", 1, 0,
                                                                     "FluoroCtLandmarksViewModel");
    qmlRegisterType<cranial::viewmodels::FluoroCtManualMergeOverlayViewModel>(
        "ViewModels", 1, 0, "FluoroCtManualMergeOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::RenderPositionViewModel>("ViewModels", 1, 0,
                                                                  "RenderPositionViewModel");
    qmlRegisterType<cranial::viewmodels::ViewportBorderOverlayViewModel>(
        "ViewModels", 1, 0, "ViewportBorderOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::PostOpViewModel>("ViewModels", 1, 0, "PostOpViewModel");
    qmlRegisterType<cranial::viewmodels::FluoroCentroidOverlayViewModel>(
        "ViewModels", 1, 0, "FluoroCentroidOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::FluoroCentroidViewModel>("ViewModels", 1, 0,
                                                                  "FluoroCentroidViewModel");
    qmlRegisterType<cranial::viewmodels::PostOpFluoroOverlayViewModel>(
        "ViewModels", 1, 0, "PostOpFluoroOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::FluoroCaptureViewModel>("ViewModels", 1, 0,
                                                                 "FluoroCaptureViewModel");
    qmlRegisterType<cranial::viewmodels::ShotSelectedViewModel>("ViewModels", 1, 0,
                                                                "ShotSelectedViewModel");
    qmlRegisterType<cranial::viewmodels::TrajectoryPositionControlViewModel>(
        "ViewModels", 1, 0, "TrajectoryPositionControlViewModel");
    qmlRegisterType<cranial::viewmodels::TrajectorySliderViewModel>("ViewModels", 1, 0,
                                                                    "TrajectorySliderViewModel");
    qmlRegisterType<cranial::viewmodels::RegTransferViewModel>("ViewModels", 1, 0,
                                                               "RegTransferViewModel");
    qmlRegisterType<cranial::viewmodels::View2DCompareModeViewModel>("ViewModels", 1, 0,
                                                                     "View2DCompareModeViewModel");
    qmlRegisterType<cranial::viewmodels::TrajectorySelectorViewModel>(
        "ViewModels", 1, 0, "TrajectorySelectorViewModel");
    qmlRegisterType<cranial::viewmodels::ReachabilityListViewModel>("ViewModels", 1, 0,
                                                                    "ReachabilityListViewModel");
    qmlRegisterType<cranial::viewmodels::NavigateHeaderViewModel>("ViewModels", 1, 0,
                                                                  "NavigateHeaderViewModel");
    qmlRegisterType<cranial::viewmodels::FluoroMeterViewModel>("ViewModels", 1, 0,
                                                               "FluoroMeterViewModel");
    qmlRegisterType<cranial::viewmodels::SurveillanceMarkerViewModel>(
        "ViewModels", 1, 0, "SurveillanceMarkerViewModel");
    qmlRegisterType<cranial::viewmodels::TrajectoryOptionsViewModel>("ViewModels", 1, 0,
                                                                     "TrajectoryOptionsViewModel");
    qmlRegisterType<cranial::viewmodels::IctFiducialOverlayViewModel>(
        "ViewModels", 1, 0, "IctFiducialOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::CalculatorLPSViewModel>("ViewModels", 1, 0,
                                                                 "CalculatorLPSViewModel");
    qmlRegisterType<cranial::viewmodels::CalculatorViewModel>("ViewModels", 1, 0,
                                                              "CalculatorViewModel");
    qmlRegisterType<cranial::viewmodels::TrajectoryDistanceListViewModel>(
        "ViewModels", 1, 0, "TrajectoryDistanceListViewModel");
    qmlRegisterType<cranial::viewmodels::RegistrationResetViewModel>("ViewModels", 1, 0,
                                                                     "RegistrationResetViewModel");
    qmlRegisterType<cranial::viewmodels::TopbarViewModel>("ViewModels", 1, 0, "TopbarViewModel");
    qmlRegisterType<cranial::viewmodels::TrajectoryPresetsViewModel>("ViewModels", 1, 0,
                                                                     "TrajectoryPresetsViewModel");
    qmlRegisterType<cranial::viewmodels::LoadCellMeterViewModel>("ViewModels", 1, 0,
                                                                 "LoadCellMeterViewModel");
    qmlRegisterType<cranial::viewmodels::ImageDetailsViewModel>("ViewModels", 1, 0,
                                                                "ImageDetailsViewModel");
    qmlRegisterType<cranial::viewmodels::ImportPopupLoaderViewModel>("ViewModels", 1, 0,
                                                                     "ImportPopupLoaderViewModel");
    qmlRegisterType<cranial::viewmodels::AccTestSetupViewModel>("ViewModels", 1, 0,
                                                                "AccTestSetupViewModel");
    qmlRegisterType<cranial::viewmodels::AccTestNavViewModel>("ViewModels", 1, 0,
                                                              "AccTestNavViewModel");
    qmlRegisterType<cranial::viewmodels::TrajectoryVisibilityOptionsViewModel>(
        "ViewModels", 1, 0, "TrajectoryVisibilityOptionsViewModel");
    qmlRegisterType<cranial::viewmodels::ProbeOffsetViewModel>("ViewModels", 1, 0,
                                                               "ProbeOffsetViewModel");
    qmlRegisterType<cranial::viewmodels::InstrumentPlanningViewModel>(
        "ViewModels", 1, 0, "InstrumentPlanningViewModel");
    qmlRegisterType<cranial::viewmodels::View2DCoordinateSystemViewModel>(
        "ViewModels", 1, 0, "View2DCoordinateSystemViewModel");
    qmlRegisterType<cranial::viewmodels::View2DOrientationViewModel>("ViewModels", 1, 0,
                                                                     "View2DOrientationViewModel");
    qmlRegisterType<cranial::viewmodels::View2DOrientationTypeViewModel>(
        "ViewModels", 1, 0, "View2DOrientationTypeViewModel");
    qmlRegisterType<cranial::viewmodels::WorkflowSelectionSidebarViewModel>(
        "ViewModels", 1, 0, "WorkflowSelectionSidebarViewModel");
    qmlRegisterType<cranial::viewmodels::SurfaceSetupViewModel>("ViewModels", 1, 0,
                                                                "SurfaceSetupViewModel");
    qmlRegisterType<cranial::viewmodels::SurfaceFiducialViewModel>("ViewModels", 1, 0,
                                                                   "SurfaceFiducialViewModel");
    qmlRegisterType<cranial::viewmodels::SurfaceMapViewModel>("ViewModels", 1, 0,
                                                              "SurfaceMapViewModel");
    qmlRegisterType<cranial::viewmodels::FiducialSetupViewModel>("ViewModels", 1, 0,
                                                                 "FiducialSetupViewModel");
    qmlRegisterType<cranial::viewmodels::FiducialRegistrationViewModel>(
        "ViewModels", 1, 0, "FiducialRegistrationViewModel");
    qmlRegisterType<cranial::viewmodels::FiducialOverlayViewModel>("ViewModels", 1, 0,
                                                                   "FiducialOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::SkinMeshViewModel>("ViewModels", 1, 0,
                                                            "SkinMeshViewModel");
    qmlRegisterType<cranial::viewmodels::SurfaceInitOverlay2DViewModel>(
        "ViewModels", 1, 0, "SurfaceInitOverlay2DViewModel");
    qmlRegisterType<cranial::viewmodels::SurfaceInitOverlay3DViewModel>(
        "ViewModels", 1, 0, "SurfaceInitOverlay3DViewModel");
    qmlRegisterType<cranial::viewmodels::VolumeMergeStudyViewModel>("ViewModels", 1, 0,
                                                                    "VolumeMergeStudyViewModel");
    qmlRegisterType<cranial::viewmodels::VolumeMergeSidebarViewModel>(
        "ViewModels", 1, 0, "VolumeMergeSidebarViewModel");
    qmlRegisterType<cranial::viewmodels::SurfacePick3dOverlayViewModel>(
        "ViewModels", 1, 0, "SurfacePick3dOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::Orientation3dOverlayViewModel>(
        "ViewModels", 1, 0, "Orientation3dOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::ClipSliceViewModel>("ViewModels", 1, 0,
                                                             "ClipSliceViewModel");
    qmlRegisterType<cranial::viewmodels::Rotation2dOverlayViewModel>("ViewModels", 1, 0,
                                                                     "Rotation2dOverlayViewModel");
    qmlRegisterType<cranial::viewmodels::FastsurferViewModel>("ViewModels", 1, 0,
                                                              "FastsurferViewModel");
    qmlRegisterType<cranial::viewmodels::HypothalamusViewModel>("ViewModels", 1, 0,
                                                                "HypothalamusViewModel");
    qmlRegisterType<cranial::viewmodels::VesselsViewModel>("ViewModels", 1, 0, "VesselsViewModel");

    qRegisterMetaType<cranial::model::Volume>("Volume");
    qRegisterMetaType<cranial::model::VolumeMerge>("VolumeMerge");
    qRegisterMetaType<QList<QVector3D>>("QList<QVector3D>");
    qRegisterMetaType<std::optional<double>>("std::optional<double>");
    qRegisterMetaType<std::optional<int>>("std::optional<int>");

    qmlRegisterUncreatableType<cranial::tasks::ITask>("Tasks", 1, 0, "ITask", "");


    qRegisterMetaType<cranial::types::InstrumentVerificationElementTypes>(
        "cranial::types::"
        "InstrumentVerificationElementTypes");
    qmlRegisterUncreatableType<cranial::types::InstrumentVerificationElementTypesClass>(
        "Enums", 1, 0, "InstrumentVerificationElementTypes", "Unable to instantiate enum");
    qRegisterMetaType<cranial::types::View2DOrientationType>(
        "cranial::types::View2DOrientationType");
    qmlRegisterUncreatableType<cranial::types::View2DOrientationTypeClass>(
        "ViewportEnums", 1, 0, "View2DOrientationType", "Unable to instantiate enum");
    qRegisterMetaType<cranial::types::CompareMode>("cranial::types::CompareMode");
    qmlRegisterUncreatableType<cranial::types::CompareModeClass>(
        "ViewportEnums", 1, 0, "CompareMode", "Unable to instantiate enum");
    qRegisterMetaType<cranial::types::CompareModeColor>("cranial::types::CompareModeColor");
    qmlRegisterUncreatableType<cranial::types::CompareModeColorClass>(
        "ViewportEnums", 1, 0, "CompareModeColor", "Unable to instantiate enum");
    qRegisterMetaType<cranial::types::Viewport3DRenderMode>("cranial::types::Viewport3DRenderMode");
    qmlRegisterUncreatableType<cranial::types::Viewport3DRenderModeClass>(
        "ViewportEnums", 1, 0, "Viewport3DRenderMode", "Unable to instantiate enum");
    qRegisterMetaType<cranial::types::View2DCoordinateType>("cranial::types::View2DCoordinateType");
    qmlRegisterUncreatableType<cranial::types::View2DCoordinateTypeClass>(
        "ViewportEnums", 1, 0, "View2DCoordinateType", "Unable to instantiate enum");
    qRegisterMetaType<cranial::types::ViewOrientation>("cranial::types::ViewOrientation");
    qmlRegisterUncreatableType<cranial::types::ViewOrientationClass>(
        "ViewportEnums", 1, 0, "ViewOrientation", "Unable to instantiate enum");

    qmlRegisterType<cranial::viewmodels::ViewportToolsViewModel>("ViewModels", 1, 0,
                                                                 "ViewportToolsViewModel");

    qRegisterMetaType<cranial::types::AcpcPageState>("cranial::types::AcpcPageState");
    qmlRegisterUncreatableType<cranial::types::AcpcPageStateClass>(
        "AcpcStatesPage", 1, 0, "AcpcStatesPage", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::PlanPageState>("cranial::types::PlanPageState");
    qmlRegisterUncreatableType<cranial::types::PlanPageStateClass>(
        "PlanStatesPage", 1, 0, "PlanStatesPage", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::VerifyPageState>("cranial::types::VerifyPageState");
    qmlRegisterUncreatableType<cranial::types::VerifyPageStateClass>(
        "VerifyStatesPage", 1, 0, "VerifyStatesPage", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::AppPage>("cranial::types::AppPage");
    qmlRegisterUncreatableType<cranial::types::PagesClass>("AppPage", 1, 0, "AppPage",
                                                           "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::IctSnapshotPageState>("cranial::types::IctSnapshotPageState");
    qmlRegisterUncreatableType<cranial::types::IctSnapshotPageStateClass>(
        "IctSnapshotStatesPage", 1, 0, "IctSnapshotStatesPage", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::IctMergePageState>("cranial::types::IctMergePageState");
    qmlRegisterUncreatableType<cranial::types::IctMergePageStateClass>(
        "IctMergeStatesPage", 1, 0, "IctMergeStatesPage", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::IctFiducialPageState>("cranial::types::IctFiducialPageState");
    qmlRegisterUncreatableType<cranial::types::IctFiducialPageStateClass>(
        "IctFiducialStatesPage", 1, 0, "IctFiducialStatesPage", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::IctLandmarksPageState>(
        "cranial::types::IctLandmarksPageState");
    qmlRegisterUncreatableType<cranial::types::IctLandmarksPageStateClass>(
        "IctLandmarksStatesPage", 1, 0, "IctLandmarksStatesPage", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::E3DSetupPageState>("cranial::types::E3DSetupPageState");
    qmlRegisterUncreatableType<cranial::types::E3DSetupPageStateClass>(
        "E3DSetupStatesPage", 1, 0, "E3DSetupStatesPage", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::E3DImagePageState>("cranial::types::E3DImagePageState");
    qmlRegisterUncreatableType<cranial::types::E3DImagePageStateClass>(
        "E3DImageStatesPage", 1, 0, "E3DImageStatesPage", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::E3DMergePageState>("cranial::types::E3DMergePageState");
    qmlRegisterUncreatableType<cranial::types::E3DMergePageStateClass>(
        "E3DMergeStatesPage", 1, 0, "E3DMergeStatesPage", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::E3DLandmarksPageState>(
        "cranial::types::E3DLandmarksPageState");
    qmlRegisterUncreatableType<cranial::types::E3DLandmarksPageStateClass>(
        "E3DLandmarksStatesPage", 1, 0, "E3DLandmarksStatesPage", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::FluoroCtImagePageState>(
        "cranial::types::FluoroCtImagePageState");
    qmlRegisterUncreatableType<cranial::types::FluoroCtImagePageStateClass>(
        "FluoroCtImagePageState", 1, 0, "FluoroCtImagePageState", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::FluoroCtShotsPageState>(
        "cranial::types::FluoroCtShotsPageState");
    qmlRegisterUncreatableType<cranial::types::FluoroCtShotsPageStateClass>(
        "FluoroCtShotsPageState", 1, 0, "FluoroCtShotsPageState", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::FluoroCtShotsStatus>("cranial::types::FluoroCtShotsStatus");
    qmlRegisterUncreatableType<cranial::types::FluoroCtShotsStatusClass>(
        "FluoroCtShotsStatus", 1, 0, "FluoroCtShotsStatus", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::SurfaceSetupPageState>(
        "cranial::types::SurfaceSetupPageState");
    qmlRegisterUncreatableType<cranial::types::SurfaceSetupPageStateClass>(
        "SurfaceSetupPageState", 1, 0, "SurfaceSetupPageState", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::SurfaceFiducialPageState>(
        "cranial::types::SurfaceFiducialPageState");
    qmlRegisterUncreatableType<cranial::types::SurfaceFiducialPageStateClass>(
        "SurfaceFiducialPageState", 1, 0, "SurfaceFiducialPageState", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::SurfaceMapPageState>("cranial::types::SurfaceMapPageState");
    qmlRegisterUncreatableType<cranial::types::SurfaceMapPageStateClass>(
        "SurfaceMapPageState", 1, 0, "SurfaceMapPageState", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::FiducialSetupPageState>(
        "cranial::types::FiducialSetupPageState");
    qmlRegisterUncreatableType<cranial::types::FiducialSetupPageStateClass>(
        "FiducialSetupPageState", 1, 0, "FiducialSetupPageState", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::FiducialMergePageState>(
        "cranial::types::FiducialMergePageState");
    qmlRegisterUncreatableType<cranial::types::FiducialMergePageStateClass>(
        "FiducialMergeStatesPage", 1, 0, "FiducialMergeStatesPage", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::FiducialRegistrationPageState>(
        "cranial::types::FiducialRegistrationPageState");
    qmlRegisterUncreatableType<cranial::types::FiducialRegistrationPageStateClass>(
        "FiducialRegistrationPageState", 1, 0, "FiducialRegistrationPageState",
        "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::FluoroCtRegistrationPageState>(
        "cranial::types::FluoroCtRegistrationPageState");
    qmlRegisterUncreatableType<cranial::types::FluoroCtRegistrationPageStateClass>(
        "FluoroCtRegistrationPageState", 1, 0, "FluoroCtRegistrationPageState",
        "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::FluoroCtLandmarksPageState>(
        "cranial::types::FluoroCtLandmarksPageState");
    qmlRegisterUncreatableType<cranial::types::FluoroCtLandmarksPageStateClass>(
        "FluoroCtLandmarksPageState", 1, 0, "FluoroCtLandmarksPageState",
        "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::AccTestPageState>("cranial::types::AccTestPageState");
    qmlRegisterUncreatableType<cranial::types::AccTestPageStateClass>(
        "AccTestPageState", 1, 0, "AccTestPageState", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::ToolCalibratedStatus>("cranial::types::ToolCalibratedStatus");
    qmlRegisterUncreatableType<cranial::types::ToolCalibratedStatusClass>(
        "Enums", 1, 0, "ToolCalibratedStatus", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::ToolVerifiedStatus>("cranial::types::ToolVerifiedStatus");
    qmlRegisterUncreatableType<cranial::types::ToolVerifiedStatusClass>(
        "Enums", 1, 0, "ToolVerifiedStatus", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::ToolVisibilityStatus>("cranial::types::ToolVisibilityStatus");
    qmlRegisterUncreatableType<cranial::types::ToolVisibilityStatusClass>(
        "Enums", 1, 0, "ToolVisibilityStatus", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::ToolVerifyingStatus>("cranial::types::ToolVerifyingStatus");
    qmlRegisterUncreatableType<cranial::types::ToolVerifyingStatusClass>(
        "Enums", 1, 0, "ToolVerifyingStatus", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::InstrumentVerificationElementTypes>(
        "cranial::types::InstrumentVerificationElementTypes");
    qmlRegisterUncreatableType<cranial::types::InstrumentVerificationElementTypesClass>(
        "Enums", 1, 0, "InstrumentVerificationElementTypes", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::ReachabilityStatus>("ReachabilityStatus");
    qmlRegisterUncreatableType<cranial::types::ReachabilityStatusClass>(
        "Enums", 1, 0, "ReachabilityStatus", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::EndEffectorConnectionState>(
        "cranial::types::EndEffectorConnectionState");
    qmlRegisterUncreatableType<cranial::types::EndEffectorConnectionClass>(
        "Enums", 1, 0, "EndEffectorConnectionState", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::EndEffectorToolState>("cranial::types::EndEffectorToolState");
    qmlRegisterUncreatableType<cranial::types::EndEffectorToolClass>(
        "Enums", 1, 0, "EndEffectorToolState", "Unable to instantiate enum");

    qRegisterMetaType<procd::common::types::fluoro::StreamStatus>(
        "procd::common::types::fluoro::StreamStatus");
    qmlRegisterUncreatableType<procd::common::types::fluoro::StreamStatusClass>(
        "Enums", 1, 0, "FluoroStreamStatus", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::NavigateState>("cranial::types::NavigateState");
    qmlRegisterUncreatableType<cranial::types::NavigateStateClass>(
        "NavigateState", 1, 0, "NavigateState", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::RegTransferState>("cranial::types::RegTransferState");
    qmlRegisterUncreatableType<cranial::types::RegTransferStatesClass>(
        "RegTransferState", 1, 0, "RegTransferState", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::CalculatorSm>("cranial::types::CalculatorSm");
    qmlRegisterUncreatableType<cranial::types::CalculatorSmClass>(
        "CalculatorSm", 1, 0, "CalculatorSm", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::CalculatorButtonType>("cranial::types::CalculatorButtonType");
    qmlRegisterUncreatableType<cranial::types::CalculatorButtonClass>(
        "CalculatorButtonType", 1, 0, "CalculatorButtonType", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::Cad2DRenderTypes>("cranial::types::Cad2DRenderTypes");
    qmlRegisterUncreatableType<cranial::types::Cad2DRenderTypesClass>(
        "Cad2DRenderTypes", 1, 0, "Cad2DRenderTypes", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::Cad3DRenderTypes>("cranial::types::Cad3DRenderTypes");
    qmlRegisterUncreatableType<cranial::types::Cad3DRenderTypesClass>(
        "Cad3DRenderTypes", 1, 0, "Cad3DRenderTypes", "Unable to instantiate enum");

    qRegisterMetaType<cranial::types::RegistrationType>("cranial::types::RegistrationType");

    qRegisterMetaType<procd::common::types::fluoro::FixtureDiameter>(
        "procd::common::types::fluoro::FixtureDiameter");

    qRegisterMetaType<procd::common::types::fluoro::FluoroCaptureType>(
        "procd::common::types::fluoro::FluoroCaptureType");

    qRegisterMetaType<cranial::types::PatRegSelectPageState>(
        "cranial::types::PatRegSelectPageState");
    qmlRegisterUncreatableType<cranial::types::PatRegSelectPageStateClass>(
        "PatRegSelectPageState", 1, 0, "PatRegSelectPageState", "Unable to instantiate enum");
}

void CranialPluginGui::onDriveCaseDataUpdate(const DriveCaseData& driveCaseData)
{
    m_driveCaseData = driveCaseData;

    auto importedScanIds = std::shared_ptr<gm::arch::ICollection<ScanId>>{
        gm::arch::transform_to<ScanId>(gm::arch::createDictionary(m_driveCaseData.caseSeries),
                                       [](auto&& valuePair) { return GM_FWD(valuePair).first; })};

    auto localScans = module::scanmanager::localScanManager(
        m_scanManager,
        drive::common::PatientName::fromDicomFullName(m_driveCaseData.patientData.fullName)
            .toAbbreviated()
            .toStdString(),
        m_reachableScanIds);

    m_importViewModelSource->setVolumeImportSources({m_scanManager, localScans});
    m_importViewModelSource->setDestinationFilter(
        module::scanmanager::LocalScanFilter{importedScanIds});
}

void CranialPluginGui::showLoadingAlert()
{
    if (!m_loadingAlertOpt.has_value())
    {
        auto managedAlert = cranial::alerts::LoadingAlertFactory::createInstance();
        m_loadingAlertOpt = managedAlert->alert();
        m_alertManager->createAlert(m_loadingAlertOpt.value());
    }
}

void CranialPluginGui::hideLoadingAlert()
{
    if (m_loadingAlertOpt.has_value())
    {
        m_alertManager->clearAlert(m_loadingAlertOpt.value());
        m_loadingAlertOpt = std::nullopt;
    }
}

void CranialPluginGui::showCaseDriveDifferentAlert()
{
    auto managedAlert = cranial::alerts::CaseDriveDifferentAlertFactory::createInstance();
    // m_loadingAlertOpt = managedAlert->alert();
    m_alertManager->createAlert(managedAlert->alert());
}

std::optional<DriveCaseData> CranialPluginGui::compareDriveAppData(DriveCaseData dataFromDrive,
                                                                   DriveCaseData dataFromApp)
{
    auto compare = dataFromDrive.caseSeries.size() == dataFromApp.caseSeries.size() &&
                   std::equal(dataFromDrive.caseSeries.begin(), dataFromDrive.caseSeries.end(),
                              dataFromApp.caseSeries.begin(),
                              [](auto a, auto b) { return a.first == b.first; });

    if (compare)
    {
        return compareDriveCaseData(dataFromDrive);
    }
    else
    {
        if (dataFromDrive.caseSeries.size() < dataFromApp.caseSeries.size())
        {
            SYS_LOG_WARN("Case data has more scans than drive data");
            return std::nullopt;
        }
        else
        {
            for (const auto& [key, value] : dataFromApp.caseSeries)
            {
                if (dataFromDrive.caseSeries.find(key) == nullptr)
                {
                    SYS_LOG_WARN("Case data has different series than drive data");
                    return std::nullopt;
                }
            }

            SYS_LOG_WARN("Drive data has more scans than case data");
            dataFromDrive.caseSeries = dataFromApp.caseSeries;


            return compareDriveCaseData(dataFromDrive);
        }
    }
}

std::optional<DriveCaseData> CranialPluginGui::compareDriveCaseData(DriveCaseData dataFromDrive)
{
    DriveCaseData resultDriveData = dataFromDrive;

    // Compare that all drive series are in the case volumes
    for (const auto& [key, value] : dataFromDrive.caseSeries)
    {
        if (!cranial::atoms::isVolumeInCase(gm::util::typeconv::convert<QUuid>(key.id)))
        {
            SYS_LOG_WARN(
                "Series {} is not in the case, deleting series from "
                "drive",
                key.id);
            resultDriveData.caseSeries = resultDriveData.caseSeries.erase(key);
        }
    }

    // Compare that all case volumes are in the drive series
    auto allVolumesIds = cranial::atoms::getVolumesInCase();
    for (const auto& volumeId : allVolumesIds)
    {
        bool found = false;

        for (const auto& [key, value] : dataFromDrive.caseSeries)
        {
            if (volumeId == gm::util::typeconv::convert<QUuid>(key.id))
            {
                found = true;
                break;
            }
        }

        if (!found)
        {
            SYS_LOG_WARN("Case series {} is not in drive", volumeId);
            return std::nullopt;
        }
    }

    return resultDriveData;
};
