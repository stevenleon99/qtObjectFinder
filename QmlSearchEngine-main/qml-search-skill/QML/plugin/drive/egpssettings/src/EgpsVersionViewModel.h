/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#ifndef Q_MOC_RUN
#include <gos/itf/gps/IPlatformVersions.h>
#include <gos/itf/gps/IMotionVersions.h>
#include <service/glink/node/NodeFactory.h>
#include <gos/itf/uaib/IUaibCommService.h>
#endif

#include <QObject>
#include <QVariantMap>

namespace drive::viewmodel {

class EgpsVersionViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantMap versionInfo READ versionInfo NOTIFY versionChanged)

public:
    EgpsVersionViewModel(QObject* parent = nullptr);

    QVariantMap versionInfo() const { return m_versionInfo; };
    QString suiteVersion();

signals:
    void versionChanged();

private:
    /**
     * Update the system info and notify the change.
     */
    void updateVersions(const QString& key, std::string_view value);

    void queryPlatformVersions() const;
    void queryMotionVersions() const;


private:
    std::shared_ptr<glink::node::INode> m_node;
    std::shared_ptr<gos::itf::gps::IPlatformVersions> m_platformVersions;
    std::shared_ptr<gos::itf::gps::IMotionVersions> m_motionVersions;
    std::shared_ptr<gos::itf::uaib::IUaibControllerService> m_uaibController;

    // Q_PROPERTY MEMBER
    QVariantMap m_versionInfo;
};

}  // namespace drive::viewmodel
