#include <spineplugin/SpinePluginGui.h>
#include <spineplugin/manifest.h>

#include <ImFusion/Base/HistogramDataComponent.h>
#include <imfusionrendering/ImFusionTools.h>

// XR Source Factories
#include <gos/xr/CaseDataSourceFactory.h>
#include <gos/xr/ImplantPlansSourceFactory.h>
#include <gos/xr/MeshProviderSourceFactory.h>
#include <gos/xr/NavigatedInstrumentSourceFactory.h>
#include <gos/xr/PatientRegistrationSourceFactory.h>
#include <gos/xr/StreamControlsSourceFactory.h>
#include <gos/xr/WorkflowSourceFactory.h>
#include <gos/xr/XrControlsSourceFactory.h>
#include <gos/xr/XrListenerFactory.h>
#include <service/glink/node/NodeFactory.h>

// Types
#include <procd/spine/types/TrackedToolTypes.h>
#include <procd/common/types/FluoroTypes.h>
#include <procd/spine/types/AppPageTypes.h>
#include <procd/spine/types/IctSnapshotStatesTypes.h>
#include <procd/spine/types/IctImageStatesTypes.h>
#include <procd/spine/types/IctFiducialStatesTypes.h>
#include <procd/spine/types/IctLandmarksStatesTypes.h>
#include <procd/spine/types/CalculatorSmTypes.h>
#include <procd/spine/types/CalculatorButtonTypes.h>
#include <procd/spine/types/PlanStatesTypes.h>
#include <procd/spine/types/CadRenderTypes.h>
#include <procd/spine/types/RegCategoryTypes.h>

#include <procd/spine/algos/patreg2d3d/PatReg2d3dTypes.h>

// Managers
#include <procd/common/grpc/imageimport/ImageImportGrpcService.hpp>
#include <procd/spine/managers/AccTestManager.h>
#include <procd/spine/managers/AlertManager.h>
#include <procd/spine/managers/FootPedalManager.h>
#include <procd/spine/managers/IocManager.h>
#include <procd/spine/managers/LoadCellManager.h>
#include <procd/spine/managers/MotionSessionManager.h>
#include <procd/spine/managers/ToolboxManager.h>
#include <procd/spine/managers/TransformationManager.h>
#include <procd/spine/managers/SurgeonSettingsManager.h>
#include <procd/spine/managers/ReachabilityManager.h>
#include <procd/spine/managers/DraggedCadManager.h>
#include <procd/spine/managers/EndEffectorManager.h>
#include <procd/spine/managers/SurveillanceMarkerManager.h>
#include <procd/spine/managers/SurveillanceMarkerMeterManager.h>
#include <procd/spine/managers/GpsMotionManager.h>
#include <procd/spine/managers/ActiveInstrumentManager.h>
#include <procd/spine/managers/CameraViewManager.h>
#include <procd/spine/managers/FeaturesManager.h>
#include <procd/spine/managers/FluoroCtCaptureCarmManager.h>
#include <procd/spine/managers/FluoroCtCaptureGisManager.h>
#include <procd/spine/managers/E3dManager.h>
#include <procd/spine/managers/ShotCaptureManager.h>
#include <procd/spine/managers/LoadedCasePairingsManager.h>
#include <procd/spine/managers/SoundManager.h>
#include <procd/spine/managers/WindowLevelManager.h>
#include <procd/spine/managers/ImplantDetailsManager.h>

// Services
#include <procd/spine/services/ActiveToolService.h>
#include <procd/spine/services/CasePairingsSyncService.h>
#include <procd/spine/services/EndEffectorVerificationService.h>
#include <procd/spine/services/FluoroCTViewportService.h>
#include <procd/spine/services/IctMaskingService.h>
#include <procd/spine/services/ImFusionVolumeService.h>
#include <procd/spine/services/ImFusionIctFiducialsService.h>
#include <procd/spine/services/ImFusionImplantService.h>
#include <procd/spine/services/ImFusionMeshService.h>
#include <procd/spine/services/ImFusionInstrumentPlanningService.h>
#include <procd/spine/services/ImFusionTooltipImplantService.h>
#include <procd/spine/services/ImFusionTooltipLineService.h>
#include <procd/spine/services/ImFusionTrackedToolService.h>
#include <procd/spine/services/ImFusionCalFixtureFiducialService.h>
#include <procd/spine/services/TaskService.h>

#include <procd/spine/services/TransformE3dRegService.h>
#include <procd/spine/services/TransformImplantService.h>
#include <procd/spine/services/TransformSubVolumeService.h>
#include <procd/spine/services/TransformRefElementPairingService.h>
#include <procd/spine/services/TransformTrackedToolService.h>
#include <procd/spine/services/TransformVolumeService.h>
#include <procd/spine/services/TransformVolumeMergeService.h>

#include <procd/spine/services/ToolVerificationService.h>
#include <procd/spine/services/MleeUnverifiedAlertService.h>
#include <procd/spine/services/MotionLockingService.h>
#include <procd/spine/services/MotionSessionAlertService.h>
#include <procd/spine/services/MotionSessionService.h>
#include <procd/spine/services/PatientRegistrationIctService.h>
#include <procd/spine/services/PatientRegistrationIctNotTransferredService.h>
#include <procd/spine/services/PatientRegistrationFluoroCtService.h>
#include <procd/spine/services/PersistenceService.h>
#include <procd/spine/services/PreOpAlertService.h>
#include <procd/spine/services/ReachabilityService.h>
#include <procd/spine/services/Reg2d3dService.h>
#include <procd/spine/services/RenderRefService.h>
#include <procd/spine/services/SubVolumeSyncService.h>
#include <procd/spine/services/TrajectoryOffsetService.h>
#include <procd/spine/services/TrajectoryReachedSoundService.h>
#include <procd/spine/services/VertebralLevelSyncService.h>
#include <procd/spine/services/ViewPositionToolFollowingService.h>
#include <procd/spine/services/ViewportStreamingService.h>
#include <procd/spine/services/DriveCaseDataSyncService.h>

#ifdef GM_ENABLE_SPINE_GRPC
#include <procd/spine/grpcservices/GrpcServiceFactory.hpp>
#include <procd/spine/tools/VolumeImportCallbacks.hpp>
#include <procd/common/grpc/imageimport/ImageImportGrpcService.hpp>
#endif

// Viewmodels
#include <procd/spine/viewmodels/PatRegSelectViewModel.h>
#include <procd/spine/viewmodels/IctImageViewModel.h>
#include <procd/spine/viewmodels/IctGetSnapshotViewModel.h>
#include <procd/spine/viewmodels/IctFiducialViewModel.h>
#include <procd/spine/viewmodels/IctLandmarksViewModel.h>
#include <procd/spine/viewmodels/ApplicationViewModel.h>
#include <procd/spine/viewmodels/MergeViewModel.h>
#include <procd/spine/viewmodels/VolumeListViewModel.h>
#include <procd/spine/viewmodels/OrientationOverlayViewModel.h>
#include <procd/spine/viewmodels/TrackingCrosshairOverlayViewModel.h>
#include <procd/spine/viewmodels/MeasurementOverlayViewModel.h>
#include <procd/spine/viewmodels/ViewLabelOverlayViewModel.h>
#include <procd/spine/viewmodels/ImplantControlsOverlayViewModel.h>
#include <procd/spine/viewmodels/CheckerboardOverlayViewModel.h>
#include <procd/spine/viewmodels/WindowLevelOverlayViewModel.h>

