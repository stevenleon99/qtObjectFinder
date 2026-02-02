#include <cranialplugin/CranialPlugin.h>

#include <QDir>

CranialPlugin::CranialPlugin(QObject* parent)
    : QObject(parent)
{
    Q_INIT_RESOURCE(gm_apps_plugin_cranial_rc);
}

CranialPlugin::~CranialPlugin()
{
    Q_CLEANUP_RESOURCE(gm_apps_plugin_cranial_rc);
};

std::optional<std::string> CranialPlugin::getWatchdogFile(sys::config::SystemType systemType) const
{
    constexpr auto WATCHDOG_CONFIG_CRANIAL = "Cranial";
    if (systemType != sys::config::SystemType::Laptop)
        return WATCHDOG_CONFIG_CRANIAL;
    return std::nullopt;
}
