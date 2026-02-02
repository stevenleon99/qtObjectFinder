/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "PatientItemModel.h"
#include <drive/common/PatientName.h>

PatientItemModel::PatientItemModel(const PatientIdentifier patientId,
                                   QObject* parent)
    : QObject(parent)
    , m_patientId(patientId)
    , m_patientItemPropertySource(
          std::make_unique<PatientItemPropertySource>(patientId))
{
    connect(m_patientItemPropertySource.get(),
            &PatientItemPropertySource::patientIdStrChanged, this,
            &PatientItemModel::patientIdChanged);
    connect(m_patientItemPropertySource.get(),
            &PatientItemPropertySource::patientNameChanged, this,
            &PatientItemModel::patientNameChanged);
    connect(m_patientItemPropertySource.get(),
            &PatientItemPropertySource::numItemsChanged, this,
            &PatientItemModel::totalCasesChanged);
    connect(m_patientItemPropertySource.get(),
            &PatientItemPropertySource::createdDateChanged, this,
            &PatientItemModel::createdTimeChanged);
    connect(m_patientItemPropertySource.get(),
            &PatientItemPropertySource::accessedDateChanged, this,
            &PatientItemModel::accessedTimeChanged);
}

QString PatientItemModel::patientId() const
{
    return m_patientItemPropertySource->patientIdStr();
}

QString PatientItemModel::patientName() const
{
    return drive::common::PatientName::fromDicomFullName(
               m_patientItemPropertySource->patientName())
        .toCommaSeparated();
}

int PatientItemModel::totalCases() const
{
    return static_cast<int>(m_patientItemPropertySource->numItems());
}

QDateTime PatientItemModel::createdTime() const
{
    return m_patientItemPropertySource->createdDate();
}

QDateTime PatientItemModel::accessedTime() const
{
    return m_patientItemPropertySource->accessedDate();
}

QString PatientItemModel::medicalId() const
{
    return m_patientItemPropertySource->medicalId();
}

QDateTime PatientItemModel::dateOfBirth() const
{
    return m_patientItemPropertySource->dateOfBirth();
}

PatientItemModel::PatientIdentifier PatientItemModel::getPatientId() const
{
    return m_patientId;
}