#include <procd/spine/viewmodels/IctFiducialOverlayViewModel.h>
#include <procd/spine/viewmodels/CalculatorViewModel.h>
#include <procd/spine/viewmodels/RegistrationResetViewModel.h>
#include <procd/spine/viewmodels/ImageDetailsViewModel.h>
#include <procd/spine/viewmodels/ImportPopupLoaderViewModel.h>
#include <procd/spine/viewmodels/OverlayViewModel.h>
#include <procd/spine/viewmodels/TopbarViewModel.h>
#include <procd/spine/viewmodels/ViewportListViewModel.h>
#include <procd/spine/viewmodels/ViewportToolsViewModel.h>
#include <procd/spine/viewmodels/FluoroImplantControlsOverlayViewModel.h>
#include <procd/spine/viewmodels/FluoroRegistrationMarkersOverlayViewModel.h>
#include <procd/spine/viewmodels/IndependentTrajectoryControlsViewModel.h>
#include <procd/spine/viewmodels/NavigationTrackingModeViewModel.h>
#include <procd/spine/viewmodels/View2DCoordinateSystemViewModel.h>
#include <procd/spine/viewmodels/View2DOrientationViewModel.h>
#include <procd/spine/viewmodels/View2DOrientationTypeViewModel.h>
#include <procd/spine/viewmodels/SliceSliderOverlayViewModel.h>
#include <procd/spine/viewmodels/CaseSetupCaseNameViewModel.h>
#include <procd/spine/viewmodels/CaseSetupCategorySelectViewModel.h>
#include <procd/spine/viewmodels/PageStateViewModel.h>
#include <procd/spine/viewmodels/CaseSetupSpineModelViewModel.h>
#include <procd/spine/viewmodels/CameraViewViewModel.h>
#include <procd/spine/viewmodels/StandardNavVerificationPanelViewModel.h>
#include <procd/spine/viewmodels/ActiveRefElementSetViewModel.h>
#include <procd/spine/viewmodels/PairingPopupHeaderViewModel.h>
#include <procd/spine/viewmodels/SwappablePairingsViewModel.h>
#include <procd/spine/viewmodels/ToolFilterViewModel.h>
#include <procd/spine/viewmodels/ToolsListDetailsViewModel.h>
#include <procd/spine/viewmodels/ToolsListViewModel.h>
#include <procd/spine/viewmodels/SidebarTabBarViewModel.h>
#include <procd/spine/viewmodels/MergeToolsViewModel.h>
#include <procd/spine/viewmodels/SlabRenderingOverlayViewModel.h>
#include <procd/spine/viewmodels/ImportToPlanOverlayViewModel.h>

#include <procd/spine/viewmodels/AddImplantSystemViewModel.h>
#include <procd/spine/viewmodels/CaseImplantSystemViewModel.h>
#include <procd/spine/viewmodels/VerificationProgressOverlayViewModel.h>
#include <procd/spine/viewmodels/ImplantDetailsPanelViewModel.h>
#include <procd/spine/viewmodels/ImplantListViewModel.h>
#include <procd/spine/viewmodels/ImplantsFlippedViewModel.h>
#include <procd/spine/viewmodels/InstrumentPlanningControlsViewModel.h>
#include <procd/spine/viewmodels/NavigateImplantDetailsViewModel.h>
#include <procd/spine/viewmodels/TrackingBarViewModel.h>
#include <procd/spine/viewmodels/ImplantPlacedPopupViewModel.h>
#include <procd/spine/viewmodels/ViewportBorderViewModel.h>
#include <procd/spine/viewmodels/ShotGalleryViewModel.h>
#include <procd/spine/viewmodels/ShotAssignViewportViewModel.h>
#include <procd/spine/viewmodels/CaptureAnatomyListViewModel.h>
#include <procd/spine/viewmodels/VerifyAnatomyListViewModel.h>
#include <procd/spine/viewmodels/ShotCentroidOverlayViewModel.h>
#include <procd/spine/viewmodels/ShotInfoOverlayViewModel.h>
#include <procd/spine/viewmodels/ImageToolsViewModel.h>
#include <procd/spine/viewmodels/DraggedCadViewModel.h>
#include <procd/spine/viewmodels/CadDropAreaOverlayViewModel.h>
#include <procd/spine/viewmodels/ActiveToolNotVisibleOverlayViewModel.h>
#include <procd/spine/viewmodels/NavigationTipsViewModel.h>
#include <procd/spine/viewmodels/E3dSetupViewModel.h>
#include <procd/spine/viewmodels/E3dImageViewModel.h>
#include <procd/spine/viewmodels/E3dLandmarksViewModel.h>
#include <procd/spine/viewmodels/DriverSelectionViewModel.h>
#include <procd/spine/viewmodels/AccuracyTest2dOverlayViewModel.h>
#include <procd/spine/viewmodels/IctFiducialDropOverlayViewModel.h>
#include <procd/spine/viewmodels/OffsetMeterViewModel.h>
#include <procd/spine/viewmodels/PowerToolDetailsViewModel.h>
#include <procd/spine/viewmodels/PowerToolsPairingsViewModel.h>
#include <procd/spine/viewmodels/ExcessiveDeflectionOverlayViewModel.h>
#include <procd/spine/viewmodels/AutoScanImporterViewModel.h>
#include <procd/spine/viewmodels/XrViewModel.h>

// Propertysources

#include <procd/spine/propertysources/statemachines/IctFiducialPageStateMachinePropSource.h>
#include <procd/spine/propertysources/statemachines/IctImagePageStateMachinePropSource.h>
#include <procd/spine/propertysources/statemachines/IctLandmarksPageStateMachinePropSource.h>
#include <procd/spine/propertysources/statemachines/IctSnapshotPageStateMachinePropSource.h>

#include <procd/spine/propertysources/statemachines/PageStateMachinePropSource.h>

#include <procd/spine/propertysources/ActiveViewportSetPropertySource.h>
#include <procd/spine/propertysources/EndEffectorPropertySource.h>
#include <procd/spine/propertysources/FluoroCtPropertySource.h>
#include <procd/spine/propertysources/PatRefPropertySource.h>
#include <procd/spine/propertysources/FluoroSetupPropertySource.h>
#include <procd/spine/propertysources/CasePropertySource.h>
#include <procd/spine/propertysources/VolumeTreePropertySource.h>
#include <procd/spine/propertysources/AppDataPropertySource.h>
#include <procd/spine/propertysources/ImplantListPropertySource.h>
#include <procd/spine/propertysources/MeshPropertySource.h>
#include <procd/spine/propertysources/CameraViewTrackerPropertySource.h>
#include <procd/spine/propertysources/E3DWorkflowPropertySource.h>
#include <procd/spine/propertysources/InstrumentPlanningPropertySource.h>
#include <procd/spine/propertysources/SpineSurgeryPlanPropertySource.h>
#include <procd/spine/propertysources/CasePairingListPropertySource.h>
#include <procd/spine/propertysources/Reg2dPropertySource.h>
#include <procd/spine/propertysources/SelectedVolumesPropertySource.h>

// Managed by scoped singleton factory
#include <procd/spine/calculatedproperties/ShotItemCalculatedProperty.h>
#include <procd/spine/calculatedproperties/VolItemCalculatedProperty.h>

