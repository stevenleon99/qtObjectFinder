/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#ifndef Q_MOC_RUN
#include <service/glink/node/NodeFactory.h>
#include <gos/itf/gps/IStabilizers.h>
#include <gos/itf/motion/IGpsArmMotionSessionManager.h>
#endif

#include <QObject>
#include <QSettings>

namespace drive::viewmodel {

class EgpsResettleOptionViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool resettleWarningOption READ resettleWarningOption NOTIFY
                   resettleWarningOptionChanged)
public:
    EgpsResettleOptionViewModel(QObject* parent = nullptr);

    // Q_PROPERTY READ
    bool resettleWarningOption() const;

    // Q_INVOKABLEs
    Q_INVOKABLE void setResettleWarningOption(bool enableOption);

signals:
    void resettleWarningOptionChanged(bool optionEnabled);

public slots:
    void onResettleWarningOptionChanged(bool optionEnabled);

private:
    std::shared_ptr<gos::itf::motion::IGpsArmMotionSessionManager>
        m_armMotionProxy;
};

}  // namespace drive::viewmodel
