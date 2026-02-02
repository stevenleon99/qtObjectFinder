/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "EgpsVersionViewModel.h"

#ifndef Q_MOC_RUN
#include <sys/config/config.h>
#include <gps/legacy/platform/PlatformVersionsFactory.h>
#include <gps/legacy/motion/MotionVersionsFactory.h>
#include <gos/gps/platformversions/PlatformVersionsProxyFactory.h>
#include <gos/gps/motionversions/MotionVersionsProxyFactory.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <gm/util/qt/fromStringView.h>
#include <softwareversion/softwareversion.h>
#include <gos/services/uaib/UaibCommunicationProxyFactory.h>
#include <uaibcontroller/UaibAdapterFactory.h>
#include <QJsonDocument>
#include <QJsonObject>
#endif

namespace drive::viewmodel {

constexpr auto SERIAL_NUMBER = "serial_number";
constexpr auto BUILD_VERSION = "build_version";
constexpr auto SUITE_VERSION = "suite_version";

EgpsVersionViewModel::EgpsVersionViewModel(QObject* parent)
    : QObject(parent)
    , m_node(glink::node::NodeFactory::createInstance())
    , m_platformVersions(
          gos::gps::platformversions::PlatformVersionsProxyFactory::
              createInstance(
                  m_node,
                  gps::legacy::platform::PlatformVersionsFactory::OBJECT_ID))
    , m_motionVersions(
          gos::gps::motionversions::MotionVersionsProxyFactory::createInstance(
              m_node, gps::legacy::motion::MotionVersionsFactory::OBJECT_ID))
    , m_uaibController(
          gos::services::uaib::UaibCommunicationProxyFactory::createInstance(
              m_node, gos::services::uaib::UaibAdapterFactory::OBJECT_ID))

{
    m_platformVersions->pibVersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::PIB_FIRMWARE, version);
        });
    m_platformVersions->pduVersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::PDU_FIRMWARE, version);
        });
    m_platformVersions->roiVersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::ROI_FIRMWARE, version);
        });
    m_platformVersions->batteryVersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::BATTERY_FIRMWARE, version);
        });
    m_platformVersions->stabilizer1VersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::STB1_FIRMWARE, version);
        });
    m_platformVersions->stabilizer2VersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::STB2_FIRMWARE, version);
        });
    m_platformVersions->stabilizer3VersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::STB3_FIRMWARE, version);
        });
    m_platformVersions->stabilizer4VersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::STB4_FIRMWARE, version);
        });
    m_motionVersions->gmasAppVersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::GMAS_APPLICATION_VERSION, version);
        });
    m_motionVersions->gmasFirmwareVersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::GMAS_FIRMWARE, version);
        });
    m_motionVersions->gmasShoulderVersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::GMAS_SHOULDER_FIRMWARE, version);
        });
    m_motionVersions->gmasVerticalVersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::GMAS_VERTICAL_FIRMWARE, version);
        });
    m_motionVersions->gmasElbowVersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::GMAS_ELBOW_FIRMWARE, version);
        });
    m_motionVersions->gmasPitchVersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::GMAS_PITCH_FIRMWARE, version);
        });
    m_motionVersions->gmasRollVersionReceived.connect(
        [this](std::string_view version) {
            updateVersions(gos::itf::gps::GMAS_ROLL_FIRMWARE, version);
        });

    m_uaibController->uaibVersionReceived.connect([this](std::string version) {
        updateVersions(gos::itf::uaib::UAIB_FIRMWARE, version);
    });

    updateVersions(
        SERIAL_NUMBER,
        std::to_string(sys::config::Config::instance()->platform.serialNumber()));

    updateVersions(BUILD_VERSION,
                     SoftwareVersion::getVersionString().toStdString());
    
    updateVersions(SUITE_VERSION , suiteVersion().toStdString());

    if (sys::config::Config::instance()->platform.systemType() == sys::config::SystemType::Egps)
    {
        queryPlatformVersions();
        queryMotionVersions();
        m_uaibController->queryUaibVersion();
    }
}

void EgpsVersionViewModel::updateVersions(const QString& key,
                                           std::string_view value)
{
    if (m_versionInfo.find(key) != m_versionInfo.end() &&
        m_versionInfo.value(key).toString() ==
            gm::util::qt::fromStringView(value))
    {
        return;
    }

    if (key == gos::itf::gps::GMAS_APPLICATION_VERSION)
    {
        // Parse the string returned by GMAS into it's component pieces and then make the
        // call to get the version from those component pieces.
        m_versionInfo[key] = GmVersion(gm::util::qt::fromStringView(value)).getVersionString();
    }
    else
    {
        m_versionInfo[key] = gm::util::qt::fromStringView(value);
    }

    Q_EMIT versionChanged();
}

void EgpsVersionViewModel::queryPlatformVersions() const
{
    m_platformVersions->pibFirmwareVersion();
    m_platformVersions->pduFirmwareVersion();
    m_platformVersions->roiFirmwareVersion();
    m_platformVersions->stabilizer1FirmwareVersion();
    m_platformVersions->stabilizer2FirmwareVersion();
    m_platformVersions->stabilizer3FirmwareVersion();
    m_platformVersions->stabilizer4FirmwareVersion();
    m_platformVersions->batteryFirmwareVersion();
}

void EgpsVersionViewModel::queryMotionVersions() const
{
    m_motionVersions->gmasApplicationVersion();
    m_motionVersions->gmasFirmwareVersion();
    m_motionVersions->gmasVerticalFirmwareVersion();
    m_motionVersions->gmasShoulderFirmwareVersion();
    m_motionVersions->gmasPitchFirmwareVersion();
    m_motionVersions->gmasRollFirmwareVersion();
    m_motionVersions->gmasElbowFirmwareVersion();
}

QString EgpsVersionViewModel::suiteVersion()
{
    QDir dir;
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