#include <procd/spine/propertysources/ShotItemPropertySource.h>
#include <procd/spine/propertysources/SubVolBaseItemPropertySource.h>
#include <procd/spine/propertysources/SubVolVertebraItemPropertySource.h>
#include <procd/spine/propertysources/SubVolInterbodyItemPropertySource.h>
#include <procd/spine/propertysources/SubVolSacrumItemPropertySource.h>
#include <procd/spine/propertysources/VolumeItemPropertySource.h>
// end scoped singleton factory

#include <procd/spine/atoms/CaseDataReader.h>

// Calculated Properties
#include <procd/spine/calculatedproperties/LoadedRefCalculatedProperty.h>
#include <procd/spine/calculatedproperties/SelectedImplantSystemCalculatedProperty.h>
#include <procd/spine/calculatedproperties/SelectedImplantTypeCalculatedProperty.h>
#include <procd/spine/calculatedproperties/ArrayPairingCalculatedProperty.h>
#include <procd/spine/calculatedproperties/TrackingPositionCalculatedProperty.h>
#include <procd/spine/calculatedproperties/EndEffectorCalculatedProperty.h>
#include <procd/spine/calculatedproperties/ImplantLeftRightFlippedCalculatedProperty.h>

#include <procd/common/util/tools/log.h>

#include <apps/cranial/backend/VolumeThumbnailProvider.h>
#include <procd/spine/managers/ImFusion2dShotProvider.h>

#include <procd/spine/components/ImageViewport.h>

// Alerts
#include <procd/spine/alerts/TaskCleanupAlertFactory.h>
#include <procd/spine/alerts/LoadingAlertFactory.h>
#include <procd/spine/alerts/CaseDriveDifferentAlertFactory.h>

#include <procd/spine/managers/SpineHotReloadManager.h>
#include <procd/spine/tools/RegisterEnumsHelper.h>
#include <procd/spine/tools/RegisterTypesHelper.hpp>
#include <procd/spine/viewmodels/RegisterViewModelsHelper.hpp>
#include <procd/spine/tools/PathTools.h>

// Misc
#include <imfusionrendering/ImFusionCombinedBBRenderer.h>
#include <drive/common/PatientName.h>
#include <module/scanmanager/LocalScanManager.h>
#include <gm/arch/transform_to.h>
#include <gm/arch/ContainerDictionary.h>
#include <gm/arch/ioc.h>
#include <sys/config/config.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <gm/util/qml/QmlHotReload.h>
#include <gos/gps/endeffectorinfo/EndEffectorInfoProxyFactory.h>
#include <gos/gps/endeffectorinfo/EndEffectorInfoSourceFactory.h>
#include <gos/gps/moveready/MoveReadyProxyFactory.h>
#include <gos/gps/stabilizers/StabilizersProxyFactory.h>
#include <gos/hid/footpedal/FootPedalProxyFactory.h>
#include <gos/services/uaib/UaibCommunicationProxyFactory.h>
#include <sys/log/sys_log.h>
#include <sys/log/imfusion.h>
#include <sys/log/qt.h>
#include <uaibcontroller/UaibAdapterFactory.h>

#include <sys/alerts/AlertManagerFactory.h>
#include <sys/alerts/AlertAggregatorFactory.h>
#include <QQmlContext>

#include <boost/uuid/uuid_io.hpp>
#include <optional>
#include "procd/spine/viewmodels/ImplantControlsOverlayViewModel.h"

/* The constructor should be the minimum possible because it is called by drive
 * "runheader" runs before "runcase", so beware to put inits only in runcase
 * Check the destructor to be sure that all is being destructed correctly (new
 * variables!)
 *
 * */
SpinePluginGui::SpinePluginGui(QObject* parent)
    : QObject(parent)
    , m_gLinkNode(glink::node::NodeFactory::createInstance())
    , m_armMotion(gos::motion::armmotion::ArmMotionSessionManagerProxyFactory::createInstance<
                  gm::algo::robot::gps::RobotTraits>(
          m_gLinkNode, gos::roles::motion::armmotion::ArmMotionSessionManagerRole))
    , m_armReachability(gos::motion::armmotion::ArmReachabilityProxyFactory::createInstance(
          m_gLinkNode, gos::roles::motion::armmotion::ArmReachabilityRole))
    , m_sh(gos::nav::SensorHubProxyFactory::createInstance(m_gLinkNode))
    , m_uaibController(gos::services::uaib::UaibCommunicationProxyFactory::createInstance(
          m_gLinkNode, gos::services::uaib::UaibAdapterFactory::OBJECT_ID))
    , m_alertManager(sys::alerts::AlertManagerFactory::createInstance())
    , m_headsetFeedManager(std::make_shared<spine::gateways::HeadsetFeedManager>(m_gLinkNode))
    , m_alertView([&] {
        auto aggregator = sys::alerts::AlertAggregatorFactory::createInstance();
        aggregator->addAlertView(m_alertManager);
        return aggregator;
    }())

{
    SYS_LOG_INFO("Spine plugin created");
}

// Class for adapting an image provider that you also want to use in IOC / a shared pointer context
class ImageAdapter : public QQuickImageProvider
{
public:
    explicit ImageAdapter(std::shared_ptr<QQuickImageProvider> provider)
        : QQuickImageProvider(QQmlImageProviderBase::Image)
        , m_underlier(provider)
    {}

    QImage requestImage(const QString& id, QSize* size, const QSize& requestedSize)
    {
        return m_underlier->requestImage(id, size, requestedSize);
    }

private:
    std::shared_ptr<QQuickImageProvider> m_underlier;
};

void SpinePluginGui::cleanupTasks()
{
    auto taskService = spine::iocmanager::resolveContainer<spine::services::TaskService>();
    taskService->quitSignalAllTasks();
    auto alert = spine::alerts::TaskCleanupAlertFactory::createInstance();
    auto alertManager = spine::iocmanager::resolveContainer<spine::managers::AlertManager>();
    if (taskService->ongoingTaskCount() > 0)
    {
        alertManager->registerAlert(alert);
    }
    taskService->cleanupTasks();
    alertManager->clearAlert(alert->alert());
}

SpinePluginGui::~SpinePluginGui()
{
    SYS_LOG_INFO("Destroying Spine plugin...");

    // Guarantee that all objects depending on IOC are destroyed prior to IOC reset
    for (auto&& service : m_services)
    {
        service.reset();
    }
    m_surveillanceMarkerActivationAlertService.reset();
    m_caseSensorhubLoggingService.reset();
    m_featuresManager.reset();

    spine::iocmanager::reset();

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
    SYS_LOG_INFO("Spine plugin destroyed");
}

namespace {
// Registers a single instance factory of objects of the given type using the given factory type
// and for the given role
template <typename RegisteredT, typename FactoryT>
void registerSingleInstanceForRole(auto& builder, std::string_view role)
{
    builder
        ->registerInstanceFactory([role](auto& ctx) -> std::shared_ptr<RegisteredT> {
            const auto gLinkNode = ctx.template resolve<glink::node::INode>();
            return FactoryT::createInstance(gLinkNode, role);
        })
        .singleInstance();
};

// Resolves all the provided types
template <typename... T>
void resolveAll()
{
    (spine::iocmanager::resolveContainer<T>(), ...);
}

}  // namespace

bool xrEnabled(std::shared_ptr<spine::managers::FeaturesManager> featuresManager)
{
    auto& platform = sys::config::Config::instance()->platform;
    return (platform.systemType() == sys::config::SystemType::Ehub && featuresManager &&
            featuresManager->isFeatureEnabled(XR_LICENSE));
}

