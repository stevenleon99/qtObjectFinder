/* Copyright (c) Thu 04/09/2020 Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFontDatabase>
#include <QFont>
#include <QDir>

#include <gm/nav/alerts/AlertHandler.h>
#include <gns/alerts/AlertHandlerFactory.h>
#include <sys/log/sys_log.h>
#include <sys/log/qt.h>
#include <sys/log/imfusion.h>
#include <gos/launcher/ExitCodes.h>

#include <sys/alerts/itf/IAlertAggregator.h>
#include <sys/alerts/AlertAggregatorFactory.h>
#include <gos/itf/alerts/IAlertView.h>
#include <sys/alerts/qt/AlertViewModel.h>
#include <gm/util/qt/qtContinuation.h>

#include "UserViewModel.h"
#include "PluginModel.h"
#include "PatientsModel.h"
#include "PatientListModel.h"
#include "PatientDetailsModel.h"
#include "PatientNameViewModel.h"
#include "CasesModel.h"
#include "CaseListModel.h"
#include "CaseSummaryModel.h"
#include "StudySummaryModel.h"
#include "DrivePageViewModel.h"
#include "ImportViewModel.h"
#include "ScanListModel.h"
#include "CaseExportViewModel.h"
#include "ApplicationViewModel.h"
#include "LicenseManagerViewModel.h"
#include "HomingViewModel.h"
#include "SystemPower.h"
#include "SystemInfoViewModel.h"
#include "WatermarkViewModel.h"
#include "ServiceSettingsViewModel.h"
#include "PluginInfoListModel.h"
#include "ScreenshotsViewModel.h"
#include "ConnectionsViewModel.h"
#include "ImageExportViewModel.h"
#include "OnboardingTutorialViewModel.h"
#include "NetworkSettingsViewModel.h"
#include <service/glink/node/NodeFactory.h>
#include <utilities/gmAppConfig.h>
#include <sys/config/config.h>
#include <sys/config/Config_Platform_Schema.h>
#include <gos/watchdog/WatchdogProxyFactory.h>
#include <gos/alerts/AlertViewSourceFactory.h>
#include <gos/services/deviceio/DeviceIOProxyFactory.h>
#include <gos/services/scanmanager/ScanManagerProxyFactory.h>
#include <drive/scanimport/ImportViewModelSource.h>
#include <drive/caseimport/CaseImportViewModel.h>
#include <drive/plugin/registry/PluginRegistryFactory.h>
#include <gps/alerts/AlertHandlerFactory.h>
#include <eflex/alerts/AlertManagerFactory.h>
#include <drive/ServiceModeManager.h>
#include <drive/config/settings/SystemSettingsFactory.h>
#include <gos/gps/shutdown/ShutdownProxyFactory.h>
#include <gps/shutdown/ShutdownFactory.h>
#include <sys/glink/ConnectionHandlerFactory.h>
#include <service/mirror/MirrorManager.h>
#include <drive/common/SortFilterProxyModel.h>
#include <boost/uuid/uuid_io.hpp>
#include <common/alerts.h>
#include <viewmodel/mirror/MirrorViewModel.h>
#include <softwareversion/softwareversion.h>


#include <Spix/AnyRpcServer.h>
#include <Spix/QtQmlBot.h>


using namespace gos::itf::alerts;
using namespace std::chrono_literals;
using namespace sys::alerts;

using namespace gos::services::scanmanager;
using namespace gos::services::deviceio;
using sys::config::Config;

inline constexpr auto WATCHDOG_CONFIG_LAPTOP_DRIVE = "Laptop-Drive";
inline constexpr auto WATCHDOG_CONFIG_DRIVE = "Drive";
inline constexpr auto WATCHDOG_CONFIG_EHUB_DRIVE = "Ehub-Drive";

inline constexpr auto GLINK_CONNECTION_TIMEOUT = 1s;


/**
 * @addtogroup apps_drive Drive infrastructure
 * @ingroup unit_client
 * @brief Drive infrastructure for user account, data management, and plugin
 * launches
 */
