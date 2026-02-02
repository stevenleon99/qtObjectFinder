/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#ifndef Q_MOC_RUN
#include <sys/alerts/AlertManagerFactory.h>
#include <sys/alerts/Alert.h>
#endif

#include "SystemSettingsImplementation.h"

#include <drive/itf/plugin/IPluginGui.h>
#include <drive/itf/plugin/ISettingsPluginGui.h>
#include <drive/itf/plugin/ISystemSettingsPluginGui.h>

#include <QtPlugin>
#include <QObject>
#include <QQmlContext>
#include <QPointer>

class SystemSettingsPluginGui final : public QObject,
                                      public drive::itf::plugin::ISystemSettingsPluginGui
{
    Q_OBJECT
    Q_INTERFACES(drive::itf::plugin::ISettingsPluginGui)
    Q_INTERFACES(drive::itf::plugin::IPluginGui)

public:
    explicit SystemSettingsPluginGui();
    ~SystemSettingsPluginGui() override = default;

    std::string getQmlPath() const override;
    void runSettings(std::shared_ptr<drive::itf::plugin::IPluginShell> shell,
                     std::vector<std::string> features,
                     drive::model::SurgeonIdentifier surgeonId) override;
    std::optional<drive::settings::menu::MenuModel*> settingsMenu() override;
    void cleanupPluginQml() override;
    void quitPlugin() override;

    void setSystemSettings(
        const std::shared_ptr<drive::itf::settings::ISystemSettings>& settings) override;

    std::shared_ptr<gos::itf::alerts::IAlertView> getAlertView() const;

    void emitQuitSignal();

private:
    QPointer<QQmlContext> m_pluginContext;
    std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertManager;
    std::shared_ptr<SystemSettingsImplementation> m_settingsImpl;
    std::shared_ptr<drive::settings::menu::MenuModel> m_model;
};
