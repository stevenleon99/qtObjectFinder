/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#ifndef Q_MOC_RUN
#include <drive/itf/settings/ISystemSettings.h>
#endif

#include <QObject>

namespace drive::viewmodel {

class ServiceSettingsViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int systemVolume READ systemVolume WRITE setSystemVolume NOTIFY
                   systemVolumeChanged)

public:
    ServiceSettingsViewModel(
        std::shared_ptr<drive::itf::settings::ISystemSettings> systemSettings,
        QObject* parent = nullptr);

    int systemVolume() const;
    void setSystemVolume(int volume);

signals:
    void systemVolumeChanged();

private:
    std::shared_ptr<drive::itf::settings::ISystemSettings> m_systemSettings;
};

}  // namespace drive::viewmodel
