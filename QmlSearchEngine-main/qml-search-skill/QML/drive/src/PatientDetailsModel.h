/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/common/PatientName.h>
#include <drive/com/propertysource/PatientDetailsPropertySource.h>
#include <QObject>

class PatientDetailsModel : public QObject
{
    Q_OBJECT

    using PatientDetailsPropertySource =
        ::drive::com::propertysource::PatientDetailsPropertySource;

    Q_PROPERTY(QString patientId READ patientId NOTIFY patientIdChanged)
    Q_PROPERTY(QString patientName READ patientName NOTIFY patientNameChanged)
    Q_PROPERTY(QString patientFirstName READ patientFirstName NOTIFY
                   patientFirstNameChanged)
    Q_PROPERTY(QString patientLastName READ patientLastName NOTIFY
                   patientLastNameChanged)
    Q_PROPERTY(float height READ height NOTIFY heightChanged)
    Q_PROPERTY(float weight READ weight NOTIFY weightChanged)
    Q_PROPERTY(QString dateOfBirth READ dateOfBirth NOTIFY dateOfBirthChanged)
    Q_PROPERTY(QString medicalId READ medicalId NOTIFY medicalIdChanged)
    Q_PROPERTY(QString gender READ gender NOTIFY genderChanged)
    Q_PROPERTY(QString creatorName READ creatorName NOTIFY creatorNameChanged)
    Q_PROPERTY(QString createdTime READ createdTime NOTIFY createdTimeChanged)
    Q_PROPERTY(
        QString accessedTime READ accessedTime NOTIFY accessedTimeChanged)
    Q_PROPERTY(QStringList imagePaths READ imagePaths NOTIFY imagePathsChanged)

public:
    explicit PatientDetailsModel(QObject* parent = nullptr);

    QString patientId() const;
    QString patientName() const;
    QString patientFirstName() const;
    QString patientLastName() const;
    float height() const;
    float weight() const;
    QString dateOfBirth() const;
    QString medicalId() const;
    QString gender() const;
    QString creatorName() const;
    QString createdTime() const;
    QString accessedTime() const;
    QStringList imagePaths() const;

    Q_INVOKABLE void setPatientFullName(const QString& first,
                                        const QString& last);

    Q_INVOKABLE void updatePatientDataMetric(const QString& medicalId,
                                             const QString& firstName,
                                             const QString& lastName,
                                             const QString& dateOfBirth,
                                             float height,
                                             float weight,
                                             const QString& gender);
    Q_INVOKABLE void updatePatientDataImperial(const QString& medicalId,
                                               const QString& firstName,
                                               const QString& lastName,
                                               const QString& dateOfBirth,
                                               float height,
                                               float weight,
                                               const QString& gender);
    Q_INVOKABLE void deletePatient();
    Q_INVOKABLE float bodyMassIndex() const;
    Q_INVOKABLE float bodyMassIndex(bool isMetric,
                                    float height,
                                    float weight) const;

signals:
    void patientIdChanged();
    void patientNameChanged();
    void patientFirstNameChanged();
    void patientLastNameChanged();
    void heightChanged();
    void weightChanged();
    void dateOfBirthChanged();
    void medicalIdChanged();
    void genderChanged();
    void creatorNameChanged();
    void createdTimeChanged();
    void accessedTimeChanged();
    void imagePathsChanged();

private:
    void onPatientNameChanged(QString const&);

    std::unique_ptr<PatientDetailsPropertySource>
        m_patientDetailsPropertySource;
    drive::common::PatientName m_patientName;
};