void SpinePluginGui::createBuilder(
    std::shared_ptr<spine::managers::FeaturesManager> featuresManager,
    drive::model::SurgeonIdentifier surgeonId)
{
    auto builder = std::make_shared<gm::arch::ioc::ContainerBuilder>();

    // Register member instances already created
    builder->registerInstance(m_alertManager);
    builder->registerInstance(m_armMotion);
    builder->registerInstance(m_armReachability);
    builder->registerInstance(m_gLinkNode);
    builder->registerInstance(m_scanManager);
    builder->registerInstance(m_sh);
    builder->registerInstance(m_uaibController);
    builder->registerInstance(m_headsetFeedManager);
    builder->registerInstance(featuresManager);


    if (xrEnabled(featuresManager))
    {
        registerXrGatewaysIoc(builder);
    }

    if (spine::viewmodels::ApplicationViewModel::testModeEnabled())
    {
        builder->registerInstance(std::make_shared<spine::managers::AccTestManager>());
    }
    builder
        ->registerType<
            spine::propertysources::statemachines::IctSnapshotPageStateMachinePropSource>()
        .singleInstance();
    builder
        ->registerType<spine::propertysources::statemachines::IctImagePageStateMachinePropSource>()
        .singleInstance();
    builder
        ->registerType<
            spine::propertysources::statemachines::IctFiducialPageStateMachinePropSource>()
        .singleInstance();
    builder
        ->registerType<
            spine::propertysources::statemachines::IctLandmarksPageStateMachinePropSource>()
        .singleInstance();
    builder->registerType<spine::propertysources::statemachines::PageStateMachinePropSource>()
        .singleInstance();
    builder->registerType<spine::propertysources::MeshPropertySource>().singleInstance();
    // Register singletons
    builder->registerType<spine::atoms::AtomOwner>().singleInstance();
    builder->registerType<spine::managers::ToolboxManager>().singleInstance();
    builder->registerType<spine::managers::TransformationManager>().singleInstance();

    builder
        ->registerInstanceFactory([surgeonId](auto& ctx [[maybe_unused]]) {
            return std::make_shared<spine::managers::SurgeonSettingsManager>(surgeonId);
        })
        .singleInstance();

    builder->registerType<spine::managers::AlertManager>().singleInstance();
    builder->registerType<spine::managers::ReachabilityManager>().singleInstance();

    registerSingleInstanceForRole<gos::itf::gps::IEndEffectorInfo,
                                  gos::gps::endeffectorinfo::EndEffectorInfoProxyFactory>(
        builder, gos::roles::gps::endeffectorinfo::EndEffectorInfoRole);
    registerSingleInstanceForRole<gos::itf::gps::IMoveReady,
                                  gos::gps::moveready::MoveReadyProxyFactory>(
        builder, gos::roles::gps::moveready::MoveReadyRole);
    builder->registerInstance<gos::itf::gps::IStabilizers>(
        gos::gps::stabilizers::StabilizersProxyFactory::createInstance(
            m_gLinkNode, gos::roles::gps::stabilizers::StabilizersRole));
    registerSingleInstanceForRole<gos::itf::hid::IFootPedal,
                                  gos::hid::footpedal::FootPedalProxyFactory>(
        builder, gos::roles::hid::footpedal::FootPedalRole);

    builder->registerType<spine::propertysources::ActiveViewportSetPropertySource>()
        .singleInstance();
    builder->registerType<spine::propertysources::EndEffectorPropertySource>().singleInstance();
    builder->registerType<spine::propertysources::FluoroCtPropertySource>().singleInstance();
    builder->registerType<spine::propertysources::PatRefPropertySource>().singleInstance();
    builder->registerType<spine::propertysources::RenderModelPropertySource>().singleInstance();
    builder->registerType<spine::propertysources::AppDataPropertySource>().singleInstance();
    builder->registerType<spine::propertysources::SelectedVolumesPropertySource>().singleInstance();
    builder->registerType<spine::services::TaskService>().singleInstance();
    builder->registerType<spine::propertysources::IctWorkflowPropertySource>().singleInstance();

    builder->registerType<spine::propertysources::FluoroCtPropertySource>().singleInstance();
    builder->registerType<spine::propertysources::FluoroSetupPropertySource>().singleInstance();
    builder->registerType<spine::propertysources::CasePropertySource>().singleInstance();
    builder->registerType<spine::propertysources::ImplantListPropertySource>().singleInstance();
    builder->registerType<spine::propertysources::CameraViewTrackerPropertySource>()
        .singleInstance();
    builder->registerType<spine::propertysources::E3DWorkflowPropertySource>().singleInstance();
    builder->registerType<spine::propertysources::InstrumentPlanningPropertySource>()
        .singleInstance();
    builder->registerType<spine::propertysources::SpineSurgeryPlanPropertySource>()
        .singleInstance();
    builder->registerType<spine::propertysources::CasePairingListPS>().singleInstance();
    builder->registerType<spine::propertysources::Reg2dPropertySource>().singleInstance();

    builder->registerType<spine::propertysources::VolumeTreePropertySource>().singleInstance();

    builder->registerType<spine::viewmodels::ApplicationViewModel>().singleInstance();

    builder->registerType<spine::managers::SoundManager>().singleInstance();
    builder->registerType<spine::managers::FluoroCtCaptureCarmManager>().singleInstance();
    builder->registerType<spine::managers::FluoroCtCaptureGisManager>().singleInstance();
    builder->registerType<spine::managers::E3dManager>().singleInstance();
    builder->registerType<spine::managers::FootPedalManager>().singleInstance();
    builder->registerType<spine::managers::WindowLevelManager>().singleInstance();
    builder->registerType<spine::managers::MotionSessionManager>().singleInstance();
    builder->registerType<spine::managers::DraggedCadManager>().singleInstance();
    builder->registerType<spine::managers::GpsMotionManager>().singleInstance();
    builder->registerType<spine::managers::ActiveInstrumentManager>().singleInstance();
    builder->registerType<spine::managers::CameraViewManager>().singleInstance();

    builder->registerType<spine::calculatedproperties::LoadedRefCalcPS>().singleInstance();

    builder->registerType<spine::managers::LoadedCasePairingsManager>().singleInstance();
    builder->registerType<spine::managers::ImplantDetailsManager>().singleInstance();
    builder->registerType<spine::calculatedproperties::TrackingPositionCalculatedProperty>()
        .singleInstance();
    builder->registerType<spine::calculatedproperties::EndEffectorCalcPs>().singleInstance();
    builder->registerType<spine::calculatedproperties::SelectedImplantSystemCalcPS>()
        .singleInstance();
    builder->registerType<spine::calculatedproperties::SelectedImplantTypeCalcPS>()
        .singleInstance();
    builder->registerType<spine::calculatedproperties::ArrayPairingCalcPS>().singleInstance();
    builder->registerType<spine::calculatedproperties::ImplantLeftRightFlippedCalculatedProperty>()
        .singleInstance();

    builder->registerType<spine::managers::SurveillanceMarkerManager>().singleInstance();
    builder->registerType<spine::managers::SurveillanceMarkerMeterManager>().singleInstance();
    builder->registerType<spine::managers::EndEffectorManager>().singleInstance();

    builder->registerType<spine::managers::ShotCaptureManager>().singleInstance();

    builder->registerType<spine::managers::LoadCellManager>().singleInstance();
    builder
        ->registerType<
            gm::arch::ioc::ScopedSingletonFactory<spine::propertysources::ShotItemPropertySource>>()
        .singleInstance();
    builder
        ->registerType<gm::arch::ioc::ScopedSingletonFactory<
            spine::calculatedproperties::ShotItemCalculatedProperty>>()
        .singleInstance();

    builder
        ->registerType<gm::arch::ioc::ScopedSingletonFactory<
            spine::propertysources::VolumeItemPropertySource>>()
        .singleInstance();
    builder
        ->registerType<
            gm::arch::ioc::ScopedSingletonFactory<spine::calculatedproperties::VolItemCalcPS>>()
        .singleInstance();
    builder
        ->registerType<
            gm::arch::ioc::ScopedSingletonFactory<spine::propertysources::SubVolBaseItemPS>>()
        .singleInstance();
    builder
        ->registerType<
            gm::arch::ioc::ScopedSingletonFactory<spine::propertysources::SubVolVertebraItemPS>>()
        .singleInstance();
    builder
        ->registerType<
            gm::arch::ioc::ScopedSingletonFactory<spine::propertysources::SubVolInterbodyItemPS>>()
        .singleInstance();
    builder
        ->registerType<
            gm::arch::ioc::ScopedSingletonFactory<spine::propertysources::SubVolSacrumItemPS>>()
        .singleInstance();

    builder->registerType<drive::scanimport::ImportViewModelSource>().singleInstance();
    builder->registerType<spine::managers::SpineImportManager>().singleInstance();

    spine::iocmanager::buildContainer(builder);

// https://jira.globusmedical.com/browse/SPINE-3279 this may not be needed indefinitely
#ifdef GM_ENABLE_SPINE_GRPC
    runSpineServer();
#endif

    m_alertView->addAlertView(
        spine::iocmanager::resolveContainer<spine::managers::FluoroCtCaptureCarmManager>()
            ->getAlertView());
    m_alertView->addAlertView(
        spine::iocmanager::resolveContainer<drive::scanimport::ImportViewModelSource>()
            ->getAlertView());

    // For now all the singleton types are resolved to ensure they are created
    // The list of types can be greatly limited to avoid explicit resolution of types that are
    // dependencies of other types
    // This, however, requires more analysis
    resolveAll<spine::atoms::AtomOwner,  //
               spine::managers::ToolboxManager,  //
               spine::managers::TransformationManager,  //
               spine::managers::SurgeonSettingsManager,  //
               spine::managers::AlertManager,  //
               spine::managers::ReachabilityManager,  //
               gos::itf::gps::IEndEffectorInfo,  //
               gos::itf::gps::IMoveReady,  //
               gos::itf::hid::IFootPedal,  //
               spine::propertysources::ActiveViewportSetPropertySource,  //
               spine::propertysources::EndEffectorPropertySource,  //
               spine::propertysources::FluoroCtPropertySource,  //
               spine::propertysources::PatRefPropertySource,  //
               spine::propertysources::RenderModelPropertySource,  //
               spine::propertysources::AppDataPropertySource,  //
               spine::propertysources::SelectedVolumesPropertySource,  //
               spine::services::TaskService,  //
               spine::propertysources::IctWorkflowPropertySource,  //
               spine::propertysources::FluoroCtPropertySource,  //
               spine::propertysources::FluoroSetupPropertySource,  //
               spine::propertysources::CasePropertySource,  //
               spine::propertysources::ImplantListPropertySource,  //
               spine::propertysources::CameraViewTrackerPropertySource,  //
               spine::propertysources::E3DWorkflowPropertySource,  //
               spine::propertysources::InstrumentPlanningPropertySource,  //
               spine::propertysources::SpineSurgeryPlanPropertySource,  //
               spine::propertysources::CasePairingListPS,  //
               spine::propertysources::Reg2dPropertySource,  //
               spine::propertysources::VolumeTreePropertySource,  //
               spine::viewmodels::ApplicationViewModel,  //
               spine::managers::SoundManager,  //
               spine::managers::FluoroCtCaptureCarmManager,  //
               spine::managers::FluoroCtCaptureGisManager,  //
               spine::managers::E3dManager,  //
               spine::managers::FootPedalManager,  //
               spine::managers::WindowLevelManager,  //
               spine::managers::MotionSessionManager,  //
               spine::managers::DraggedCadManager,  //
               spine::managers::GpsMotionManager,  //
               spine::managers::ActiveInstrumentManager,  //
               spine::managers::CameraViewManager,  //
               spine::calculatedproperties::LoadedRefCalcPS,  //
               spine::managers::LoadedCasePairingsManager,  //
               spine::managers::ImplantDetailsManager,  //
               spine::calculatedproperties::TrackingPositionCalculatedProperty,  //
               spine::calculatedproperties::EndEffectorCalcPs,  //
               spine::calculatedproperties::SelectedImplantSystemCalcPS,  //
               spine::calculatedproperties::SelectedImplantTypeCalcPS,  //
               spine::calculatedproperties::ArrayPairingCalcPS,  //
               spine::calculatedproperties::ImplantLeftRightFlippedCalculatedProperty,  //
               spine::managers::SurveillanceMarkerManager,  //
               spine::managers::SurveillanceMarkerMeterManager,  //
               spine::managers::EndEffectorManager,  //
               spine::managers::ShotCaptureManager,  //
               spine::managers::LoadCellManager,  //
               spine::managers::SpineImportManager>();

    resolveFeatureDependentItems(featuresManager);
}

