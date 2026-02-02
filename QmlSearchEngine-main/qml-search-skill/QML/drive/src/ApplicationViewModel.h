/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#ifndef Q_MOC_RUN
#include <drive/itf/settings/ISystemSettings.h>
#include <sys/alerts/itf/IAlertAggregator.h>
#include <sys/alerts/itf/IAlertManager.h>
#include <service/glink/node/NodeFactory.h>
#include <gos/legacy/desktopresolutionincompatible/LegacyDesktopResolutionIncompatibleProxyFactory.h>
#endif

#include <QObject>
#include <QRect>
#include <QScreen>

namespace drive::viewmodel {

class ApplicationViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int screenTimeout READ screenTimeout NOTIFY screenTimeoutChanged)

    using ILegacyDesktopResolutionIncompatible = ::gos::itf::legacy::
        desktopresolutionincompatible::ILegacyDesktopResolutionIncompatible;

    using LegacyDesktopResolutionIncompatibleProxyFactory =
        ::gos::legacy::desktopresolutionincompatible::
            LegacyDesktopResolutionIncompatibleProxyFactory;

public:
    ApplicationViewModel(
        std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
        std::shared_ptr<drive::itf::settings::ISystemSettings> systemSettings,
        QObject* parent = nullptr);

    Q_INVOKABLE void quitToAdmin() const;
    Q_INVOKABLE void shutdownSystem() const;
    Q_INVOKABLE void enterRemoteDeployment() const;
    int screenTimeout() const { return m_screenTimeout.count(); }

signals:
    void screenTimeoutChanged();

private slots:
    void onPrimaryScreenChanged(const QScreen* screen);

    /**
     * Display alert if screen size is different than intended.
     *
     * @param screenSize The size of the screen.
     */
    void alertIfScreenScaled(const QRect& screenSize);

    /**
     * Update the screen timeout and notify if there is a change.
     */
    void updateScreenTimeout(std::chrono::minutes timeout);

    void onResolutionIncompatible(bool isIncompatible);

private:
    /**
     * Display alert if disk free space is low.
     */
    void alertIfDiskFreeSpaceLow();

    std::shared_ptr<sys::alerts::itf::IAlertAggregator> m_alertViewRegistry;
    std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertManager;
    std::shared_ptr<drive::itf::settings::ISystemSettings> m_systemSettings;
    std::shared_ptr<glink::node::INode> m_node;
    std::shared_ptr<ILegacyDesktopResolutionIncompatible>
        m_desktopResolutionIncompatible;

    QMetaObject::Connection m_alertIfScreenScaledConnection;
    std::chrono::minutes m_screenTimeout{};
    bool m_isResolutionIncompatible = false;
};

}  // namespace drive::viewmodel
