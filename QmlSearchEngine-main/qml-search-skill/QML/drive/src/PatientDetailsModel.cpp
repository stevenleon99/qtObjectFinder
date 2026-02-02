/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "PatientDetailsModel.h"
#include <drive/common/DriveCommon.h>

PatientDetailsModel::PatientDetailsModel(QObject* parent)
    : QObject(parent)
    , m_patientDetailsPropertySource(
          std::make_unique<PatientDetailsPropertySource>(parent))
    , m_patientName(drive::common::PatientName::fromDicomFullName(
          m_patientDetailsPropertySource->patientName()))
{
    using Source = PatientDetailsPropertySource;
    using Model = PatientDetailsModel;

    auto source = m_patientDetailsPropertySource.get();
    auto connectSignals = [source, this](auto sourceSignal, auto modelSignal) {
        connect(source, sourceSignal, this, modelSignal);
    };

    connectSignals(&Source::patientIdStrChanged, &Model::patientIdChanged);
    connectSignals(&Source::medicalIdChanged, &Model::medicalIdChanged);
    connectSignals(&Source::dateOfBirthChanged, &Model::dateOfBirthChanged);
    connectSignals(&Source::heightInChanged, &Model::heightChanged);
    connectSignals(&Source::heightCmChanged, &Model::heightChanged);
    connectSignals(&Source::weightLbChanged, &Model::weightChanged);
    connectSignals(&Source::weightKgChanged, &Model::weightChanged);
    connectSignals(&Source::genderChanged, &Model::genderChanged);
    connectSignals(&Source::creatorChanged, &Model::creatorNameChanged);
    connectSignals(&Source::createdChanged, &Model::createdTimeChanged);
    connectSignals(&Source::accessedChanged, &Model::accessedTimeChanged);
    connectSignals(&Source::imagePathsChanged, &Model::imagePathsChanged);
    connectSignals(&Source::metricUnitSelectedChanged, &Model::heightChanged);
    connectSignals(&Source::metricUnitSelectedChanged, &Model::weightChanged);

    connectSignals(&Source::patientNameChanged, &Model::onPatientNameChanged);
}

QString PatientDetailsModel::patientId() const
{
    return m_patientDetailsPropertySource->patientIdStr();
}

QString PatientDetailsModel::patientName() const
{
    return m_patientName.toCommaSeparated();
}

QString PatientDetailsModel::patientFirstName() const
{
    return m_patientName.first;
}

QString PatientDetailsModel::patientLastName() const
{
    return m_patientName.last;
}

void PatientDetailsModel::onPatientNameChanged(QString const& name)
{
    auto old = m_patientName;
    auto current = drive::common::PatientName::fromDicomFullName(name);
    m_patientName = current;

    if (old.first != current.first)
    {
        Q_EMIT patientFirstNameChanged();
        Q_EMIT patientNameChanged();
    }
    if (old.last != current.last)
    {
        Q_EMIT patientLastNameChanged();
        Q_EMIT patientNameChanged();
    }
}

float PatientDetailsModel::height() const
{
    if (m_patientDetailsPropertySource->metricUnitSelected())
    {
        return std::round(m_patientDetailsPropertySource->heightCm());
    }
    else
    {
        return std::round(m_patientDetailsPropertySource->heightIn());
    }
}

float PatientDetailsModel::weight() const
{
    if (m_patientDetailsPropertySource->metricUnitSelected())
    {
        return std::round(m_patientDetailsPropertySource->weightKg());
    }
    else
    {
        return std::round(m_patientDetailsPropertySource->weightLb());
    }
}

QString PatientDetailsModel::dateOfBirth() const
{
    return drive::common::formatDateTime(
        m_patientDetailsPropertySource->dateOfBirth(),
        drive::common::DATE_FORMAT);
}

QString PatientDetailsModel::medicalId() const
{
    return m_patientDetailsPropertySource->medicalId();
}

QString PatientDetailsModel::gender() const
{
    return m_patientDetailsPropertySource->gender();
}

QString PatientDetailsModel::creatorName() const
{
    return m_patientDetailsPropertySource->creator();
}

QString PatientDetailsModel::createdTime() const
{
    return drive::common::formatDateTime(
        m_patientDetailsPropertySource->created(), drive::common::TIME_FORMAT);
}

QString PatientDetailsModel::accessedTime() const
{
    return drive::common::formatDateTime(
        m_patientDetailsPropertySource->accessed(), drive::common::TIME_FORMAT);
}

QStringList PatientDetailsModel::imagePaths() const
{
    return m_patientDetailsPropertySource->imagePaths();
}

void PatientDetailsModel::setPatientFullName(const QString& first,
                                             const QString& last)
{
    auto patientName = m_patientName;
    patientName.first = first;
    patientName.last = last;
    m_patientDetailsPropertySource->setPatientFullName(
        patientName.toDicomFullName());
}

void PatientDetailsModel::updatePatientDataMetric(const QString& medicalId,
                                                  const QString& firstName,
                                                  const QString& lastName,
                                                  const QString& dateOfBirth,
                                                  float height,
                                                  float weight,
                                                  const QString& gender)
{
    auto patientName = m_patientName;
    patientName.first = firstName;
    patientName.last = lastName;
    m_patientDetailsPropertySource->setPatientDataMetric(
        medicalId, patientName.toDicomFullName(),
        QDateTime::fromString(dateOfBirth, drive::common::DOB_FORMAT), height,
        weight, gender);
}

void PatientDetailsModel::updatePatientDataImperial(const QString& medicalId,
                                                    const QString& firstName,
                                                    const QString& lastName,
                                                    const QString& dateOfBirth,
                                                    float height,
                                                    float weight,
                                                    const QString& gender)
{
    auto patientName = m_patientName;
    patientName.first = firstName;
    patientName.last = lastName;
    m_patientDetailsPropertySource->setPatientDataImperial(
        medicalId, patientName.toDicomFullName(),
        QDateTime::fromString(dateOfBirth, drive::common::DOB_FORMAT), height,
        weight, gender);
}

void PatientDetailsModel::deletePatient()
{
    m_patientDetailsPropertySource->deletePatient();
}

float PatientDetailsModel::bodyMassIndex() const
{
    return bodyMassIndex(m_patientDetailsPropertySource->metricUnitSelected(),
                         height(), weight());
}

float PatientDetailsModel::bodyMassIndex(bool isMetric,
                                         float height,
                                         float weight) const
{
    if (height == 0 || weight == 0)
        return 0;

    auto height_m = (isMetric ? height : height * 2.54f) / 100;
    auto weight_kg = (isMetric ? weight : weight / 2.205f);

    return weight_kg / (height_m * height_m);
}
