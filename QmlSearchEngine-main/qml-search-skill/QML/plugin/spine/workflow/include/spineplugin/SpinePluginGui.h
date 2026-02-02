/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#define GM_GEOM_DEFINE_AFFINES

#include <drive/itf/plugin/IPluginGui.h>
#include <drive/itf/plugin/IPluginShell.h>
#include <drive/itf/plugin/IWorkFlowPluginGui.h>
#include <drive/itf/plugin/IWorkflowPluginDataModel.h>
#include <drive/scanimport/ImportViewModelSource.h>

#ifndef Q_MOC_RUN
#include <procd/spine/model/CaseModel.h>
#include <procd/spine/atoms/AtomOwner.h>

#include <procd/spine/tasks/VolumeRegistrationTaskFactory.h>

#include <procd/spine/actions/MergeActions.h>
#include <procd/spine/actions/PlanActions.h>
#include <procd/spine/actions/RenderActions.h>
#include <procd/spine/actions/CaseActions.h>
#include <procd/spine/actions/DriveActions.h>
#include <procd/spine/actions/TrackedToolActions.h>

#include <procd/spine/components/ImageViewport.h>

#include <procd/spine/gateways/LoadSensorHubPatternsGateway.h>
#include <procd/spine/gateways/HeadsetFeedManager.h>

// XR Gateways
#include <procd/spine/gateways/CaseDataGateway.h>
#include <procd/spine/gateways/ImplantPlansGateway.h>
#include <procd/spine/gateways/MeshGateway.h>
#include <procd/spine/gateways/NavigatedInstrumentGateway.h>
#include <procd/spine/gateways/PatientRegistrationGateway.h>
#include <procd/spine/gateways/StreamControlsGateway.h>
#include <procd/spine/gateways/WorkflowGateway.h>
#include <procd/spine/gateways/XrControlsGateway.h>

// Weird case for a manager. Drive is currently using it to update
// the importViewModel.
#include <procd/spine/managers/SpineImportManager.h>
#include <procd/spine/managers/FeaturesManager.h>
#include <procd/spine/managers/SpineHotReloadManager.h>
#include <procd/spine/services/SurveillanceMarkerActivationAlertService.h>

#ifdef GM_ENABLE_SPINE_GRPC
#include <spineplugin/ServerThread.hpp>
#endif

#include <imfusionrendering/ImFusionClient.h>

#include <service/glink/node/INode.h>
#include <service/glink/node/NodeFactory.h>
#include <service/glink/listener/Listener.h>
#include <gos/itf/motion/IGpsArmMotionSessionManager.h>
#include <gos/itf/nav.h>
#include <gos/motion/armmotion/ArmMotionSessionManagerProxyFactory.h>
#include <gos/motion/armmotion/ArmMotionSessionManagerSourceFactory.h>
#include <gos/motion/armmotion/ArmReachabilityProxyFactory.h>
#include <gos/motion/armmotion/ArmReachabilitySourceFactory.h>
#include <gos/nav/SensorHubProxyFactory.h>
#include <procd/common/util/services/CaseSensorhubLoggingService.h>
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

namespace gm::arch::ioc {
class ContainerBuilder;
}

class SpinePluginGui final : public QObject, public drive::itf::plugin::IWorkFlowPluginGui
{
    Q_OBJECT
    Q_INTERFACES(drive::itf::plugin::IWorkFlowPluginGui)
    Q_INTERFACES(drive::itf::plugin::IPluginGui)

public:
    explicit SpinePluginGui(QObject* parent = nullptr);
    ~SpinePluginGui() override;

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

signals:
    void cleanupQml();

private:
    void setupContext(QPointer<QQmlContext> context);
    void createServices(const std::string& caseID);
    void createBuilder(std::shared_ptr<spine::managers::FeaturesManager> featureManager,
                       drive::model::SurgeonIdentifier surgeonId);
    void createProviders();
    void createContextProperties();
    void showLoadingAlert();
    void hideLoadingAlert();
    void showCaseDriveDifferentAlert();

private slots:
    void onDriveCaseDataUpdate(const DriveCaseData& driveCaseData);

private:
    std::string m_surgeonName;
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

