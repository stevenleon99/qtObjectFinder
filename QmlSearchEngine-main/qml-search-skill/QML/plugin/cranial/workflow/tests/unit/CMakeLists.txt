set(GM_TEST_NAME apps_plugin_cranial_workflow_unit)
set(GM_TEST_FRAMEWORK Catch2)
set(GM_USE_MOC ON)

gm_SetupUnitTestProject()

target_link_libraries(${GM_TEST_NAME}
    PRIVATE
    gm_apps_plugin_cranial_rc
)
