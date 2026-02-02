/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/caseimport/IWorkflowInfoModel.h>

#include <QAbstractListModel>
#include <QByteArray>
#include <QHash>
#include <QList>
#include <QModelIndex>
#include <QObject>
#include <QVariant>
#include <Qt>

#include <string>

namespace drive::viewmodel {

class PluginInfo
{
    Q_GADGET

    Q_PROPERTY(QString pluginType MEMBER pluginType CONSTANT)
    Q_PROPERTY(QString pluginName MEMBER pluginName CONSTANT)
    Q_PROPERTY(QString pluginDisplayName MEMBER pluginDisplayName CONSTANT)
    Q_PROPERTY(QString pluginVersion MEMBER pluginVersion CONSTANT)
    Q_PROPERTY(QString pluginIcon MEMBER pluginIcon CONSTANT)
    Q_PROPERTY(bool licensed MEMBER licensed CONSTANT)

public:
    QString pluginType;
    QString pluginName;
    QString pluginDisplayName;
    QString pluginVersion;
    QString pluginIcon;
    bool licensed;
};

class PluginInfoListModel : public QAbstractListModel,
                            public drive::caseimport::IWorkflowInfoModel
{
    Q_OBJECT

public:
    enum RoleNames
    {
        PluginType = Qt::UserRole,
        PluginName,
        PluginDisplayName,
        PluginVersion,
        PluginIcon,
        Licensed
    };

    explicit PluginInfoListModel(QObject* parent = nullptr);

    [[nodiscard]] QVariant workflowIcon(
        model::WorkflowCaseId const& workflowCaseId) const override;

    Q_INVOKABLE QVariant pluginInfoForWorkflow(const QString& workflow);

    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role) const override;

private:
    void populateVersionList();

private:
    QList<PluginInfo> m_pluginInfoList;
};

}  // namespace drive::viewmodel

Q_DECLARE_METATYPE(drive::viewmodel::PluginInfo)
