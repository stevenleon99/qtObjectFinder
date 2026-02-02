/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#include "SystemSettingsPlugin.h"
#include "SystemSettingsPluginGui.h"
#include <drive/config/settings/SystemSettingsFactory.h>
#include <drive/itf/plugin/IWorkflowPluginDataModel.h>
#include <QDebug>

using namespace drive::itf::plugin;

SystemSettingsPlugin::SystemSettingsPlugin(QObject* parent)
    : QObject(parent)
    , m_pluginGui(std::make_shared<SystemSettingsPluginGui>())

{}

std::optional<std::string> SystemSettingsPlugin::getWatchdogFile(
    sys::config::SystemType systemType [[maybe_unused]]) const
{
    return std::nullopt;
}

std::shared_ptr<IPluginGui> SystemSettingsPlugin::getGui() const
{
    return m_pluginGui;
}

std::shared_ptr<IWorkflowPluginDataModel>
SystemSettingsPlugin::getWorkflowDataModel() const
{
    return nullptr;
}

std::shared_ptr<gos::itf::alerts::IAlertView>
SystemSettingsPlugin::getAlertView() const
{
    return std::dynamic_pointer_cast<SystemSettingsPluginGui>(m_pluginGui)
        ->getAlertView();
}

void SystemSettingsPlugin::cleanupPlugin()
{
    m_pluginGui.reset();
}
