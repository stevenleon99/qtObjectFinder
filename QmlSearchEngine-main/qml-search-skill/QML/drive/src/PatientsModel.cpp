/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "PatientsModel.h"
#include <drive/common/PatientName.h>
#include <drive/common/DriveCommon.h>
#include <QDateTime>

PatientsModel::PatientsModel(QObject* parent)
    : QObject(parent)
    , m_patientsPropertySource(std::make_unique<PatientsPropertySource>(parent))
{
    connect(m_patientsPropertySource.get(),
            &PatientsPropertySource::selectedPatientIdStrChanged, this,
            &PatientsModel::selectedPatientIdChanged);
}

QString PatientsModel::selectedPatientId() const
{
    return m_patientsPropertySource->selectedPatientIdStr();
}

void PatientsModel::addPatient(const QString& patientLastName,
                               const QString& patientFirstName,
                               const QString& dateOfBirth) const
{
    m_patientsPropertySource->addPatient(
        drive::common::PatientName{patientLastName, patientFirstName}
            .toDicomFullName(),
        QDateTime::fromString(dateOfBirth, drive::common::DOB_FORMAT));
}
