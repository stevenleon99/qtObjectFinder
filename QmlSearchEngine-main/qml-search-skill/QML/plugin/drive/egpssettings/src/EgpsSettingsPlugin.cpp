/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#include "EgpsSettingsPlugin.h"
#include "EgpsSettingsPluginGui.h"
#include <drive/itf/plugin/IWorkflowPluginDataModel.h>
#include <QDebug>

using namespace drive::itf::plugin;

EgpsSettingsPlugin::EgpsSettingsPlugin(QObject* parent)
    : QObject(parent)
    , m_pluginGui(std::make_shared<EgpsSettingsPluginGui>())

{}

std::optional<std::string> EgpsSettingsPlugin::getWatchdogFile(
    sys::config::SystemType systemType [[maybe_unused]]) const
{
    return std::nullopt;
}

std::shared_ptr<IPluginGui> EgpsSettingsPlugin::getGui() const
{
    return m_pluginGui;
}

std::shared_ptr<IWorkflowPluginDataModel>
EgpsSettingsPlugin::getWorkflowDataModel() const
{
    return nullptr;
}

std::shared_ptr<gos::itf::alerts::IAlertView> EgpsSettingsPlugin::getAlertView()
    const
{
    return nullptr;
}

void EgpsSettingsPlugin::cleanupPlugin()
{
    m_pluginGui.reset();
}
