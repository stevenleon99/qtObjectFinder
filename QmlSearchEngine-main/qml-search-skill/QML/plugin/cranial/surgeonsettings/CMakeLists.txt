set(GM_PROJECT_NAME apps_plugin_cranial_settings)
set(GM_DISPLAY_NAME "Cranial Settings")
set(GM_APP_VERSION "1.6.0")
set(GM_SOURCES)
set(GM_HEADERS)
set(GM_USE_MOC ON)
set(GM_USE_UIC OFF)
set(GM_USE_RCC ON)
set(GM_USE_SCXML ON)
set(GM_CONSOLE_APP OFF)
set(GM_PLUGIN_TYPE "settings")
set(GM_PRODUCTION_READY_PLUGIN ON)

set(GM_QML_DIR ${CMAKE_CURRENT_SOURCE_DIR}/etc/rc)

gm_SetupPluginProject()

target_link_libraries(${GM_PROJECT_NAME}
   PRIVATE
        apps_cranial_settings_backend
        drive_resource_settings
        procd_cranial_managers
        Qt::Quick
    PUBLIC
        cranialsettingsplugin_manifest
        drive_itf_plugin
        drive_settings
        gm-component-core-libs::gm_util
        gm-component-qt-libs::gm_util_qt
        sys_alerts
)
