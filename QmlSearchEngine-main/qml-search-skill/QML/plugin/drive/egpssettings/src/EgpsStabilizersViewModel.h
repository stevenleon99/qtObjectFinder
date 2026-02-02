/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#ifndef Q_MOC_RUN
#include <service/glink/node/NodeFactory.h>
#include <gos/itf/gps/IStabilizers.h>
#endif

#include <QObject>
#include <QSettings>

namespace drive::viewmodel {

class EgpsStabilizersViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool stabilizerOverride READ stabilizerOverride NOTIFY
                   stabilizerOverrideChanged)

public:
    EgpsStabilizersViewModel(QObject* parent = nullptr);

    // Q_PROPERTY READ
    bool stabilizerOverride() const;

    // Q_INVOKABLEs
    Q_INVOKABLE void setStabilizerOverride(bool flag);

signals:
    void stabilizerOverrideChanged(bool flag);

public slots:
    void onStabilizerOverrideChanged(bool flag);

private:
    std::shared_ptr<glink::node::INode> m_node;
    std::shared_ptr<gos::itf::gps::IStabilizers> m_stabilizersItf;
};

}  // namespace drive::viewmodel
