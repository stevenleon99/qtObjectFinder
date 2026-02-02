/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#include "EgpsStabilizersViewModel.h"

#ifndef Q_MOC_RUN
#include <gos/gps/stabilizers/StabilizersProxyFactory.h>
#include <gm/util/qt/qt_boost_signals2.h>
#endif

#include <QObject>

namespace drive::viewmodel {

EgpsStabilizersViewModel::EgpsStabilizersViewModel(QObject* parent)
    : QObject(parent)
{
    setObjectName("EgpsStabilizersViewModel");
    m_node = glink::node::NodeFactory::createInstance();
    m_stabilizersItf =
        gos::gps::stabilizers::StabilizersProxyFactory::createInstance(
            m_node, gos::roles::gps::stabilizers::StabilizersRole);

    gm::util::qt::connect(
        m_stabilizersItf->stabilizerOverrideChanged, this,
        &EgpsStabilizersViewModel::onStabilizerOverrideChanged);
}

bool EgpsStabilizersViewModel::stabilizerOverride() const
{
    return m_stabilizersItf->stabilizerOverride();
}

void EgpsStabilizersViewModel::setStabilizerOverride(const bool flag)
{
    m_stabilizersItf->setStabilizerOverride(flag);
}

void EgpsStabilizersViewModel::onStabilizerOverrideChanged(const bool flag)
{
    Q_EMIT stabilizerOverrideChanged(flag);
}

}  // namespace drive::viewmodel
