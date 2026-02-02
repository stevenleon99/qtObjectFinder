/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#include <drive/itf/plugin/IWorkflowPluginDataModel.h>
#include <drive/model/common.h>
#include <QObject>
#include <optional>

const auto GM_PLUGIN_DATAMODEL_INTERFACE_IID = "com.globusmedical.Interfaces.gm.CranialDataModel/1.0";
Q_DECLARE_INTERFACE(drive::itf::plugin::IWorkflowPluginDataModel, GM_PLUGIN_DATAMODEL_INTERFACE_IID)

class CranialPluginDataModel final : public QObject,
        public drive::itf::plugin::IWorkflowPluginDataModel
{
    Q_OBJECT
    Q_INTERFACES(drive::itf::plugin::IWorkflowPluginDataModel)

public:
    explicit CranialPluginDataModel(QObject* parent = nullptr);
    ~CranialPluginDataModel() override = default;

    bool deleteCase(drive::model::WorkflowCaseId id) override;

    std::optional<drive::model::DriveCaseDataUpdater> recoverCase(
        drive::model::WorkflowCaseId id) override;

    std::optional<std::pair<drive::model::WorkflowCaseId, drive::model::DriveCaseData>> createNewCase(drive::model::DrivePatientData data) override;

    bool exportCase(drive::model::WorkflowCaseId id, std::filesystem::path destination) override;

    bool importCase(drive::model::WorkflowCaseId id, std::filesystem::path source) override;

    bool caseExists(drive::model::WorkflowCaseId id) override;
};
