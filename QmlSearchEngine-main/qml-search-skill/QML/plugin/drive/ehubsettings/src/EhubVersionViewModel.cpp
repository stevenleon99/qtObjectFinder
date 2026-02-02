/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "EhubVersionViewModel.h"

#ifndef Q_MOC_RUN
#include <sys/config/config.h>
#include <gm/util/qt/fromStringView.h>
#include <softwareversion/softwareversion.h>
#include <QJsonDocument>
#include <QJsonObject>
#include <QApplication>
#include <QDir>
#include <memory>
#endif

namespace drive::viewmodel {

constexpr auto SERIAL_NUMBER = "serial_number";
constexpr auto BUILD_VERSION = "build_version";
constexpr auto SUITE_VERSION = "suite_version";

EhubVersionViewModel::EhubVersionViewModel(QObject* parent)
    : QObject(parent)
{
    updateVersions(
        SERIAL_NUMBER,
        std::to_string(sys::config::Config::instance()->platform.serialNumber())
    );

    updateVersions(
        BUILD_VERSION,
        SoftwareVersion::getVersionString().toStdString()
    );
    
    updateVersions(
        SUITE_VERSION,
        suiteVersion().toStdString()
    );
}

void EhubVersionViewModel::updateVersions(const QString& key,
                                           std::string_view value)
{
    if (m_versionInfo.find(key) != m_versionInfo.end() &&
        m_versionInfo.value(key).toString() ==
            gm::util::qt::fromStringView(value))
    {
        return;
    }

    m_versionInfo[key] = gm::util::qt::fromStringView(value);
    Q_EMIT versionChanged();
}

QString EhubVersionViewModel::suiteVersion()
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

}  // namespace drive::viewmodel
