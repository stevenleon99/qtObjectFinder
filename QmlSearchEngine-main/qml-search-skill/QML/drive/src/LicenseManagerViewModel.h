/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#include <sys/alerts/itf/IAlertAggregator.h>
#include <sys/alerts/itf/IAlertManager.h>

#include <QObject>
#include <QStringList>

class LicenseManagerViewModel : public QObject
{
    Q_OBJECT

public:
    explicit LicenseManagerViewModel(
        std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
        QObject* parent = nullptr);

    Q_INVOKABLE bool licenseFileValid(const QString& plugin) const;

    Q_INVOKABLE void alertInvalidLicense() const;

    Q_INVOKABLE QStringList getFluoroFixtureLicensed() const;

private slots:
    void handleAlertResponse(const sys::alerts::Alert& alert,
                             const sys::alerts::Option&);

private:
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> m_alertViewRegistry;
    std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertManager;

}; // LicenseManagerViewModel
