/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#include <drive/itf/plugin/IPlugin.h>
#include <QObject>

class EgpsSettingsPlugin final : public QObject,
                                 public drive::itf::plugin::IPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID
                      "com.globusmedical.Interfaces.gm.ClientAppInterface/1.0")
    Q_INTERFACES(drive::itf::plugin::IPlugin)

public:
    explicit EgpsSettingsPlugin(QObject* parent = nullptr);
    ~EgpsSettingsPlugin() override = default;

    std::optional<std::string> getWatchdogFile(
        sys::config::SystemType systemType) const override;
    std::shared_ptr<drive::itf::plugin::IWorkflowPluginDataModel>
    getWorkflowDataModel() const override;
    std::shared_ptr<drive::itf::plugin::IPluginGui> getGui() const override;
    std::shared_ptr<gos::itf::alerts::IAlertView> getAlertView() const override;

    void cleanupPlugin() override;

private:
    std::shared_ptr<drive::itf::plugin::IPluginGui> m_pluginGui;
};
