/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#include "LoadCellViewModel.h"

#include <service/glink/node/NodeFactory.h>
#include <gos/hid/loadcell/LoadCellSourceFactory.h>
#include <gos/hid/loadcell/LoadCellProxyFactory.h>
#include <gps/legacy/motion/MotionAdapterFactory.h>
#include <gm/util/qt.h>
#include <gm/geom/qt/typeconv.h>

#include <QObject>
#include <QVector3D>

// enable automatic conversion from gos::itf::hid::ForceTorqueData to LoadCellViewModel::ForceTorque
namespace gm::util::typeconv {

template <>
struct Conversion<gos::itf::hid::ForceTorqueData, LoadCellViewModel::ForceTorque>
{
    LoadCellViewModel::ForceTorque operator()(const gos::itf::hid::ForceTorqueData& value) const
    {
        return {convert<QVector3D>(*value.force), convert<QVector3D>(*value.torque)};
    }
};

}  // namespace gm::util::typeconv

LoadCellViewModel::LoadCellViewModel(QObject* parent)
    : QObject(parent)
{
    setObjectName("LoadCellViewModel");
    qRegisterMetaType<ForceTorque>("LoadCellViewModel::ForceTorque");

    m_node = glink::node::NodeFactory::createInstance();
    m_loadCell = gos::hid::loadcell::LoadCellProxyFactory::createInstance(
        m_node, gos::roles::hid::loadcell::LoadCellRole);

    gm::util::qt::connect(m_loadCell->loadCellDataReceived, this, &LoadCellViewModel::onLoadCellForceTorqueChanged);
}

void LoadCellViewModel::onLoadCellForceTorqueChanged(ForceTorque ft)
{
    if (!qFuzzyCompare(m_ft.force, ft.force))
    {
        m_ft.force = ft.force;
        emit loadCellForceChanged(ft.force);
    }

    if (!qFuzzyCompare(m_ft.torque, ft.torque))
    {
        m_ft.torque = ft.torque;
        emit loadCellTorqueChanged(ft.torque);
    }
}

void LoadCellViewModel::onCalibrateLoadCellPressed() const
{
    m_loadCell->onStartLoadCellCalibration();
}
