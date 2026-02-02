/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#ifndef Q_MOC_RUN

#include <service/glink/node/INode.h>
#include <gos/itf/hid/ILoadCell.h>

#include <QVector3D>
#include <QTimer>

#endif

#include <QObject>

class LoadCellViewModel : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("serviceName", "LoadCellViewModel")
    Q_PROPERTY(QVector3D loadCellForce READ loadCellForce NOTIFY loadCellForceChanged)
    Q_PROPERTY(QVector3D loadCellTorque READ loadCellTorque NOTIFY loadCellTorqueChanged)

public:
    explicit LoadCellViewModel(QObject* parent = nullptr);

    struct ForceTorque
    {
        QVector3D force;
        QVector3D torque;
    };

    // Q_PROPERTY READ
    QVector3D loadCellForce() const { return m_ft.force; }
    QVector3D loadCellTorque() const { return m_ft.torque; }

    Q_INVOKABLE void onCalibrateLoadCellPressed() const;

signals:
    // Q_PROPERTY NOTIFY
    void loadCellForceChanged(QVector3D arg);
    void loadCellTorqueChanged(QVector3D arg);

private slots:
    void onLoadCellForceTorqueChanged(ForceTorque ft);

private:
    gos::itf::hid::ForceTorqueData m_forceTorqueData;

    // Q_PROPERTY VALUE
    ForceTorque m_ft;
    std::shared_ptr<glink::node::INode> m_node;
    std::shared_ptr<gos::itf::hid::ILoadCell> m_loadCell;
};
