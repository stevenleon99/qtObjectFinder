/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#include "CranialSettingsPlugin.h"
#include "CranialSettingsPluginGui.h"
#include <drive/itf/plugin/IWorkflowPluginDataModel.h>
#include <QDebug>

using namespace drive::itf::plugin;

CranialSettingsPlugin::CranialSettingsPlugin(QObject* parent)
    : QObject(parent)
    , m_pluginGui(std::make_shared<CranialSettingsPluginGui>())

{
    Q_INIT_RESOURCE(qrc_drive_settings);
}

std::optional<std::string> CranialSettingsPlugin::getWatchdogFile(sys::config::SystemType systemType
                                                                  [[maybe_unused]]) const
{
    return std::nullopt;
}

std::shared_ptr<IPluginGui> CranialSettingsPlugin::getGui() const
{
    return m_pluginGui;
}

std::shared_ptr<IWorkflowPluginDataModel> CranialSettingsPlugin::getWorkflowDataModel() const
{
    return nullptr;
}

std::shared_ptr<gos::itf::alerts::IAlertView> CranialSettingsPlugin::getAlertView() const
{
    return nullptr;
}

void CranialSettingsPlugin::cleanupPlugin()
{
    m_pluginGui.reset();
}
