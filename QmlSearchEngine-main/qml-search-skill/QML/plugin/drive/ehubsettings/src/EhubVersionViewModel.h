/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#ifndef Q_MOC_RUN
#endif

#include <QObject>
#include <QVariantMap>

namespace drive::viewmodel {

class EhubVersionViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantMap versionInfo READ versionInfo NOTIFY versionChanged)

public:
    EhubVersionViewModel(QObject* parent = nullptr);

    QVariantMap versionInfo() const { return m_versionInfo; };
    QString suiteVersion();

signals:
    void versionChanged();

private:
    /**
     * Update the system info and notify the change.
     */
    void updateVersions(const QString& key, std::string_view value);

    void queryEntityVersions() const;

private:
    // Q_PROPERTY MEMBER
    QVariantMap m_versionInfo;
};

}  // namespace drive::viewmodel
