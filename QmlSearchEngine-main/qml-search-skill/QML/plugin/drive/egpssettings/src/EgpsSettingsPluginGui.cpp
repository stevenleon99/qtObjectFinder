#include "EgpsSettingsPluginGui.h"
#include "LoadCellViewModel.h"
#include "EgpsVersionViewModel.h"
#include "EgpsStabilizersViewModel.h"
#include "EgpsResettleOptionViewModel.h"
#include <drive/trackerinfo/TrackerInfoListModel.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <gm/util/qt/typeconv.h>
#include <drive/model/common.h>

#include <QQmlEngine>
#include <QQmlContext>

constexpr auto GPS_SETTINGS_PLUGIN_NAME = "drive_plugins_drive_egpssettings";

EgpsSettingsPluginGui::EgpsSettingsPluginGui() {}

std::string EgpsSettingsPluginGui::getQmlPath() const
{
    return "qrc:/egpssettings/qml/EgpsSettingsPlugin.qml";
}

void EgpsSettingsPluginGui::runSettings(std::shared_ptr<drive::itf::plugin::IPluginShell> shell,
                                        [[maybe_unused]] std::vector<std::string> features,
                                        [[maybe_unused]] drive::model::SurgeonIdentifier surgeonId)
{
    m_pluginContext = shell->getQmlContext();

    qmlRegisterType<LoadCellViewModel>("ViewModels", 1, 0, "LoadCellViewModel");
    qmlRegisterType<drive::viewmodel::EgpsVersionViewModel>("ViewModels", 1, 0,
                                                            "EgpsVersionViewModel");
    qmlRegisterType<drive::viewmodel::TrackerInfoListModel>("ViewModels", 1, 0,
                                                            "TrackerInfoListModel");
    qmlRegisterType<drive::viewmodel::EgpsStabilizersViewModel>("ViewModels", 1, 0,
                                                                "EgpsStabilizersViewModel");
    qmlRegisterType<drive::viewmodel::EgpsResettleOptionViewModel>("ViewModels", 1, 0,
                                                                   "EgpsResettleOptionViewModel");

    shell->createPluginComponent();
}

std::optional<drive::settings::menu::MenuModel*> EgpsSettingsPluginGui::settingsMenu()
{
    return std::nullopt;
}

void EgpsSettingsPluginGui::cleanupPluginQml() {}

void EgpsSettingsPluginGui::quitPlugin()
{
    G_EMIT pluginQuitAcknowledged(GPS_SETTINGS_PLUGIN_NAME);
}
