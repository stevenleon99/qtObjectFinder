/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#ifndef Q_MOC_RUN
#include <gos/itf/hid/IFootPedal.h>
#include <gos/itf/robot/IHoming.h>
#include <sys/alerts/Alert.h>
#endif

#include <QObject>

#ifndef Q_MOC_RUN
#include <memory>
#endif


namespace glink::node {
struct INode;
}  // namespace glink::node

namespace sys::alerts::itf {
struct IAlertAggregator;
struct IAlertManager;
}  // namespace sys::alerts::itf


namespace drive::viewmodel {

/**
 * View model for handling front-end homing requests.
 */
class HomingViewModel : public QObject
{
    Q_OBJECT

public:
    explicit HomingViewModel(
        const std::shared_ptr<glink::node::INode>& node,
        const std::shared_ptr<sys::alerts::itf::IAlertAggregator>&
            alertViewRegistry,
        QObject* parent = nullptr);

    /**
     * Force the robot arm to rehome.
     *
     * This method will first display an alert requiring user confirmation
     * before rehoming begins.
     */
    Q_INVOKABLE void forceRehome() const;

private slots:
    void handleAlertResponse(const sys::alerts::Alert& alert,
                             const sys::alerts::Option& option);
    void onForceRehomeConfirmed() const;
    void onHomingStateChanged(gos::itf::robot::HomingState state) const;

private:
    const std::shared_ptr<gos::itf::robot::IHoming> m_homing;
    const std::shared_ptr<gos::itf::hid::IFootPedal> m_footPedal;
    const std::shared_ptr<sys::alerts::itf::IAlertAggregator>
        m_alertViewRegistry;
    const std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertManager;
};

}  // namespace drive::viewmodel
