/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "CasesModel.h"
#include <drive/common/PatientName.h>

CasesModel::CasesModel(QObject* parent)
    : QObject(parent)
    , m_casesPropertySource(std::make_unique<CasesPropertySource>(parent))
{
    connect(m_casesPropertySource.get(),
            &CasesPropertySource::patientNameChanged, this,
            &CasesModel::patientNameChanged);
    connect(m_casesPropertySource.get(),
            &CasesPropertySource::selectedCaseIdStrChanged, this,
            &CasesModel::selectedCaseIdChanged);
    connect(m_casesPropertySource.get(),
            &CasesPropertySource::selectedCaseTypeChanged, this,
            &CasesModel::selectedCaseTypeChanged);
}

QString CasesModel::patientName() const
{
    return drive::common::PatientName::fromDicomFullName(
               m_casesPropertySource->patientName())
        .toCommaSeparated();
}

QString CasesModel::selectedCaseId() const
{
    return m_casesPropertySource->selectedCaseIdStr();
}

QString CasesModel::selectedCaseType() const
{
    return m_casesPropertySource->selectedCaseType();
}
