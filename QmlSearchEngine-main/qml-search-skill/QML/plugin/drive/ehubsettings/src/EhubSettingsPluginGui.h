/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#include <drive/itf/plugin/ISettingsPluginGui.h>

#include <QtPlugin>
#include <QObject>
#include <QQmlContext>
#include <QPointer>

namespace ehubsettings::imageprovider {
class HeadsetFeedProvider;
}

namespace drive::viewmodel {
class HeadsetCalibrationViewModel;
}

class EhubSettingsPluginGui final : public QObject, public drive::itf::plugin::ISettingsPluginGui
{
    Q_OBJECT
    Q_INTERFACES(drive::itf::plugin::ISettingsPluginGui)
    Q_INTERFACES(drive::itf::plugin::IPluginGui)

public:
    explicit EhubSettingsPluginGui();
    ~EhubSettingsPluginGui() override = default;

    std::string getQmlPath() const override;
    void runSettings(std::shared_ptr<drive::itf::plugin::IPluginShell> shell,
                     std::vector<std::string> features,
                     drive::model::SurgeonIdentifier surgeonId) override;
    std::optional<drive::settings::menu::MenuModel*> settingsMenu() override;
    void cleanupPluginQml() override;
    void quitPlugin() override;

private:
    QPointer<QQmlContext> m_pluginContext;
    std::shared_ptr<ehubsettings::imageprovider::HeadsetFeedProvider> m_headsetFeedProvider =
        nullptr;
    std::shared_ptr<drive::viewmodel::HeadsetCalibrationViewModel> m_headsetCalibrationViewModel =
        nullptr;
};
