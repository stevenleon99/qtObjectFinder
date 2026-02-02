#include "EhubSettingsPluginGui.h"
#include "EhubVersionViewModel.h"
#include "HeadsetCalibrationViewModel.h"
#include "HeadsetFeedProvider.h"
#include <drive/trackerinfo/TrackerInfoListModel.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <gm/util/qt/typeconv.h>
#include <drive/model/common.h>

#include <QQmlEngine>
#include <QQmlContext>

constexpr auto EHUB_SETTINGS_PLUGIN_NAME = "drive_plugins_drive_ehubsettings";

// Class for adapting an shared pointer image provider that also want to use in view model
class ImageAdapter : public QQuickImageProvider
{
public:
    explicit ImageAdapter(std::shared_ptr<QQuickImageProvider> provider)
        : QQuickImageProvider(QQmlImageProviderBase::Image)
        , m_underlier(provider)
    {}

    QImage requestImage(const QString& id, QSize* size, const QSize& requestedSize)
    {
        return m_underlier->requestImage(id, size, requestedSize);
    }

private:
    std::shared_ptr<QQuickImageProvider> m_underlier;
};

EhubSettingsPluginGui::EhubSettingsPluginGui()
    : m_headsetFeedProvider(std::make_shared<ehubsettings::imageprovider::HeadsetFeedProvider>(
          glink::node::NodeFactory::createInstance()))
    , m_headsetCalibrationViewModel(
          std::make_shared<drive::viewmodel::HeadsetCalibrationViewModel>(m_headsetFeedProvider))
{}

std::string EhubSettingsPluginGui::getQmlPath() const
{
    return "qrc:/ehubsettings/qml/EhubSettingsPlugin.qml";
}

void EhubSettingsPluginGui::runSettings(std::shared_ptr<drive::itf::plugin::IPluginShell> shell,
                                        [[maybe_unused]] std::vector<std::string> features,
                                        [[maybe_unused]] drive::model::SurgeonIdentifier surgeonId)
{
    m_pluginContext = shell->getQmlContext();

    m_pluginContext->engine()->addImageProvider("headsetfeedprovider",
                                                new ImageAdapter(m_headsetFeedProvider));

    m_pluginContext->setContextProperty("headsetCalibrationViewModel",
                                        m_headsetCalibrationViewModel.get());

    qmlRegisterType<drive::viewmodel::EhubVersionViewModel>("ViewModels", 1, 0,
                                                            "EhubVersionViewModel");
    qmlRegisterType<drive::viewmodel::TrackerInfoListModel>("ViewModels", 1, 0,
                                                            "TrackerInfoListModel");

    shell->createPluginComponent();
}

std::optional<drive::settings::menu::MenuModel*> EhubSettingsPluginGui::settingsMenu()
{
    return std::nullopt;
}

void EhubSettingsPluginGui::cleanupPluginQml()
{
    if (m_pluginContext && m_pluginContext->engine())
    {
        m_pluginContext->engine()->removeImageProvider(QLatin1String("headsetfeedprovider"));
    }
}

void EhubSettingsPluginGui::quitPlugin()
{
    G_EMIT pluginQuitAcknowledged(EHUB_SETTINGS_PLUGIN_NAME);
}
