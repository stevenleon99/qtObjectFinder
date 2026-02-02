/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#include "SurgeonSettingsPlugin.h"
#include "SurgeonSettingsPluginGui.h"
#include <drive/itf/plugin/IWorkflowPluginDataModel.h>
#include <QDebug>

using namespace drive::itf::plugin;

SurgeonSettingsPlugin::SurgeonSettingsPlugin(QObject* parent)
    : QObject(parent)
    , m_pluginGui(std::make_shared<SurgeonSettingsPluginGui>())

{}

std::optional<std::string> SurgeonSettingsPlugin::getWatchdogFile(sys::config::SystemType systemType
                                                                  [[maybe_unused]]) const
{
    return std::nullopt;
}

std::shared_ptr<IPluginGui> SurgeonSettingsPlugin::getGui() const
{
    return m_pluginGui;
}

std::shared_ptr<IWorkflowPluginDataModel> SurgeonSettingsPlugin::getWorkflowDataModel() const
{
    return nullptr;
}

std::shared_ptr<gos::itf::alerts::IAlertView> SurgeonSettingsPlugin::getAlertView() const
{
    return nullptr;
}

void SurgeonSettingsPlugin::cleanupPlugin()
{
    m_pluginGui.reset();
}
