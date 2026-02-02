/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "PluginInfoListModel.h"

#include <drive/licensemanager/LicenseManager.h>
#include <drive/plugin/registry/PluginRegistryFactory.h>

#include <QApplication>
#include <QDebug>
#include <QDir>
#include <QString>

namespace drive::viewmodel {

namespace detail {

std::optional<PluginInfo> getPluginInfo(QList<PluginInfo> const& pluginInfoList,
                                        QString const& workflow)
{
    for (auto&& pluginInfo : pluginInfoList)
    {
        if (pluginInfo.pluginDisplayName == workflow)
        {
            return pluginInfo;
        }
    }
    return std::nullopt;
}


}  // namespace detail

PluginInfoListModel::PluginInfoListModel(QObject* parent)
    : QAbstractListModel(parent)
{
    populateVersionList();
}

QVariant PluginInfoListModel::workflowIcon(
    model::WorkflowCaseId const& workflowCaseId) const
{
    const auto pluginInfoOpt = detail::getPluginInfo(
        m_pluginInfoList, QString::fromStdString(workflowCaseId.type));
    return pluginInfoOpt ? QVariant{pluginInfoOpt->pluginIcon} : QVariant{};
}

QVariant PluginInfoListModel::pluginInfoForWorkflow(const QString& workflow)
{
    const auto pluginInfoOpt =
        detail::getPluginInfo(m_pluginInfoList, workflow);
    return pluginInfoOpt ? QVariant::fromValue(pluginInfoOpt.value())
                         : QVariant{};
}

QHash<int, QByteArray> PluginInfoListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[PluginType] = "role_type";
    roles[PluginName] = "role_name";
    roles[PluginDisplayName] = "role_display_name";
    roles[PluginVersion] = "role_version";
    roles[PluginIcon] = "role_icon";
    roles[Licensed] = "role_licensed";

    return roles;
}

int PluginInfoListModel::rowCount(const QModelIndex&) const
{
    return m_pluginInfoList.size();
}

QVariant PluginInfoListModel::data(const QModelIndex& index, int role) const
{
    int rowIndex = index.row();

    if (rowIndex < 0 || rowIndex >= m_pluginInfoList.size())
        return QVariant();

    auto item = m_pluginInfoList.at(index.row());

    switch (role)
    {
    case PluginType: return item.pluginType;
    case PluginName: return item.pluginName;
    case PluginDisplayName: return item.pluginDisplayName;
    case PluginVersion: return item.pluginVersion;
    case PluginIcon: return item.pluginIcon;
    case Licensed: return item.licensed;
    default: return QVariant();
    }
}

void PluginInfoListModel::populateVersionList()
{
    beginResetModel();

    auto pluginRegistry =
        plugin::registry::PluginRegistryFactory::createInstance();
    pluginRegistry->addPluginsFromDirectory(
        qApp->applicationDirPath().toStdString());
    auto pluginDict = pluginRegistry->listAvailablePlugins();

    auto extractVersion = [](const QString& str) -> QString {
        int hyphenPos = str.indexOf('-');  // Find the position of the hyphen
        if (hyphenPos != -1)
            return str.mid(hyphenPos + 1);  // Extract after the hyphen

        return {};  // Return empty string if no hyphen is found
    };

    for (auto&& [pluginName, plugin] : pluginDict)
    {
        if (pluginName.starts_with("example") || pluginName.starts_with("test"))
            continue;

        auto isLicensed = drive::LicenseManager::isLicenseFileValid(
            QString::fromStdString(pluginName));
        auto version =
            extractVersion(QString::fromStdString(plugin->version()));
        m_pluginInfoList.append(
            PluginInfo{QString::fromStdString(to_string(plugin->type())),
                       QString::fromStdString(plugin->name()),
                       QString::fromStdString(plugin->displayName()), version,
                       // TODO: replace with a manifest field when implemented
                       QString{"qrc:/icons/%1.svg"}.arg(
                           QString::fromStdString(plugin->name())),
                       isLicensed});
    }

    endResetModel();
}

}  // namespace drive::viewmodel
