#include <spineplugin/SpinePlugin.h>

#include <QDir>

SpinePlugin::SpinePlugin(QObject* parent)
    : QObject(parent)
{
    Q_INIT_RESOURCE(gm_apps_plugin_spine_rc);
}

SpinePlugin::~SpinePlugin()
{
    Q_CLEANUP_RESOURCE(gm_apps_plugin_spine_rc);
}

std::optional<std::string> SpinePlugin::getWatchdogFile(sys::config::SystemType systemType) const
{
    constexpr auto WATCHDOG_CONFIG_SPINE2 = "Spine2";
    constexpr auto WATCHDOG_CONFIG_EHUB_SPINE2 = "Ehub-Spine2";

    if (systemType == sys::config::SystemType::Ehub)
        return WATCHDOG_CONFIG_EHUB_SPINE2;
    if (systemType != sys::config::SystemType::Laptop)
        return WATCHDOG_CONFIG_SPINE2;
    return std::nullopt;
}
