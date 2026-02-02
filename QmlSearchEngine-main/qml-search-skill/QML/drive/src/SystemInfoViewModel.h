/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#ifndef Q_MOC_RUN
#include <gos/itf/gps/IPlatformVersions.h>
#include <gos/itf/gps/IMotionVersions.h>

#include <gm/util/qml/MapListModel.h>
#include <lager/extra/struct.hpp>
#endif

#include <QObject>
#include <QVariantMap>

namespace drive::viewmodel {

struct AppInfoItem
{
    QString displayName;
    QString version;

    LAGER_STRUCT_NESTED(AppInfoItem, displayName, version);
};

using AppInfoList = immer::map<int, AppInfoItem>;
using AppInfoListModel = gm::util::qml::MapListModel<AppInfoList>;

class SystemInfoViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantMap systemInfo READ systemInfo NOTIFY systemInfoChanged)
    Q_PROPERTY(QAbstractListModel* appInfoList READ appInfoList CONSTANT)

public:
    SystemInfoViewModel(QObject* parent = nullptr);

    QVariantMap systemInfo() const { return m_systemInfo; }
    QString suiteVersion();
    QAbstractListModel* appInfoList() const
    {
        return m_appInfoListModel->abstractListModel();
    }


signals:
    void systemInfoChanged();

private:
    /**
     * Update the system info and notify the change.
     */
    void updateSystemInfo(const QString& key, std::string_view value);

    /**
     * Populate App Info list
     */
    void initAppInfoListModel();

    /**
     * Parse the gmapp manifest file for given application and return the value
     * for the key
     *
     * @param appName name of application to be checked
     * @param key name of key to get the value
     * @return Returns the value associated with the specified key. If the key
     * is not found, an empty string is returned
     */
    QString getAppInfo(const QString& appName, const QString& key);

private:
    // Q_PROPERTY MEMBER
    QVariantMap m_systemInfo;

    std::shared_ptr<AppInfoListModel> m_appInfoListModel;
};

}  // namespace drive::viewmodel
