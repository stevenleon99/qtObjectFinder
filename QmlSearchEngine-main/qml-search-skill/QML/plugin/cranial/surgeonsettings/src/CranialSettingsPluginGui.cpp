#include "CranialSettingsPluginGui.h"
#include <cranialsettingsplugin/manifest.h>

#include <procd/cranial/managers/IocManager.h>

#include <gm/util/qt/qt_boost_signals2.h>
#include <gm/util/qt/typeconv.h>
#include <drive/model/common.h>

#include <drive/licensing/util.h>

#include <sys/config/config.h>
#include <sys/licensing/client/KeyManagerFactory.h>
#include <sys/licensing/client/LicenseManagerFactory.h>
#include <sys/licensing/client/LicensedUserFactory.h>
#include <sys/log/sys_log.h>
#include <legacy/licensing/settingsAccessor.h>


#include <QQmlEngine>
#include <QQmlContext>

CranialSettingsPluginGui::CranialSettingsPluginGui() {}

std::string CranialSettingsPluginGui::getQmlPath() const
{
    return "qrc:/cranial/surgeonsettings/qml/CranialSettingsPlugin.qml";
}

void CranialSettingsPluginGui::runSettings(std::shared_ptr<drive::itf::plugin::IPluginShell> shell,
                                           [[maybe_unused]] std::vector<std::string> features,
                                           drive::model::SurgeonIdentifier surgeonId)
{
    qDebug() << "surgeonId is" << QString::fromStdString(boost::uuids::to_string(surgeonId.id));

    m_pluginContext = shell->getQmlContext();

    auto builder = std::make_shared<gm::arch::ioc::ContainerBuilder>();

    auto featureSet = getAllSoftwareFeatures();

    QList<QString> featureSetQt;
    for (const auto& feature : featureSet)
    {
        featureSetQt.push_back(QString::fromStdString(feature));
    }

    m_model = std::make_shared<drive::settings::menu::MenuModel>();
    m_pluginContext->setContextProperty("menuModel", m_model.get());

    m_surgeonSettingsVM = std::make_shared<surgeonsettings::SurgeonSettingsViewModel>(surgeonId);
    m_pluginContext->setContextProperty("surgeonSettingsViewModel", m_surgeonSettingsVM.get());

    shell->createPluginComponent();
}

std::optional<drive::settings::menu::MenuModel*> CranialSettingsPluginGui::settingsMenu()
{
    return std::optional<drive::settings::menu::MenuModel*>(m_model.get());
}

void CranialSettingsPluginGui::cleanupPluginQml()
{
    // Not used
}

void CranialSettingsPluginGui::quitPlugin()
{
    G_EMIT pluginQuitAcknowledged(cranialsettings::plugin::manifest::PLUGIN_SHORT_NAME);
}

std::vector<std::string> getAllSoftwareFeatures()
{
    using namespace sys::licensing::client;
    using namespace drive::licensing;

    auto keyManager = KeyManagerFactory::createInstance();

    auto licenseManager = LicenseManagerFactory::createInstance(keyManager->publicKey());

    auto& platform = sys::config::Config::instance()->platform;
    sys::config::access::ConfigPlatformAccessor cpa{platform};
    auto json = cpa.cp.suiteLicense();

    if (json.empty())
    {
        qDebug() << "Current License is empty in config_platform.json";
        return {};
    }

    std::istringstream iss(json);
    licenseManager->deserialize(iss);

    auto systemName = cpa.cp.systemName();
    auto licensedUserEntity = LicensedUserFactory::createInstance(systemName);

    auto license = licenseManager->license(*licensedUserEntity);

    return drive::licensing::util::getSoftwareFeaturesFromLicense(license.get());
}
