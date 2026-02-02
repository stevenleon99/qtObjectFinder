/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#ifndef Q_MOC_RUN
#include "SpinePluginGui.h"
#include "SpinePluginDataModel.h"
#endif

#include <apps/drive/plugin/common/PluginBase.h>
#include <drive/itf/plugin/IPlugin.h>

#include <QtPlugin>
#include <QObject>

struct SpinePluginTraits
{
    using PluginGui = SpinePluginGui;
    using WorkflowPluginDataModel = SpinePluginDataModel;
};

/**
 * @addtogroup apps_drive_spine Spine module
 * @ingroup apps_drive
 * @brief Plugin for Spine module
 */
class SpinePlugin : public QObject,
                    public apps::drive::plugin::common::PluginBase<SpinePluginTraits>
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "com.globusmedical.Interfaces.gm.ClientAppInterface/1.0")
    Q_INTERFACES(drive::itf::plugin::IPlugin)

public:
    explicit SpinePlugin(QObject* parent = nullptr);
    ~SpinePlugin() override;

    [[nodiscard]] std::optional<std::string> getWatchdogFile(
        sys::config::SystemType systemType) const override;
};
