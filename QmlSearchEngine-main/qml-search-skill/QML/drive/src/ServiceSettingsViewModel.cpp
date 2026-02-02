/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "ServiceSettingsViewModel.h"
#include <sys/log/sys_log.h>

namespace drive::viewmodel {

ServiceSettingsViewModel::ServiceSettingsViewModel(
    std::shared_ptr<drive::itf::settings::ISystemSettings> systemSettings,
    QObject* parent)
    : QObject(parent)
    , m_systemSettings(systemSettings)
{}

int ServiceSettingsViewModel::systemVolume() const
{
    int val = -1;
    if (m_systemSettings)
    {
        val = m_systemSettings->getSystemAudioVolume();
    }
    SYS_LOG_INFO("ServiceSettingsViewModel systemVolume = {}", val);
    return val;
}

void ServiceSettingsViewModel::setSystemVolume(int volume)
{
    m_systemSettings->setSystemAudioVolume(volume);

    Q_EMIT systemVolumeChanged();
}

}  // namespace drive::viewmodel
