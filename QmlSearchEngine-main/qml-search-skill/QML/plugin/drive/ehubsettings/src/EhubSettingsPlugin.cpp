/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#include "EhubSettingsPlugin.h"
#include "EhubSettingsPluginGui.h"
#include <drive/itf/plugin/IWorkflowPluginDataModel.h>
#include <QDebug>

using namespace drive::itf::plugin;

EhubSettingsPlugin::EhubSettingsPlugin(QObject* parent)
    : QObject(parent)
    , m_pluginGui(std::make_shared<EhubSettingsPluginGui>())

{}

std::optional<std::string> EhubSettingsPlugin::getWatchdogFile(
    sys::config::SystemType systemType [[maybe_unused]]) const
{
    return std::nullopt;
}

std::shared_ptr<IPluginGui> EhubSettingsPlugin::getGui() const
{
    return m_pluginGui;
}

std::shared_ptr<IWorkflowPluginDataModel>
EhubSettingsPlugin::getWorkflowDataModel() const
{
    return nullptr;
}

std::shared_ptr<gos::itf::alerts::IAlertView> EhubSettingsPlugin::getAlertView()
    const
{
    return nullptr;
}

void EhubSettingsPlugin::cleanupPlugin()
{
    m_pluginGui.reset();
}
