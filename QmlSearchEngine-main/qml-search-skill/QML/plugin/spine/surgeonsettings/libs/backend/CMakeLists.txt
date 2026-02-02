set(GM_PROJECT_NAME apps_spine_settings_backend)
set(GM_LIB_TYPE STATIC)
set(GM_SOURCES 
)
set(GM_HEADERS 
)
set(GM_REPC_SOURCES
)
set(GM_REPC_REPLICAS
)

set(GM_USE_MOC ON)
set(GM_USE_UIC OFF)
set(GM_USE_RCC OFF)
set(GM_USE_REPC OFF)
set(GM_USE_PROTOBUF OFF)

gm_SetupLibProject()

target_link_libraries(${GM_PROJECT_NAME}
    PUBLIC
        gm-component-core-libs::gm_util
        gm-component-qt-libs::gm_util_qml
        lager::lager
        procd_spine_managers.ioc
        procd_spine_managers.toolbox
        procd_spine_model
        procd_spine_types
        sys_alerts
        
    PRIVATE
        procd_spine_managers
        procd_spine_tools
        procd_spine_viewmodels
)
