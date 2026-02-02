/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/com/propertysource/PatientsPropertySource.h>
#include <QObject>

class PatientsModel : public QObject
{
    Q_OBJECT

    using PatientsPropertySource =
        ::drive::com::propertysource::PatientsPropertySource;

    Q_PROPERTY(QString selectedPatientId READ selectedPatientId NOTIFY
                   selectedPatientIdChanged)

public:
    explicit PatientsModel(QObject* parent = nullptr);

    QString selectedPatientId() const;

    Q_INVOKABLE void addPatient(const QString& patientLastName,
                                const QString& patientFirstName,
                                const QString& dateOfBirth) const;

signals:
    void selectedPatientIdChanged();

private:
    std::unique_ptr<PatientsPropertySource> m_patientsPropertySource;
};
