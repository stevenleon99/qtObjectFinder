/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#ifndef Q_MOC_RUN
#include "CranialPluginGui.h"
#include "CranialPluginDataModel.h"
#endif

#include <apps/drive/plugin/common/PluginBase.h>
#include <drive/itf/plugin/IPlugin.h>

#include <QtPlugin>
#include <QObject>

struct CranialPluginTraits
{
    using PluginGui = CranialPluginGui;
    using WorkflowPluginDataModel = CranialPluginDataModel;
};

/**
 * @addtogroup apps_drive_cranial Cranial module
 * @ingroup apps_drive
 * @brief Plugin for Cranial module
 */
class CranialPlugin : public QObject,
                      public apps::drive::plugin::common::PluginBase<CranialPluginTraits>
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "com.globusmedical.Interfaces.gm.ClientAppInterface/1.0")
    Q_INTERFACES(drive::itf::plugin::IPlugin)

public:
    explicit CranialPlugin(QObject* parent = nullptr);
    ~CranialPlugin() override;

    [[nodiscard]] std::optional<std::string> getWatchdogFile(
        sys::config::SystemType systemType) const override;
};
