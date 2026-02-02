#include "SystemSettingsPluginGui.h"

#include <gos/services/deviceio/DeviceIOProxyFactory.h>
#include <drive/model/common.h>
#include <service/glink/node/NodeFactory.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <gm/util/qt/typeconv.h>

#include <QQmlEngine>
#include <QQmlContext>

using namespace gos::services::deviceio;

constexpr auto SYSTEM_SETTINGS_PLUGIN_NAME = "drive_plugins_drive_generalsettings";

SystemSettingsPluginGui::SystemSettingsPluginGui()
    : m_alertManager{sys::alerts::AlertManagerFactory::createInstance()}
    , m_settingsImpl{std::make_shared<SystemSettingsImplementation>(
          DeviceIOProxyFactory::createInstance(glink::node::NodeFactory::createInstance()),
          m_alertManager)}
{
    gm::util::qt::connect(m_settingsImpl->pluginQuit, this,
                          &SystemSettingsPluginGui::emitQuitSignal);
}

std::string SystemSettingsPluginGui::getQmlPath() const
{
    return "qrc:/generalsettings/qml/SystemSettingsPlugin.qml";
}

void SystemSettingsPluginGui::runSettings(
    std::shared_ptr<drive::itf::plugin::IPluginShell> shell,
    [[maybe_unused]] std::vector<std::string> features,
    [[maybe_unused]] drive::model::SurgeonIdentifier surgeonId)
{
    m_pluginContext = shell->getQmlContext();

    m_settingsImpl->setPluginShell(shell);
    m_pluginContext->setContextProperty("settingsPlugin", m_settingsImpl.get());

    m_model = std::make_shared<drive::settings::menu::MenuModel>();
    m_pluginContext->setContextProperty("menuModel", m_model.get());

    shell->createPluginComponent();
}

std::shared_ptr<gos::itf::alerts::IAlertView> SystemSettingsPluginGui::getAlertView() const
{
    return m_alertManager;
}

void SystemSettingsPluginGui::setSystemSettings(
    const std::shared_ptr<drive::itf::settings::ISystemSettings>& settings)
{
    m_settingsImpl->setSystemSettings(settings);
}

void SystemSettingsPluginGui::cleanupPluginQml()
{
    m_settingsImpl->cleanupPlugin();
}

std::optional<drive::settings::menu::MenuModel*> SystemSettingsPluginGui::settingsMenu()
{
    return std::optional<drive::settings::menu::MenuModel*>(m_model.get());
}

void SystemSettingsPluginGui::quitPlugin()
{
    G_EMIT pluginQuitAcknowledged(SYSTEM_SETTINGS_PLUGIN_NAME);
}

void SystemSettingsPluginGui::emitQuitSignal()
{
    G_EMIT pluginQuitRequested(SYSTEM_SETTINGS_PLUGIN_NAME);
}