    spine::tasks::VolumeRegistrationTaskFactory m_volumeRegistrationTaskFactory;

    std::shared_ptr<spine::services::SurveillanceMarkerActivationAlertService>
        m_surveillanceMarkerActivationAlertService;
    std::shared_ptr<procd::common::util::services::CaseSensorhubLoggingService>
        m_caseSensorhubLoggingService;
    std::vector<std::unique_ptr<QObject>> m_services;

    std::shared_ptr<spine::gateways::LoadSensorHubPatternsGateway> m_loadSensorHubPatternsGateway;

    // Xr Headset manager only available on Hub
    std::shared_ptr<spine::gateways::HeadsetFeedManager> m_headsetFeedManager = nullptr;
    std::shared_ptr<spine::managers::FeaturesManager> m_featuresManager;
    QScopedPointer<spine::managers::SpineHotReloadManager> m_hotReloadManager;

    std::vector<std::shared_ptr<plugin::IPluginShell>> m_pluginShellList;

    // needs to be initialized last to collect all alert managers
    const std::shared_ptr<sys::alerts::itf::IAlertAggregator> m_alertView;
    std::optional<sys::alerts::Alert> m_loadingAlertOpt;

    // XR Dependencies
    std::shared_ptr<gos::itf::xr::ICaseData> m_caseDataGateway;
    std::shared_ptr<void> m_caseDataSource;
    std::shared_ptr<gos::itf::xr::IImplantPlans> m_implantPlansGateway;
    std::shared_ptr<void> m_implantPlansSource;
    std::shared_ptr<spine::gateways::xr::MeshGateway> m_meshGateway;
    std::shared_ptr<void> m_meshProviderSource;
    std::shared_ptr<gos::itf::xr::INavigatedInstrument> m_navigatedInstrumentGateway;
    std::shared_ptr<void> m_navigatedInstrumentSource;
    std::shared_ptr<gos::itf::xr::IPatientRegistration> m_patientRegistrationGateway;
    std::shared_ptr<void> m_patientRegistrationSource;
    std::shared_ptr<gos::itf::xr::IStreamControls> m_streamControlsGateway;
    std::shared_ptr<void> m_streamControlsSource;
    std::shared_ptr<gos::itf::xr::IWorkflow> m_workflowGateway;
    std::shared_ptr<void> m_workflowSource;
    std::shared_ptr<void> m_xrControlsSource;
    std::shared_ptr<glink::node::INode> m_node;

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

    /**
     * Arrest main thread disposal until all the task threads have completed. Call before qml has
     * been destroyed in order to display wait popup
     */
    void cleanupTasks();

    /**
     * Construct the XR gateways
     * @param node the glink node for the Spine Application
     */
    void constructXrGateways(std::shared_ptr<glink::node::INode> node);

    /**
     * Construct feature-dependent gateways that are also depended on by through Ioc
     * @param builder The Ioc container builder
     */
    void registerXrGatewaysIoc(std::shared_ptr<gm::arch::ioc::ContainerBuilder> builder);

    /**
     * Forcibly resolve feature dependent items (e.g. xr Controls Gateway) which must exist
     * immediately, e.g. for use in constructing services, gateways etc. later in this file
     * @param featureManager The feature manager to check for XR / component licenses
     */
    void resolveFeatureDependentItems(
        std::shared_ptr<spine::managers::FeaturesManager> featureManager);

    /**
     * Reset all the XR gateway member variable pointers
     */
    void resetXrComponents();

#ifdef GM_ENABLE_SPINE_GRPC
    QScopedPointer<spineplugin::ServerThread> m_serverThread;
    void runSpineServer();
    void stopSpineServer();
#endif
};