int main(int argc, char* argv[])
{
    try
    {
        sys::log::initLog("drive", sys::log::LogLevel::Debug);
        SYS_LOG_FLUSH_AT_SCOPE_EXIT();

        sys::log::redirectQDebugToSysLog();
        sys::log::redirectImFusionLogToSysLog(sys::log::LogLevel::Debug);

        // Forces Qt Quick to render in the main GUI thread to simplify ImFusion
        // setup.
        qputenv("QSG_RENDER_LOOP", "windows");

        // Forces Qt to suppress qml connection warnings triggered due to recent
        // Qt version change
        qputenv("QT_LOGGING_RULES", "qt.qml.connections=false");

        Q_INIT_RESOURCE(qrc_images);
        Q_INIT_RESOURCE(qrc_theme);
        Q_INIT_RESOURCE(qrc_common);
        Q_INIT_RESOURCE(qrc_sounds);
        Q_INIT_RESOURCE(qrc_gmStyles);
        Q_INIT_RESOURCE(qrc_fonts);
        Q_INIT_RESOURCE(qrc_virtualKeyboard);
        Q_INIT_RESOURCE(qrc_gmQml);
        Q_INIT_RESOURCE(qrc_drive_import);

        auto& platform = sys::config::Config::instance()->platform;
        sys::config::logConfigPlatformReport();
        logSoftwareVersionReport();

        auto&& systemType = platform.systemType();
        const bool isLaptop = systemType == sys::config::SystemType::Laptop;
        const bool isEhub = systemType == sys::config::SystemType::Ehub;

        // Enable virtual keyboard for systems other than laptop
        if (!isLaptop)
        {
            qputenv("QT_VIRTUALKEYBOARD_LAYOUT_PATH",
                    QByteArray("qrc:/virtualKeyboard/layouts"));
            qputenv("QT_VIRTUALKEYBOARD_STYLE", "gmKeyboardStyle");
            qputenv("QML2_IMPORT_PATH", "qrc:/virtualKeyboard");
            qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
        }

        QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
        QGuiApplication::setAttribute(
            Qt::AA_SynthesizeTouchForUnhandledMouseEvents, true);
        QGuiApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
        QGuiApplication::setAttribute(Qt::AA_DontCreateNativeWidgetSiblings);

        QGuiApplication app(argc, argv);
        ConfigureGMCoreApplication(&app);
        app.setApplicationName("Drive");
        app.setApplicationVersion("1.0");
        app.setOrganizationName("Globus Medical");
        app.setFont(QFont("Roboto"));

        QFontDatabase::addApplicationFont(":/fonts/Roboto-Regular.ttf");
        QFontDatabase::addApplicationFont(":/fonts/Roboto-Medium.ttf");
        QFontDatabase::addApplicationFont(":/fonts/Roboto-Bold.ttf");

        // setUseNavTrackingService as false uses an old, deprecated code path
        // that may not be working perfectly setUseNavTrackingService as true,
        // tracking data is sent via glink
        auto& settings = sys::config::Config::instance()->settings;
        settings.tracking.strayTrackingPipeline = true;
        settings.tracking.useNavTrackingService = true;
        sys::config::Settings::save(settings);

        std::promise<void> glinkConnectedPromise;
        auto glinkNode = glink::node::NodeFactory::createInstance();

        // Notify when the Glink service is connected
        glinkNode->connectionStateChanged.connect_extended(
            [&glinkConnectedPromise](const auto& signalConnection,
                                     glink::node::ConnectionState state) {
                if (state == glink::node::ConnectionState::Connected)
                {
                    // Let know the Glink node is connected...
                    glinkConnectedPromise.set_value();
                    // ... and disconnect the signal
                    signalConnection.disconnect();
                }
                else
                {
                    SYS_LOG_WARN("Glink service not connected");
                }
            });

        // Wait for the Glink node to be connected
        SYS_LOG_INFO("Waiting for Glink node conenction");
        // Use a timeout not to hang forever
        auto startWait = std::chrono::system_clock::now();
        if (glinkConnectedPromise.get_future().wait_for(
                GLINK_CONNECTION_TIMEOUT) == std::future_status::timeout)
        {
            SYS_LOG_ERROR(
                "Glink node connection timeout; ensure Glink is running");
            // In production, quitting Drive causes Launcher to restart it
            if (platform.systemMode() == sys::config::SystemMode::Prod)
            {
                return EXIT_FAILURE;
            }
        }
        else
        {
            auto endWait = std::chrono::system_clock::now();
            SYS_LOG_INFO("Glink node connected in {}ms",
                         std::chrono::duration_cast<std::chrono::milliseconds>(
                             endWait - startWait)
                             .count());
        }

        auto uuid = to_string(platform.systemUuid());
        const auto watchdog =
            gos::watchdog::WatchdogProxyFactory::createInstance(glinkNode,
                                                                uuid);

        // If run on a laptop, load the laptop Watchdog config, otherwise load
        // the normal Watchdog config
        auto loadedWatchdogConfig = WATCHDOG_CONFIG_DRIVE;
        if (isLaptop)
        {
            loadedWatchdogConfig = WATCHDOG_CONFIG_LAPTOP_DRIVE;
        }
        else if (isEhub)
        {
            loadedWatchdogConfig = WATCHDOG_CONFIG_EHUB_DRIVE;
        }

        SYS_LOG_INFO("Loading the Watchdog config '{}'", loadedWatchdogConfig);
        watchdog->loadConfig(loadedWatchdogConfig);

        QQmlApplicationEngine* engine = new QQmlApplicationEngine(&app);
        engine->addImportPath("qrc:/imports");
        engine->addImportPath(qApp->applicationDirPath() + QDir::separator() +
                              "imports");

        DrivePageViewModel drivePageViewModel(&app);
        engine->rootContext()->setContextProperty("drivePageViewModel",
                                                  &drivePageViewModel);
        qmlRegisterUncreatableType<DrivePageViewModel>(
            "DriveEnums", 1, 0, "DrivePage",
            "Unable to instantiate enum DrivePage.");

        drive::scanimport::ImportViewModelSource* importViewModelSource =
            new drive::scanimport::ImportViewModelSource(&app);
        engine->rootContext()->setContextProperty("importViewModelSource",
                                                  importViewModelSource);

        auto scanManager = ScanManagerProxyFactory::createInstance(glinkNode);

        scanManager->scanManagerConnectStateChanged.connect(
            gm::util::qt::trackedContinuation(
                importViewModelSource,
                [=](gos::itf::scanmanager::ScanManagerConnectState state) {
                    std::vector<std::shared_ptr<IScanManager>> scanSourceList;
                    if (state == gos::itf::scanmanager::
                                     ScanManagerConnectState::Connected)
                    {
                        scanSourceList.push_back(scanManager);
                    }
                    importViewModelSource->setVolumeImportSources(
                        scanSourceList);
                }));

        auto connectionHandler =
            sys::glink::ConnectionHandlerFactory::createInstance(glinkNode);
        auto mirrorManager = std::make_shared<service::mirror::MirrorManager>();
        auto mirrorViewModel =
            std::make_shared<viewmodel::mirror::MirrorViewModel>();

        mirrorViewModel->setMirrorManager(mirrorManager);
        mirrorViewModel->setConnectionHandler(connectionHandler);

        engine->rootContext()->setContextProperty("driveMirrorViewModel",
                                                  mirrorViewModel.get());

        std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewer =
            sys::alerts::AlertAggregatorFactory::createInstance();
        auto alertViewSource =
            gos::alerts::AlertViewSourceFactory::createInstance(
                glinkNode, alertViewer, "DriveAlerts");
        qt::AlertViewModel alertViewModel(alertViewer, &app);
        engine->rootContext()->setContextProperty("alertViewModel",
                                                  &alertViewModel);

        SystemPower* systemPower = new SystemPower(alertViewer, &app);
        engine->rootContext()->setContextProperty("systemPower", systemPower);

        drive::viewmodel::UserViewModel* userViewModel =
            new drive::viewmodel::UserViewModel(alertViewer, &app);
        engine->rootContext()->setContextProperty("userViewModel",
                                                  userViewModel);

        auto driveSettings =
            drive::config::settings::SystemSettingsFactory::createInstance();

        auto networkSettingsViewModel =
            drive::viewmodel::NetworkSettingsViewModel::instance(alertViewer,
                                                                 driveSettings);
        qmlRegisterSingletonInstance<
            drive::viewmodel::NetworkSettingsViewModel>(
            "NetworkSettingsViewModel", 1, 0, "NwModel",
            networkSettingsViewModel);

        qmlRegisterUncreatableMetaObject(
            drive::networksettings::staticMetaObject, "DriveEnums", 1, 0,
            "DriveEnums", "Unable to create type DriveEnums.");
        std::shared_ptr<drive::plugin::registry::IPluginRegistry>
            pluginRegistry = drive::plugin::registry::PluginRegistryFactory::
                createInstance();
        pluginRegistry->addPluginsFromDirectory(
            qApp->applicationDirPath().toStdString());

        PluginModel pluginModel(systemType, pluginRegistry, alertViewer,
                                scanManager, driveSettings, watchdog, &app);
        engine->rootContext()->setContextProperty("pluginModel", &pluginModel);

        drive::viewmodel::PluginInfoListModel pluginInfoListModel;
        engine->rootContext()->setContextProperty("pluginInfoListModel",
                                                  &pluginInfoListModel);

        //  Unlock EDGE Log Service on quitting plugin
        pluginModel.removeEdgeLockFile();

        const auto deviceIo = DeviceIOProxyFactory::createInstance(glinkNode);

        drive::caseimport::CaseImportViewModel* caseImportViewModel =
            new drive::caseimport::CaseImportViewModel(
                deviceIo, &pluginInfoListModel, &app);
        engine->rootContext()->setContextProperty("caseImportViewModel",
                                                  caseImportViewModel);

        ImportViewModel* importViewModel = new ImportViewModel(
            alertViewer, pluginRegistry, scanManager, importViewModelSource,
            caseImportViewModel, &app);
        engine->rootContext()->setContextProperty("importViewModel",
                                                  importViewModel);

        ScanListModel* scanListModel =
            new ScanListModel(alertViewer, scanManager, &app);
        engine->rootContext()->setContextProperty("scanListModel",
                                                  scanListModel);

        CaseExportViewModel* caseExportViewModel = new CaseExportViewModel(
            pluginRegistry, alertViewer, scanManager, deviceIo, &app);
        engine->rootContext()->setContextProperty("caseExportViewModel",
                                                  caseExportViewModel);

        drive::viewmodel::ApplicationViewModel* applicationViewModel =
            new drive::viewmodel::ApplicationViewModel(alertViewer,
                                                       driveSettings, &app);
        engine->rootContext()->setContextProperty("applicationViewModel",
                                                  applicationViewModel);

        auto serviceModeManager = drive::ServiceModeManager::createInstance();
        WatermarkViewModel* watermarkViewModel =
            new WatermarkViewModel(serviceModeManager, userViewModel, &app);
        engine->rootContext()->setContextProperty("watermarkViewModel",
                                                  watermarkViewModel);

        LicenseManagerViewModel* licenseManagerViewModel =
            new LicenseManagerViewModel(alertViewer, &app);
        engine->rootContext()->setContextProperty("licenseManagerViewModel",
                                                  licenseManagerViewModel);

        drive::viewmodel::HomingViewModel* homingViewModel =
            new drive::viewmodel::HomingViewModel(glinkNode, alertViewer, &app);
        engine->rootContext()->setContextProperty("homingViewModel",
                                                  homingViewModel);

        drive::viewmodel::ServiceSettingsViewModel* serviceSettingsViewModel =
            new drive::viewmodel::ServiceSettingsViewModel(driveSettings, &app);
        engine->rootContext()->setContextProperty("serviceSettingsViewModel",
                                                  serviceSettingsViewModel);

        drive::viewmodel::ScreenshotsViewModel* screenshotsViewModel =
            new drive::viewmodel::ScreenshotsViewModel(alertViewer, &app);
        engine->rootContext()->setContextProperty("screenshotsViewModel",
                                                  screenshotsViewModel);

        drive::viewmodel::ConnectionsViewModel* connectionsViewModel =
            new drive::viewmodel::ConnectionsViewModel(
                alertViewer, connectionHandler, mirrorManager, &app);
        engine->rootContext()->setContextProperty("connectionsViewModel",
                                                  connectionsViewModel);

        QPointer<drive::viewmodel::ImageExportViewModel> imageExportViewModel =
            new drive::viewmodel::ImageExportViewModel(alertViewer, scanManager,
                                                       deviceIo, &app);
        engine->rootContext()->setContextProperty("imageExportViewModel",
                                                  imageExportViewModel);


        // On Application boot up shut down mirror server to disconnect
        // mirroring clients if using GPS but E3D connection makes gps a mirror
        // client
        if (mirrorViewModel->usingGPS() &&
            connectionsViewModel->connectedPeerType() !=
                drive::viewmodel::ConnectionsViewModel::ConnectedPeerType::E3d)
        {
            SYS_LOG_INFO("Starting Mirror Server");
            mirrorViewModel
                ->startMirrorServer();  // It needs to be started first in order
                                        // to disconnect any connected clients
            mirrorViewModel->stopMirrorServer();
        }

        common::alerts::checkServiceMode(*serviceModeManager);

        std::shared_ptr<sys::alerts::itf::IAlertViewProvider> gnsAlerts;
        std::shared_ptr<sys::alerts::itf::IAlertViewProvider> eflexAlerts;
        if (systemType == sys::config::SystemType::Ehub)
        {
            gnsAlerts =
                gns::alerts::AlertHandlerFactory::createInstance(glinkNode);
            alertViewer->addAlertView(gnsAlerts->getAlertView());
            // Clean this up by moving to the EFlex settings plugin
            if (licenseManagerViewModel->licenseFileValid(
                    "apps_plugin_hip_workflow") ||
                licenseManagerViewModel->licenseFileValid(
                    "apps_plugin_knee_workflow"))
            {
                eflexAlerts =
                    eflex::alerts::AlertManagerFactory::createInstance(
                        glinkNode);
                alertViewer->addAlertView(eflexAlerts->getAlertView());
            }
        }

        std::shared_ptr<sys::alerts::itf::IAlertViewProvider> gpsAlerts;
        if (systemType == sys::config::SystemType::Egps)
        {
            gpsAlerts = gps::alerts::AlertHandlerFactory::createInstance(
                glinkNode, serviceModeManager);
            alertViewer->addAlertView(gpsAlerts->getAlertView());
        }

        std::shared_ptr<sys::alerts::itf::IAlertViewProvider> navAlerts;
        if (!isLaptop)
        {
            navAlerts = gm::nav::alerts::AlertHandler::createInstance(
                glinkNode, serviceModeManager);
            alertViewer->addAlertView(navAlerts->getAlertView());
        }

        alertViewer->addAlertView(serviceModeManager->alertView());

        QObject::connect(&pluginModel, &PluginModel::workflowQuit,
                         &drivePageViewModel,
                         &DrivePageViewModel::onWorkflowQuit);
        QObject::connect(
            &pluginModel, &PluginModel::workflowPluginClosed,
            &drivePageViewModel, [=]() {
                std::vector<std::shared_ptr<IScanManager>> scanSourceList;
                if (scanManager->connectionState() ==
                    gos::itf::scanmanager::ScanManagerConnectState::Connected)
                {
                    scanSourceList.push_back(scanManager);
                }
                importViewModelSource->setVolumeImportSources(scanSourceList);
            });

        qmlRegisterType<PatientsModel>("ViewModels", 1, 0, "PatientsModel");
        qmlRegisterType<PatientListModel>("ViewModels", 1, 0,
                                          "PatientListModel");
        qmlRegisterType<PatientDetailsModel>("ViewModels", 1, 0,
                                             "PatientDetailsModel");
        qmlRegisterType<drive::viewmodel::PatientNameViewModel>(
            "ViewModels", 1, 0, "PatientNameViewModel");
        qmlRegisterType<CasesModel>("ViewModels", 1, 0, "CasesModel");
        qmlRegisterType<CaseListModel>("ViewModels", 1, 0, "CaseListModel");
        qmlRegisterType<CaseSummaryModel>("ViewModels", 1, 0,
                                          "CaseSummaryModel");
        qmlRegisterType<StudySummaryModel>("ViewModels", 1, 0,
                                           "StudySummaryModel");
        qmlRegisterType<drive::viewmodel::SystemInfoViewModel>(
            "ViewModels", 1, 0, "SystemInfoViewModel");
        qmlRegisterType<drive::common::SortFilterProxyModel>(
            "ViewModels", 1, 0, "SortFilterProxyModel");
        qmlRegisterType<drive::viewmodel::OnboardingTutorialViewModel>(
            "ViewModels", 1, 0, "OnboardingTutorialViewModel");

        qmlRegisterUncreatableType<drive::viewmodel::UserViewModel>(
            "DriveEnums", 1, 0, "PlatformType", "PlatformType is an enum.");
        qmlRegisterUncreatableType<qt::AlertViewItem>(
            "DriveEnums", 1, 0, "AlertLevel", "AlertLevel is an enum.");
        qmlRegisterUncreatableType<ScanListModel>(
            "DriveEnums", 1, 0, "ScanSource", "ScanSource is an enum.");
        qmlRegisterUncreatableType<CaseExportViewModel>(
            "DriveEnums", 1, 0, "CaseExportState", "ExportState is an enum.");
        qmlRegisterUncreatableType<WatermarkViewModel>(
            "DriveEnums", 1, 0, "WatermarkMode", "WatermarkMode is an enum.");
        qmlRegisterUncreatableType<drive::viewmodel::ConnectionsViewModel>(
            "DriveEnums", 1, 0, "GLinkConnectionState",
            "GLinkConnectionState is an enum.");
        qmlRegisterUncreatableType<drive::viewmodel::ConnectionsViewModel>(
            "DriveEnums", 1, 0, "ConnectedPeerType",
            "ConnectedPeerType is an enum.");


        const QUrl url(QStringLiteral("qrc:/drive/qml/main.qml"));
        QObject::connect(
            engine, &QQmlApplicationEngine::objectCreated, &app,
            [url](QObject* obj, const QUrl& objUrl) {
                if (!obj && url == objUrl)
                    QCoreApplication::exit(-1);
            },
            Qt::QueuedConnection);
        engine->load(url);

        // start the anyrpc server and run only in test mode and port# is set
        auto&& systemMode = platform.systemMode();
        auto port = platform.testServerPort();
        std::unique_ptr<spix::AnyRpcServer> server;
        std::unique_ptr<spix::QtQmlBot> bot;
        if (systemMode == sys::config::SystemMode::Test && port != 0)
        {
            server = std::make_unique<spix::AnyRpcServer>(port);
            bot = std::make_unique<spix::QtQmlBot>();
            bot->runTestServer(*server);
        }

        pluginModel.recoverCases();

        auto shutdown =
            gos::gps::shutdown::ShutdownProxyFactory::createInstance(
                glinkNode, gps::shutdown::ShutdownFactory::OBJECT_ID);
        shutdown->shutdownInitiated.connect([&app]() {
            SYS_LOG_INFO("System shutdown initiated. Shutting down Drive.");
            app.exit(gos::launcher::toInt(gos::launcher::ExitCode::Shutdown));
        });

        auto code = app.exec();

        watchdog->unloadConfig(loadedWatchdogConfig);

        return code;
    }
    catch (const std::exception& e)
    {
        SYS_LOG_EXCEPTION(e);
        return EXIT_FAILURE;
    }
    catch (...)
    {
        SYS_LOG_ERROR("Unknown exception");
        return EXIT_FAILURE;
    }
}
