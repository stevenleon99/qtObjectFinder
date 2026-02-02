/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#include "EgpsResettleOptionViewModel.h"

#ifndef Q_MOC_RUN
#include <gos/motion/armmotion/ArmMotionSessionManagerProxyFactory.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <sys/log.h>
#endif

#include <QObject>

namespace drive::viewmodel {

EgpsResettleOptionViewModel::EgpsResettleOptionViewModel(QObject* parent)
    : QObject(parent)
{
    setObjectName("EgpsResettleOptionViewModel");

    auto glinkNode = glink::node::NodeFactory::createInstance();

    m_armMotionProxy =
        gos::motion::armmotion::ArmMotionSessionManagerProxyFactory::
            createInstance<gm::algo::robot::gps::RobotTraits>(
                glinkNode,
                gos::roles::motion::armmotion::ArmMotionSessionManagerRole);

    gm::util::qt::connect(
        m_armMotionProxy->resettleWarningOptionChangedSig, this,
        &EgpsResettleOptionViewModel::onResettleWarningOptionChanged);

    // The "master" resettle option status lives in GpsArmMotionSessionManager
    // object. It defaults to false and is updated from here via the user using
    // the Settings UI. The status, upon object initialization and whenever
    // changed by the user is set on the proxy, which sends it to the source,
    // which then updates the GpsArmMotionSessionManager via its interface.
    // GpsArmMotionSessionManager then updates GmMotion.

    // Set the checkbox based on the proxy setting (which persists) while the
    // object for this class is created and destroyed when the Egps Settings
    // page is opened and closed, respectively.
    Q_EMIT resettleWarningOptionChanged(
        m_armMotionProxy->resettleWarningOptionEnabled());
}

bool EgpsResettleOptionViewModel::resettleWarningOption() const
{
    return m_armMotionProxy->resettleWarningOptionEnabled();
}

void EgpsResettleOptionViewModel::setResettleWarningOption(
    const bool enableOption)
{
    // The proxy will send 'enableOption' to the source. If the value in the
    // source is differnt, then it will be updated and the proxy will emit the
    // signal resettleWarningOptionChangedSig(), which is connected to the slot
    // EgpsResettleOptionViewModel::onResettleWarningOptionChanged().
    m_armMotionProxy->setResettleWarningOption(enableOption);
}

void EgpsResettleOptionViewModel::onResettleWarningOptionChanged(
    const bool optionEnabled)
{
    // Execution gets here from a proxy signal.

    // Force update in QML of checkbox
    Q_EMIT resettleWarningOptionChanged(optionEnabled);
}

}  // namespace drive::viewmodel
