#include "WatermarkViewModel.h"

#include "UserViewModel.h"

#include <sys/config/config.h>
#include <gm/util/qt/qt_boost_signals2.h>

constexpr auto DEFAULT_SERIAL_NO_MSG = "Serial Number 0";

WatermarkViewModel::WatermarkViewModel(
    std::shared_ptr<drive::ServiceModeManager> serviceModeManager,
    drive::viewmodel::UserViewModel* userViewModel,
    QObject* parent)
    : QObject(parent)
    , m_serviceModeManager(std::move(serviceModeManager))
    , m_userViewModel(userViewModel)
    , m_watermarkMode(getNormalWatermarkMode())
{
    connect(m_userViewModel,
            &drive::viewmodel::UserViewModel::serviceUserCountChanged, this,
            &WatermarkViewModel::onServiceUserCountChanged);

    gm::util::qt::connect(m_serviceModeManager->serviceModeStateChanged, this,
                          &WatermarkViewModel::onServiceModeStateChanged);

    onServiceModeStateChanged(m_serviceModeManager->serviceModeState());

    onServiceUserCountChanged();

    checkSerialNumber();
}

WatermarkViewModel::WatermarkMode WatermarkViewModel::getNormalWatermarkMode()
{
#if GM_USE_PRODUCTION_CRYPTO_KEY == 1
    return WatermarkMode::None;
#else
    return WatermarkMode::Nonproduction;
#endif
}

WatermarkViewModel::WatermarkMode WatermarkViewModel::watermarkMode() const
{
    return m_watermarkMode;
}

void WatermarkViewModel::onServiceModeStateChanged(
    const drive::ServiceModeState& serviceModeState)
{
    if (serviceModeState == drive::ServiceModeState::Active)
    {
        m_watermarkMode = WatermarkMode::Service;
    }
    else if (isTestModeActive())
    {
        m_watermarkMode = WatermarkMode::Test;
    }
    else if (isLabModeActive())
    {
        m_watermarkMode = WatermarkMode::Lab;
    }
    else
    {
        m_watermarkMode = getNormalWatermarkMode();
    }

    Q_EMIT watermarkModeChanged(m_watermarkMode);
}

void WatermarkViewModel::onServiceUserCountChanged()
{
    if (m_userViewModel->serviceUserExists())
    {
        m_serviceModeManager->setServiceMode("Service user exists");
    }
}

bool WatermarkViewModel::isLabModeActive()
{
    return sys::config::Config::instance()->platform.systemMode() ==
           sys::config::SystemMode::Lab;
}

bool WatermarkViewModel::isTestModeActive()
{
    return sys::config::Config::instance()->platform.systemMode() ==
           sys::config::SystemMode::Test;
}

void WatermarkViewModel::checkSerialNumber()
{
    if (sys::config::Config::instance()->platform.serialNumber() == 0)
    {
        m_serviceModeManager->setServiceMode(DEFAULT_SERIAL_NO_MSG);
    }
}
