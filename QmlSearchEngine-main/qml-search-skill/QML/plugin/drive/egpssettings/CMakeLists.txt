set(GM_PROJECT_NAME drive_plugins_drive_egpssettings)
set(GM_DISPLAY_NAME "ExcelsiusGPS Settings")
set(GM_APP_VERSION "1.4.0")
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

target_include_directories(${GM_PROJECT_NAME} PRIVATE ${GM_GMAS_INCLUDE_DIR})
target_link_libraries(${GM_PROJECT_NAME}
   PRIVATE
        drive_trackerinfo
        gps_legacy_motion
        gps_legacy_motion.versions
        gps_legacy_platform.versions
        gos_gps_motionversions
        gos_gps_platformversions
        gos_gps_stabilizers
        gos_motion_armmotion
        gos_hid_loadcell
        gos_services_uaib
        Qt::Quick
        service_glink_node
        uaibcontroller
    PUBLIC
        drive_itf_plugin
        drive_settings
        gm-component-core-libs::gm_util
        gm-component-qt-libs::gm_util_qt
        gos_itf_gps.stabilizers
        sys_alerts
        viewmodel_mirror
)
