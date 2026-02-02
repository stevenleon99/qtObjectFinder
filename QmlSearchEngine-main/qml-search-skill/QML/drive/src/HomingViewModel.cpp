/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#include "HomingViewModel.h"

#include "DriveAlerts.h"

#include <gm/util/qt/qt_boost_signals2.h>
#include <gos/robot/homing/HomingProxyFactory.h>
#include <gos/hid/footpedal/FootPedalProxyFactory.h>
#include <gps/alerts.h>
#include <sys/alerts/AlertManagerFactory.h>
#include <sys/alerts/itf/IAlertAggregator.h>


namespace drive::viewmodel {

HomingViewModel::HomingViewModel(
    const std::shared_ptr<glink::node::INode>& node,
    const std::shared_ptr<sys::alerts::itf::IAlertAggregator>&
        alertViewRegistry,
    QObject* parent)
    : QObject(parent)
    , m_homing(gos::robot::homing::HomingProxyFactory::createInstance(
          node, gos::robot::homing::HomingProxyFactory::OBJECT_ID))
    , m_footPedal(gos::hid::footpedal::FootPedalProxyFactory::createInstance(
          node, gos::roles::hid::footpedal::FootPedalRole))
    , m_alertViewRegistry(alertViewRegistry)
    , m_alertManager(sys::alerts::AlertManagerFactory::createInstance())
{
    m_alertViewRegistry->addAlertView(m_alertManager);
    gm::util::qt::connect(m_alertManager->clearRequested, this,
                          &HomingViewModel::handleAlertResponse);
    gm::util::qt::connect(m_homing->homingStateChanged, this,
                          &HomingViewModel::onHomingStateChanged);
}

void HomingViewModel::forceRehome() const
{
    m_alertManager->createAlert(drive::alerts::alertsMap.at(
        drive::alerts::DriveAlerts::ForceRehomeConfirmation));
}

void HomingViewModel::handleAlertResponse(const sys::alerts::Alert& alert,
                                          const sys::alerts::Option& option)
{
    if (alert == drive::alerts::alertsMap.at(
                     drive::alerts::DriveAlerts::ForceRehomeConfirmation) &&
        option == drive::alerts::confirmOption)
    {
        // If confirm button is pressed while foot pedal is active, then prevent
        // rehoming and display new alert
        if (m_footPedal->footPedalState() ==
            gos::itf::hid::FootPedalState::Pedal1Pressed)
        {
            m_alertManager->createAlert(drive::alerts::alertsMap.at(
                drive::alerts::DriveAlerts::FootPedalPressedBeforeRehoming));
        }
        else
        {
            onForceRehomeConfirmed();
        }
    }

    m_alertManager->clearAlert(alert);
}

void HomingViewModel::onForceRehomeConfirmed() const
{
    if (m_homing)
    {
        m_homing->forceRehoming(true);
        m_alertManager->createAlert(gps::alerts::homingInProgress);
    }
}

void HomingViewModel::onHomingStateChanged(
    gos::itf::robot::HomingState state) const
{
    if (state != gos::itf::robot::HomingState::NotStarted &&
        state != gos::itf::robot::HomingState::InProgress)
    {
        m_alertManager->clearAlert(gps::alerts::homingInProgress);
    }
}

}  // namespace drive::viewmodel
