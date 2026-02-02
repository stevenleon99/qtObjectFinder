set(GM_PROJECT_NAME apps_plugin_cranial_workflow)
set(GM_DISPLAY_NAME "Cranial")
set(GM_APP_VERSION "1.6.0")
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

target_link_libraries(${GM_PROJECT_NAME}
    PUBLIC
        apps_drive_plugin_common
    PRIVATE
        cranialplugin_manifest
        drive_itf_plugin
        drive_model_common
        drive_scanimport
        gm_apps_plugin_cranial_rc
        gm-component-core-libs::gm_arch_ioc
        gm_util_lenses
        gm_apps_common_rc
        gos_motion_armmotion
        gos_nav.sh_proxy
        gos_services_uaib
        immer::immer
        lager::lager
        module_scanmanager
        procd_cranial_actions
        procd_cranial_atoms
        procd_cranial_components
        procd_cranial_managers.ioc
        procd_cranial_managers.toolbox
        procd_cranial_model
        procd_cranial_propertysources
        procd_cranial_proxy
        procd_cranial_services
        procd_cranial_tasks
        procd_cranial_types
	    procd_cranial_viewmodels.overlays
        sys_alerts
        sys_log.imfusion
        sys_config
        uaibcontroller
        zug::zug
)
