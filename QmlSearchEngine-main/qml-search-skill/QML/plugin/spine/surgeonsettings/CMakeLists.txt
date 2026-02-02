set(GM_PROJECT_NAME apps_plugin_spine_surgeonsettings)
set(GM_DISPLAY_NAME "Spine Settings")
set(GM_APP_VERSION "1.7.0")
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
        apps_spine_settings_backend
        procd_spine_managers
        Qt::Quick
    PUBLIC
        drive_itf_plugin
        drive_settings
        gm-component-core-libs::gm_util
        gm-component-qt-libs::gm_util_qt
        spinesettingsplugin_manifest
        sys_alerts
)