void SpinePluginGui::createServices(const std::string& caseId)
{
    m_services.emplace_back(
        std::make_unique<spine::services::PatientRegistrationIctNotTransferredService>());
    m_services.emplace_back(std::make_unique<spine::services::PatientRegistrationIctService>());
    m_services.emplace_back(std::make_unique<spine::services::ImFusionVolumeService>());
    m_services.emplace_back(std::make_unique<spine::services::ImFusionTrackedToolService>());
    if (sys::config::Config::instance()->platform.systemMode() == sys::config::SystemMode::Test)
    {
        m_services.emplace_back(
            std::make_unique<spine::services::ImFusionCalFixtureFiducialService>());
    }
    m_services.emplace_back(std::make_unique<spine::services::TransformRefElementPairingService>());
    m_services.emplace_back(std::make_unique<spine::services::TransformTrackedToolService>(m_sh));
    m_services.emplace_back(std::make_unique<spine::services::TransformVolumeService>());
    m_services.emplace_back(std::make_unique<spine::services::TransformVolumeMergeService>());
    m_services.emplace_back(std::make_unique<spine::services::ImFusionImplantService>());
    m_services.emplace_back(std::make_unique<spine::services::ImFusionMeshService>());
    m_services.emplace_back(std::make_unique<spine::services::ImFusionInstrumentPlanningService>());
    m_services.emplace_back(std::make_unique<spine::services::ImFusionTooltipImplantService>());
    m_services.emplace_back(std::make_unique<spine::services::ImFusionTooltipLineService>());
    m_services.emplace_back(std::make_unique<spine::services::TransformImplantService>());
    m_services.emplace_back(
        std::make_unique<spine::services::PatientRegistrationFluoroCtService>());
    m_services.emplace_back(std::make_unique<spine::services::PersistenceService>());
    m_services.emplace_back(std::make_unique<spine::services::ToolVerificationService>());
    m_services.emplace_back(std::make_unique<spine::services::TransformE3dRegService>());
    m_services.emplace_back(std::make_unique<spine::services::CasePairingsSyncService>());
    m_services.emplace_back(std::make_unique<spine::services::MotionSessionService>(m_armMotion));
    m_services.emplace_back(
        std::make_unique<spine::services::ReachabilityService>(m_armReachability));
    m_services.emplace_back(std::make_unique<spine::services::MotionLockingService>(m_armMotion));
    m_services.emplace_back(std::make_unique<spine::services::ImFusionIctFiducialsService>());
    m_services.emplace_back(std::make_unique<spine::services::FluoroCTViewportService>());
    m_services.emplace_back(std::make_unique<spine::services::ViewPositionToolFollowingService>());
    m_services.emplace_back(std::make_unique<spine::services::ActiveToolService>(m_sh));
    m_services.emplace_back(
        std::make_unique<spine::services::MotionSessionAlertService>(m_gLinkNode));
    m_services.emplace_back(std::make_unique<spine::gateways::LoadSensorHubPatternsGateway>(m_sh));

    m_services.emplace_back(std::make_unique<spine::services::TrajectoryOffsetService>());
    m_services.emplace_back(std::make_unique<spine::services::VertebralLevelSyncService>());
    m_services.emplace_back(std::make_unique<spine::services::Reg2d3dService>());
    m_services.emplace_back(std::make_unique<spine::services::EndEffectorVerificationService>());
    m_services.emplace_back(std::make_unique<spine::services::RenderRefService>());
    m_services.emplace_back(std::make_unique<spine::services::SubVolumeSyncService>());
    m_services.emplace_back(std::make_unique<spine::services::IctMaskingService>());
    m_services.emplace_back(std::make_unique<spine::services::PreOpAlertService>());
    m_services.emplace_back(std::make_unique<spine::services::TrajectoryReachedSoundService>());
    m_services.emplace_back(std::make_unique<spine::services::MleeUnverifiedAlertService>());
    m_services.emplace_back(std::make_unique<spine::services::DriveCaseDataSyncService>());

    // These do not inherit QObject and thus must be handled separately
    m_surveillanceMarkerActivationAlertService =
        std::make_unique<spine::services::SurveillanceMarkerActivationAlertService>();
    m_caseSensorhubLoggingService =
        std::make_unique<procd::common::util::services::CaseSensorhubLoggingService>(m_sh, caseId);
}
void SpinePluginGui::createProviders()
{
    // Memory deleted when provider is deleted from the engine
    m_pluginContext->engine()->addImageProvider("volumeThumbnail", new VolumeThumbnailProvider());
    m_pluginContext->engine()->addImageProvider("combinedBB", new ImFusionCombinedBBRenderer());
    m_pluginContext->engine()->addImageProvider("fluoroimage",
                                                new spine::managers::ImFusion2dShotProvider());
    m_pluginContext->engine()->addImageProvider("headsetfeed",
                                                new ImageAdapter(m_headsetFeedManager));
}

