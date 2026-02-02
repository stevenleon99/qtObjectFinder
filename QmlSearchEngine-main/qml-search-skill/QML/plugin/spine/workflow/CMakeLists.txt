set(GM_PROJECT_NAME apps_plugin_spine_workflow)
set(GM_DISPLAY_NAME "Spine")
set(GM_APP_VERSION "1.7.0")
set(GM_SOURCES)
set(GM_HEADERS)
set(GM_USE_MOC ON)
set(GM_USE_UIC OFF)
set(GM_USE_RCC OFF)
set(GM_USE_SCXML OFF)
set(GM_USE_REPC OFF)
set(GM_USE_PROTOBUF OFF)
set(GM_CONSOLE_APP OFF)
set(GM_REQUIRE_ADMIN OFF)
set(GM_QML_DIR ${CMAKE_CURRENT_SOURCE_DIR}/etc/rc/qml)
set(GM_PLUGIN_TYPE "workflow")
set(GM_PRODUCTION_READY_PLUGIN ON)

gm_SetupPluginProject()

option(GM_ENABLE_SPINE_GRPC "Enable Spine GRPC Services" OFF)

if(GM_ENABLE_SPINE_GRPC)
    target_compile_definitions(${GM_PROJECT_NAME} PRIVATE GM_ENABLE_SPINE_GRPC)
endif()

target_link_libraries(${GM_PROJECT_NAME}
    PUBLIC
        apps_drive_plugin_common
        gm_util_grpc
        gos_motion_armmotion
        gos_nav.sh_proxy
        procd_spine_actions
        procd_spine_atoms
        procd_spine_components
        procd_spine_gateways
        procd_spine_managers
        procd_spine_grpcservices
        procd_spine_tasks
    PRIVATE
        com_headset
        drive_itf_plugin
        drive_model_common
        drive_scanimport
        gm_apps_plugin_spine_rc
        gm-component-core-libs::gm_arch_ioc
        gm_consul
        gm_util_lenses
        gm-component-qt-libs::gm_util_qml
        gos_gps_moveready
        gos_gps_stabilizers
        gos_hid_footpedal
        gos_services_uaib
        gm_apps_common_rc
        immer::immer
        lager::lager
        module_scanmanager
        procd_common_grpc_imageimport
        procd_common_imageprovider
        procd_common_util_services
        procd_spine_model
        procd_spine_services
        procd_spine_services.tasks
        procd_spine_services.transform
        procd_spine_tools.importcallbacks
        procd_spine_viewmodels
        service_glink_listener
        spineplugin_manifest
        sys_alerts
        sys_config
        sys_log.imfusion
        uaibcontroller
        uicom_fluorovisualizer
        zug::zug
)

gm_install(
    DIRECTORY "${CMAKE_SOURCE_DIR}/scripts/procd/spine"
    DESTINATION "scripts/procd"
    COMPONENTS SpineSuite
)
