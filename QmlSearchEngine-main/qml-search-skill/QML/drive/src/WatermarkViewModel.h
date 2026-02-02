#pragma once

#include "UserViewModel.h"

#include <drive/ServiceModeManager.h>

#include <QObject>

class WatermarkViewModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(WatermarkMode watermarkMode READ watermarkMode NOTIFY watermarkModeChanged)

public:
    explicit WatermarkViewModel(std::shared_ptr<drive::ServiceModeManager> serviceModeManager,
                                drive::viewmodel::UserViewModel* userViewModel,
                                QObject *parent = nullptr);

    enum WatermarkMode
    {
        None,  // Uses production crypto key
        Lab,
        Service,
        Test,  // Accuracy test mode
        Nonproduction  // Uses non-production (AKA jumpstart) crypto key, which
                       // is not secret
    };
    Q_ENUM(WatermarkMode)

    /**
     * @return \c WatermarkMode::None or \c WatermarkMode::Nonproduction when using
     * production or non-production/jumpstart crypto keys, respectively
     */
    static WatermarkMode getNormalWatermarkMode();

    // Q_PROPERTY READ
    WatermarkMode watermarkMode() const;

signals:
    // Q_PROPERTY NOTIFY
    void watermarkModeChanged(WatermarkMode watermarkMode);

private slots:
    void onServiceModeStateChanged(const drive::ServiceModeState& serviceModeState);
    void onServiceUserCountChanged();

private:
    bool isLabModeActive();
    bool isTestModeActive();
    void checkSerialNumber();

private:
    std::shared_ptr<drive::ServiceModeManager> m_serviceModeManager;
    drive::viewmodel::UserViewModel* m_userViewModel;

    // Q_PROPERTY MEMBER
    WatermarkMode m_watermarkMode{};
};
