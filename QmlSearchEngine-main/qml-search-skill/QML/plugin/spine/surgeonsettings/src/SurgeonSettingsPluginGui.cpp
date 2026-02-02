#include "SurgeonSettingsPluginGui.h"
#include <spinesettingsplugin/manifest.h>

#include <procd/spine/managers/IocManager.h>
#include <procd/spine/managers/ToolboxManager.h>
#include <apps/spine/backend/SurgeonSettingsViewModel.h>
#include <procd/spine/managers/FeaturesManager.h>

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

SurgeonSettingsPluginGui::SurgeonSettingsPluginGui() {}

std::string SurgeonSettingsPluginGui::getQmlPath() const
{
    return "qrc:/spine/surgeonsettings/qml/SurgeonSettingsPlugin.qml";
}

void SurgeonSettingsPluginGui::runSettings(std::shared_ptr<drive::itf::plugin::IPluginShell> shell,
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
    builder->registerInstance(std::make_shared<spine::managers::FeaturesManager>(featureSetQt));
    spine::iocmanager::buildContainer(builder);

    builder->registerInstance(std::make_shared<spine::managers::ToolboxManager>());
    spine::iocmanager::buildContainer(builder);

    m_surgeonSettingsVM = std::make_shared<SurgeonSettingsViewModel>(surgeonId);
    m_pluginContext->setContextProperty("surgeonSettingsViewModel", m_surgeonSettingsVM.get());

    qRegisterMetaType<spine::types::enums::PairingSystemType>();
    qmlRegisterUncreatableType<spine::types::enums::PairingSystemTypeGadget>(
        "Enums", 1, 0, "PairingSystemType", "Unable to instantiate enum");

    shell->createPluginComponent();
}

std::optional<drive::settings::menu::MenuModel*> SurgeonSettingsPluginGui::settingsMenu()
{
    return std::nullopt;
}

void SurgeonSettingsPluginGui::cleanupPluginQml() {}

void SurgeonSettingsPluginGui::quitPlugin()
{
    G_EMIT pluginQuitAcknowledged(spinesettings::plugin::manifest::PLUGIN_SHORT_NAME);
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
