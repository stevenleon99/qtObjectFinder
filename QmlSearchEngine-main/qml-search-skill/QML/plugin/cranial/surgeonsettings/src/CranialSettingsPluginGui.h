/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#include <apps/cranial/backend/SurgeonSettingsViewModel.h>

#include <drive/itf/plugin/ISettingsPluginGui.h>

#include <memory>
#include <QtPlugin>
#include <QObject>
#include <QQmlContext>
#include <QPointer>

class CranialSettingsPluginGui final : public QObject, public drive::itf::plugin::ISettingsPluginGui
{
    Q_OBJECT
    Q_INTERFACES(drive::itf::plugin::ISettingsPluginGui)
    Q_INTERFACES(drive::itf::plugin::IPluginGui)

public:
    explicit CranialSettingsPluginGui();
    ~CranialSettingsPluginGui() override = default;

    std::string getQmlPath() const override;
    void runSettings(std::shared_ptr<drive::itf::plugin::IPluginShell> shell,
                     std::vector<std::string> features,
                     drive::model::SurgeonIdentifier surgeonId) override;
    std::optional<drive::settings::menu::MenuModel*> settingsMenu() override;
    void cleanupPluginQml() override;
    void quitPlugin() override;

private:
    QPointer<QQmlContext> m_pluginContext;
    std::shared_ptr<surgeonsettings::SurgeonSettingsViewModel> m_surgeonSettingsVM;
    std::shared_ptr<drive::settings::menu::MenuModel> m_model;
};

std::vector<std::string> getAllSoftwareFeatures();