void SpinePluginGui::requestQuit()
{
    G_EMIT pluginQuitRequested(spine::plugin::manifest::PLUGIN_SHORT_NAME,
                               [res = m_driveCaseData](auto&&) { return res; });
}

std::string SpinePluginGui::getQmlPath() const
{
    return gm::util::qml::getQmlPath().value_or("qrc:/spine/qml/spine.qml");
}

std::string SpinePluginGui::getHeaderQmlPath() const
{
    return "qrc:/spine/qml/applicationheader/SpineHeader.qml";
}

void SpinePluginGui::runCase(WorkflowCaseId id,
                             DriveCaseData driveData,
                             std::vector<std::string> featureSet,
                             IWorkFlowPluginGui::ReachableScans reachableScans,
                             std::shared_ptr<gos::itf::scanmanager::IScanManager> scanManager,
                             std::shared_ptr<plugin::IPluginShell> shell,
                             drive::model::SurgeonIdentifier surgeonId,
                             std::optional<std::string> surgeonName)
{
    qDebug() << "surgeonId is" << QString::fromStdString(boost::uuids::to_string(surgeonId.id));
    m_surgeonName = surgeonName.value_or("No Name Provided");

    m_driveCaseData = driveData;

    m_scanManager = scanManager;
    m_pluginShellList.push_back(shell);

    m_sh->connect();

    QList<QString> featureSetQt;
    for (const auto& feature : featureSet)
    {
        featureSetQt.push_back(QString::fromStdString(feature));
    }
    m_featuresManager = std::make_shared<spine::managers::FeaturesManager>(featureSetQt);

    if (!m_pluginContext)
    {
        setupContext(shell->getQmlContext());
        createBuilder(m_featuresManager, surgeonId);
    }

    std::string stdCaseId = boost::uuids::to_string(id.id);
    QString caseId = QString::fromStdString(stdCaseId);
    SYS_LOG_INFO("Running case {}", caseId);

    sys::log::redirectQDebugToSysLog();
    sys::log::redirectImFusionLogToSysLog(sys::log::LogLevel::Debug);
    if (spine::viewmodels::ApplicationViewModel::instance().traceLogsEnabled())
    {
        SYS_LOG_INFO("Trace logs enabled from TestFile_GPS.ini");
        sys::log::setMinimumLogLevel(sys::log::LogLevel::Trace);
    }
    else
    {
        sys::log::setMinimumLogLevel(sys::log::LogLevel::Debug);
    }

    createContextProperties();
    spine::viewmodels::ApplicationViewModel::instance().initGmDebug(m_gLinkNode);
    spine::viewmodels::ApplicationViewModel::instance().setPluginContext(m_pluginContext);

    m_reachableScanIds =
        std::shared_ptr<gm::arch::ICollection<ScanId>>{gm::arch::transform_to<ScanId>(
            std::move(reachableScans), [](auto&& valuePair) { return GM_FWD(valuePair).first; })};
    auto importedScanIds = std::shared_ptr<gm::arch::ICollection<ScanId>>{
        gm::arch::transform_to<ScanId>(gm::arch::createDictionary(driveData.caseSeries),
                                       [](auto&& valuePair) { return GM_FWD(valuePair).first; })};
    auto localScans = module::scanmanager::localScanManager(
        scanManager, driveData.patientData.fullName, m_reachableScanIds);

    auto importViewModelSource =
        spine::iocmanager::resolveContainer<drive::scanimport::ImportViewModelSource>();
    importViewModelSource->setDestinationFilter(
        module::scanmanager::LocalScanFilter{importedScanIds});
    importViewModelSource->setDestinationPatient(
        drive::scanimport::patientMatcher(driveData.patientData));

    m_pluginContext->setContextProperty("importViewModelSource", importViewModelSource.get());

    auto spineImportModel =
        spine::iocmanager::resolveContainer<spine::managers::SpineImportManager>();
    spineImportModel->setDestinationPatient(
        drive::scanimport::patientMatcher(driveData.patientData));

    createProviders();

    gm::util::qt::connect(spineImportModel->driveCaseDataUpdateSignal, this,
                          &SpinePluginGui::onDriveCaseDataUpdate);

    // TODO: Temporarily request loading with a delay
    //       Consider a solution with a worker thread to avoid heavy processing
    //       in the main thread
    showLoadingAlert();
    using namespace std::chrono_literals;
    QTimer::singleShot(200ms, this, [this, caseId, driveData, shell] {
        QDir caseDataDir(spine::tools::pathtools::getCaseDataPath(caseId));
        if (caseDataDir.exists())
        {
            spine::actions::restoreLatestSnapshot(
                caseId, spine::actions::ApplicationDataLoad::AppDataRequired);
        }
        else
        {
            spine::actions::initCase(caseId);
            auto ssm =
                spine::iocmanager::resolveContainer<spine::managers::SurgeonSettingsManager>();
            auto layout = ssm->volumeSetFourUpLayout();
            ::spine::actions::setMainVolumeLayout(layout);
        }

        // Create the services only after the data model has been populated
        createServices(caseId.toStdString());

        auto driveDataOpt = compareDriveAppData(
            driveData, spine::propertysources::AppDataPropertySource::instance().driveCaseData());
        if (driveDataOpt.has_value())
        {
            spine::actions::setSurgeonName(m_surgeonName);
            spine::actions::setDriveCaseData(driveDataOpt.value());
            spine::actions::saveStateSnapshot();

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

void SpinePluginGui::runHeader(std::shared_ptr<plugin::IPluginShell> shell,
                               drive::model::SurgeonIdentifier surgeonId)
{
    qDebug() << "surgeonId is" << QString::fromStdString(boost::uuids::to_string(surgeonId.id));
    m_pluginShellList.push_back(shell);
    if (!m_pluginContext)
    {
        setupContext(shell->getQmlContext());
        // The use of real feature set to be added at a later stage
        createBuilder({}, surgeonId);
    }

    // Next line load TopBarViewmodel
    shell->createPluginComponent(m_pluginContext.data());
}

void SpinePluginGui::cleanupPluginQml()
{
    emit cleanupQml();
    if (m_pluginContext && m_pluginContext->engine())
    {
        m_pluginContext->engine()->removeImageProvider(QLatin1String("volumeThumbnail"));
        m_pluginContext->engine()->removeImageProvider(QLatin1String("combinedBB"));
        m_pluginContext->engine()->removeImageProvider(QLatin1String("fluoroimage"));
        m_pluginContext->engine()->removeImageProvider(QLatin1String("headsetfeed"));
    }

    for (auto& pluginShell : m_pluginShellList)
    {
        pluginShell->deletePluginComponent();
    }
}

void SpinePluginGui::quitPlugin()
{
#ifdef GM_ENABLE_SPINE_GRPC
    stopSpineServer();
#endif

    spine::actions::saveStateSnapshot();
    cleanupTasks();
    G_EMIT pluginQuitAcknowledged(spine::plugin::manifest::PLUGIN_SHORT_NAME,
                                  [res = m_driveCaseData](auto&&) { return res; });
}

[[nodiscard]] std::shared_ptr<gos::itf::alerts::IAlertView> SpinePluginGui::getAlertView() const
{
    return m_alertView;
}

void SpinePluginGui::createContextProperties()
{
    QVector<QQmlContext::PropertyPair> contextProperties;
    contextProperties.append(QQmlContext::PropertyPair{"pluginGui", QVariant::fromValue(this)});
    contextProperties.append(QQmlContext::PropertyPair{
        "volumeRegistrationTaskFactory", QVariant::fromValue(&m_volumeRegistrationTaskFactory)});
    contextProperties.append(QQmlContext::PropertyPair{
        "viewportListViewModel",
        QVariant::fromValue(new spine::viewmodels::ViewportListViewModel(this))});
    contextProperties.append(QQmlContext::PropertyPair{
        "overlayViewModel",
        QVariant::fromValue(new spine::viewmodels::OverlayViewModel(
            QString::fromStdString(gm::util::qml::getQmlDir().value_or("qrc:/spine/qml/")),
            this))});
    contextProperties.append(QQmlContext::PropertyPair{
        "applicationViewModel",
        QVariant::fromValue(&spine::viewmodels::ApplicationViewModel::instance())});

    if (gm::util::qml::isQmlHotReloadEnabled())
    {
        SYS_LOG_INFO("Spine QML hot reload enabled");
        auto hotReloadManager =
            new spine::managers::SpineHotReloadManager(m_pluginContext->engine(), this);
        contextProperties.append(
            QQmlContext::PropertyPair{"hotReloadManager", QVariant::fromValue(hotReloadManager)});
    }
    else
    {
        SYS_LOG_INFO("Spine QML hot reload disabled");
        auto hotReloadManager = new QObject(this);
        contextProperties.append(
            QQmlContext::PropertyPair{"hotReloadManager", QVariant::fromValue(hotReloadManager)});
    }


    auto datapath = sys::config::Config::instance()->config.apps().gpsClientSpine().data();
    QString spineDataPath = QString::fromStdString(datapath.string());
    contextProperties.append(QQmlContext::PropertyPair{"spineDataPath", spineDataPath});

    auto surgeonSettingsManager =
        spine::iocmanager::resolveContainer<spine::managers::SurgeonSettingsManager>();
    contextProperties.append(QQmlContext::PropertyPair{
        "surgeonSettings", QVariant::fromValue(surgeonSettingsManager.get())});

    m_pluginContext->setContextProperties(contextProperties);
}

void SpinePluginGui::setupContext(QPointer<QQmlContext> context)
{
    m_pluginContext = context;

    m_pluginContext->engine()->addImportPath("qrc:/imports");

    qmlRegisterType<spine::components::ImageViewport>("ViewModels", 1, 0, "ImageViewport");
    qRegisterMetaType<spine::algos::patreg2d3d::RegResult>("spine::algos::patreg2d3d::RegResult");
    qRegisterMetaType<spine::algos::patreg2d3d::AnatomyRegResults>(
        "spine::algos::patreg2d3d::AnatomyRegResults");
    qRegisterMetaType<spine::algos::patreg2d3d::RegResults>("spine::algos::patreg2d3d::RegResults");

    qmlRegisterUncreatableType<spine::tasks::ITask>("Tasks", 1, 0, "ITask", "");

    qmlRegisterUncreatableType<com::headset::HeadsetFeedVisualizer>(
        "Feeds", 1, 0, "HeadsetFeedVisualizer", "Unable to access visualizer");

    qRegisterMetaType<spine::types::enums::TrajectoryType>("spine::types::enums::TrajectoryType");
    qmlRegisterUncreatableType<spine::types::enums::TrajectoryTypeGadget>(
        "TrajectoryType", 1, 0, "TrajectoryType", "Unable to instantiate enum");

    spine::viewmodels::registerViewModels();
    spine::tools::registerAllTypes();
    spine::tools::registerAllEnums();
}

void SpinePluginGui::onDriveCaseDataUpdate(const DriveCaseData& driveCaseData)
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

    auto importViewModelSource =
        spine::iocmanager::resolveContainer<drive::scanimport::ImportViewModelSource>();
    importViewModelSource->setVolumeImportSources({m_scanManager, localScans});
    importViewModelSource->setDestinationFilter(
        module::scanmanager::LocalScanFilter{importedScanIds});
}

void SpinePluginGui::showLoadingAlert()
{
    if (!m_loadingAlertOpt.has_value())
    {
        auto managedAlert = spine::alerts::LoadingAlertFactory::createInstance();
        m_loadingAlertOpt = managedAlert->alert();
        m_alertManager->createAlert(m_loadingAlertOpt.value());
        QCoreApplication::processEvents();
    }
}

void SpinePluginGui::hideLoadingAlert()
{
    if (m_loadingAlertOpt.has_value())
    {
        m_alertManager->clearAlert(m_loadingAlertOpt.value());
        m_loadingAlertOpt = std::nullopt;
    }
}

void SpinePluginGui::showCaseDriveDifferentAlert()
{
    auto managedAlert = spine::alerts::CaseDriveDifferentAlertFactory::createInstance();
    // m_loadingAlertOpt = managedAlert->alert();
    m_alertManager->createAlert(managedAlert->alert());
}

std::optional<DriveCaseData> SpinePluginGui::compareDriveAppData(DriveCaseData dataFromDrive,
                                                                 DriveCaseData dataFromApp)
{
    auto compare = dataFromDrive.caseSeries.size() == dataFromApp.caseSeries.size() &&
                   std::equal(dataFromDrive.caseSeries.begin(), dataFromDrive.caseSeries.end(),
                              dataFromApp.caseSeries.begin(),
                              [](auto a, auto b) { return a.first == b.first; });

    if (dataFromDrive.caseDetails.keyDetails != dataFromApp.caseDetails.keyDetails)
    {
        SYS_LOG_WARN(
            "Case keyDetails is not matching with drive data, using keyDetails from case data ");
        dataFromDrive.caseDetails.keyDetails = dataFromApp.caseDetails.keyDetails;
    }

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

std::optional<DriveCaseData> SpinePluginGui::compareDriveCaseData(DriveCaseData dataFromDrive)
{
    DriveCaseData resultDriveData = dataFromDrive;

    // Compare that all drive series are in the case volumes
    for (const auto& [key, value] : dataFromDrive.caseSeries)
    {
        if (!spine::atoms::casedatareader::isVolumeInCase(
                gm::util::typeconv::convert<QUuid>(key.id)))
        {
            SYS_LOG_WARN(
                "Series {} is not in the case, deleting series from "
                "drive",
                key.id);
            resultDriveData.caseSeries = resultDriveData.caseSeries.erase(key);
        }
    }

    // Compare that all case volumes are in the drive series
    auto allVolumesIds = spine::atoms::casedatareader::getVolumesInCase();
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
}


void SpinePluginGui::registerXrGatewaysIoc(std::shared_ptr<gm::arch::ioc::ContainerBuilder> builder)
{
    builder->registerType<spine::gateways::xr::XrControlsGateway>().singleInstance();
}

void SpinePluginGui::resolveFeatureDependentItems(
    std::shared_ptr<spine::managers::FeaturesManager> featuresManager)
{
    if (xrEnabled(featuresManager))
    {
        resolveAll<spine::gateways::xr::XrControlsGateway>();
        constructXrGateways(m_gLinkNode);

        m_pluginContext->setContextProperty("meshGateway",
                                            QVariant::fromValue(m_meshGateway.get()));

        m_services.emplace_back(std::make_unique<spine::services::ViewportStreamingService>(
            m_gLinkNode,
            QString::fromStdString(gm::util::qml::getQmlDir().value_or("qrc:/spine/qml/"))));

        connect(this, &SpinePluginGui::cleanupQml,
                qobject_cast<spine::services::ViewportStreamingService*>(m_services.back().get()),
                &spine::services::ViewportStreamingService::shutdown);
    }
}

void SpinePluginGui::constructXrGateways(std::shared_ptr<glink::node::INode> node)
{
    using namespace spine::gateways::xr;

    m_caseDataGateway = std::make_shared<CaseDataGateway>();
    m_caseDataSource =
        gos::xr::CaseDataSourceFactory::createInstance(node, m_caseDataGateway, "casedata");

    m_implantPlansGateway = std::make_shared<ImplantPlansGateway>();
    m_implantPlansSource = gos::xr::ImplantPlansSourceFactory::createInstance(
        node, m_implantPlansGateway, "implantplans");

    m_navigatedInstrumentGateway = std::make_shared<NavigatedInstrumentGateway>();
    m_navigatedInstrumentSource = gos::xr::NavigatedInstrumentSourceFactory::createInstance(
        node, m_navigatedInstrumentGateway, "navigatedinstruments");

    m_patientRegistrationGateway = std::make_shared<PatientRegistrationGateway>();
    m_patientRegistrationSource = gos::xr::PatientRegistrationSourceFactory::createInstance(
        node, m_patientRegistrationGateway, "patientregistration");

    m_streamControlsGateway = std::make_shared<StreamControlsGateway>();
    m_streamControlsSource = gos::xr::StreamControlsSourceFactory::createInstance(
        node, m_streamControlsGateway, "streamcontrols");

    m_workflowGateway = std::make_shared<WorkflowGateway>();
    m_workflowSource =
        gos::xr::WorkflowSourceFactory::createInstance(node, m_workflowGateway, "workflow");


    m_meshGateway = std::make_shared<MeshGateway>();
    m_meshProviderSource =
        gos::xr::MeshProviderSourceFactory::createInstance(node, m_meshGateway, "meshprovider");

    m_xrControlsSource = gos::xr::XrControlsSourceFactory::createInstance(
        node, spine::iocmanager::resolveContainer<spine::gateways::xr::XrControlsGateway>(),
        "xrcontrols");
}

void SpinePluginGui::resetXrComponents()
{
    m_caseDataGateway.reset();
    m_caseDataSource.reset();

    m_implantPlansGateway.reset();
    m_implantPlansSource.reset();

    m_navigatedInstrumentGateway.reset();
    m_navigatedInstrumentSource.reset();

    m_patientRegistrationGateway.reset();
    m_patientRegistrationSource.reset();

    m_streamControlsGateway.reset();
    m_streamControlsSource.reset();

    m_workflowGateway.reset();
    m_workflowSource.reset();

    m_xrControlsSource.reset();

    m_meshGateway.reset();
    m_meshProviderSource.reset();
}

#ifdef GM_ENABLE_SPINE_GRPC
void SpinePluginGui::runSpineServer()
{
    spineplugin::GrpcServices services;

    common::grpc::imageimport::ImportSuccessCallback scanImportedCallback(
        [](const std::pair<ScanId, ManagedScan>& volumeWithId) {
            spine::tools::onScanImportSuccess(volumeWithId);
        });

    common::manager::imageimport::ImportCriteria criteria{
        .modalities = {gos::itf::scanmanager::ImportModality::CT},
        .scanTypeFormats = {gos::itf::scanmanager::ScanTypeFormat::DICOM,
                            gos::itf::scanmanager::ScanTypeFormat::NIFTI},
        .min_slices = 8,
        .patientFullName = m_driveCaseData.patientData.fullName,
        .patientScans = m_reachableScanIds};
    auto imageImportService = std::make_shared<common::grpc::imageimport::ImageImportGrpcService>(
        std::move(scanImportedCallback), std::move(criteria));

    services.emplace_back(imageImportService);
    services.emplace_back(spine::grpcservices::GrpcServiceFactory::createInstance(
        spine::grpcservices::GrpcServiceType::VolumesService));


    SYS_LOG_INFO("SpinePluginGui main thread ID: {}", std::this_thread::get_id());
    m_serverThread.reset(new spineplugin::ServerThread(services, this));

    m_serverThread->start();
}

void SpinePluginGui::stopSpineServer()
{
    if (m_serverThread)
    {
        SYS_LOG_INFO("Stopping server thread...");
        m_serverThread->stopServer();
        m_serverThread->quit();
        m_serverThread->wait();
        SYS_LOG_INFO("Successfully joined server thread");
    }
}
#endif
