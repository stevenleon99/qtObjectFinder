/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "SystemInfoViewModel.h"

#ifndef Q_MOC_RUN
#include <sys/config/config.h>
#include <gm/util/qt/fromStringView.h>
#include <softwareversion/softwareversion.h>
#include <QJsonDocument>
#include <QJsonObject>
#include <QApplication>
#include <QDir>
#endif

namespace drive::viewmodel {

constexpr auto SERIAL_NUMBER = "serial_number";
constexpr auto BUILD_VERSION = "build_version";
constexpr auto SUITE_VERSION = "suite_version";
constexpr auto MANIFEST_NAME_SUFFIX = ".gmapp-manifest";
constexpr auto DISPLAY_NAME_TAG = "display-name";
constexpr auto VERSION_TAG = "version";
constexpr auto DRIVE_APP = "drive";
constexpr auto GNS_SENSORHUB = "gns-sensorhub";
constexpr auto GPS_FLUOROCAPTURE = "gps-fluoro-capture";
constexpr auto GPS_CONTROLLER = "gps_controller2";
constexpr auto GNS_CONTROLLER = "gns_controller";

SystemInfoViewModel::SystemInfoViewModel(QObject* parent)
    : QObject(parent)
    , m_appInfoListModel{std::make_shared<AppInfoListModel>()}
{
    updateSystemInfo(
        SERIAL_NUMBER,
        std::to_string(sys::config::Config::instance()->platform.serialNumber()));

    updateSystemInfo(BUILD_VERSION,
                     SoftwareVersion::getVersionString().toStdString());
    
    updateSystemInfo(SUITE_VERSION , suiteVersion().toStdString());

    initAppInfoListModel();
}

void SystemInfoViewModel::updateSystemInfo(const QString& key,
                                           std::string_view value)
{
    if (m_systemInfo.find(key) != m_systemInfo.end() &&
        m_systemInfo.value(key).toString() ==
            gm::util::qt::fromStringView(value))
    {
        return;
    }

    m_systemInfo[key] = gm::util::qt::fromStringView(value);
    Q_EMIT systemInfoChanged();
}

QString SystemInfoViewModel::suiteVersion()
{
    QDir dir(qApp->applicationDirPath());
    auto entryList = dir.entryList({"drive.gmapp-manifest"});
    if (entryList.empty())
        return "Error - no entries";

    QFile manifest(dir.absoluteFilePath(entryList[0]));
    if (!manifest.open(QIODevice::ReadOnly | QIODevice::Text))
        return "Error - cannot open file";

    QJsonDocument doc = QJsonDocument::fromJson(manifest.readAll());

    if (doc.isEmpty())
        return "Error - no data";

    const auto jsonData = doc.object();
    return jsonData.value("version").toString();
}


void SystemInfoViewModel::initAppInfoListModel()
{
    std::vector<std::string> appNameList;
    appNameList.emplace_back(DRIVE_APP);

    auto&& systemType = sys::config::Config::instance()->platform.systemType();
    if (systemType != sys::config::SystemType::Laptop)
    {
        appNameList.insert(appNameList.end(),
                           {GNS_SENSORHUB, GPS_FLUOROCAPTURE});
    }

    if (systemType == sys::config::SystemType::Egps)
    {
        appNameList.emplace_back(GPS_CONTROLLER);
    }
    else if (systemType == sys::config::SystemType::Ehub)
    {
        appNameList.emplace_back(GNS_CONTROLLER);
    }

    AppInfoList appInfoList;
    int displayIndex = 0;
    for (const auto& appName : appNameList)
    {
        auto displayName = getAppInfo(appName.data(), DISPLAY_NAME_TAG);
        if (displayName.isEmpty())
            continue;

        auto versionTagStr = getAppInfo(appName.data(), VERSION_TAG);
        if (versionTagStr.isEmpty())
            continue;

        auto extractVersion = [](const QString& str) -> QString {
            int hyphenPos =
                str.indexOf('-');  // Find the position of the hyphen
            if (hyphenPos != -1)
                return str.mid(hyphenPos +
                               1);  // Extract substring after the hyphen

            return "";  // Return empty string if no hyphen is found
        };
        auto version = extractVersion(versionTagStr);

        displayIndex++;
        appInfoList = appInfoList.set(displayIndex, {displayName, version});
    }
    m_appInfoListModel->update(appInfoList);
}

QString SystemInfoViewModel::getAppInfo(const QString& appName,
                                        const QString& key)
{
    QDir dir(qApp->applicationDirPath());
    QString manifestName = appName + MANIFEST_NAME_SUFFIX;
    auto entryList = dir.entryList({manifestName});
    if (entryList.empty())
        return {};

    QFile manifest(dir.absoluteFilePath(entryList[0]));
    if (!manifest.open(QIODevice::ReadOnly | QIODevice::Text))
        return {};

    QJsonDocument doc = QJsonDocument::fromJson(manifest.readAll());
    if (doc.isEmpty())
        return {};

    const auto jsonData = doc.object();
    return jsonData.value(key).toString();
}

}  // namespace drive::viewmodel
