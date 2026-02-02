/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/com/propertysource/PatientItemPropertySource.h>
#include <QObject>

class PatientItemModel : public QObject
{
    Q_OBJECT

    using PatientItemPropertySource = ::drive::com::propertysource::PatientItemPropertySource;
    using PatientIdentifier = ::drive::model::PatientIdentifier;

    Q_PROPERTY(QString patientId READ patientId NOTIFY patientIdChanged)
    Q_PROPERTY(QString patientName READ patientName NOTIFY patientNameChanged)
    Q_PROPERTY(int totalCases READ totalCases NOTIFY totalCasesChanged)
    Q_PROPERTY(QDateTime createdTime READ createdTime NOTIFY createdTimeChanged)
    Q_PROPERTY(QDateTime accessedTime READ accessedTime NOTIFY accessedTimeChanged)
    Q_PROPERTY(QString medicalId READ medicalId NOTIFY medicalIdChanged)
    Q_PROPERTY(QDateTime dateOfBirth READ dateOfBirth NOTIFY dateOfBirthChanged)

public:
    explicit PatientItemModel(const PatientIdentifier patientId, QObject* parent = nullptr);

    QString patientId() const;
    QString patientName() const;
    int totalCases() const;
    QDateTime createdTime() const;
    QDateTime accessedTime() const;
    QString medicalId() const;
    QDateTime dateOfBirth() const;

    PatientIdentifier getPatientId() const;

signals:
    void patientIdChanged();
    void patientTypeChanged();
    void patientNameChanged();
    void totalCasesChanged();
    void createdTimeChanged();
    void accessedTimeChanged();
    void medicalIdChanged();
    void dateOfBirthChanged();

private:
    PatientIdentifier m_patientId;
    std::unique_ptr<PatientItemPropertySource> m_patientItemPropertySource;
};
