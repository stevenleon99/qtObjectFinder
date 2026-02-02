/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "CaseItemModel.h"
#include <drive/common/DriveCommon.h>

CaseItemModel::CaseItemModel(const CaseOrStudyIdentifier caseId, QObject* parent)
    : QObject(parent)
    , m_caseId(caseId)
    , m_caseItemPropertySource(std::make_unique<CaseItemPropertySource>(caseId))
{
    connect(m_caseItemPropertySource.get(), &CaseItemPropertySource::caseIdStrChanged,
                                                      this, &CaseItemModel::caseIdChanged);
    connect(m_caseItemPropertySource.get(), &CaseItemPropertySource::caseTypeChanged,
                                                      this, &CaseItemModel::caseTypeChanged);
    connect(m_caseItemPropertySource.get(), &CaseItemPropertySource::caseNameChanged,
                                                      this, &CaseItemModel::caseNameChanged);
    connect(m_caseItemPropertySource.get(), &CaseItemPropertySource::numImagesChanged,
                                                      this, &CaseItemModel::totalImagesChanged);
    connect(m_caseItemPropertySource.get(), &CaseItemPropertySource::createdDateChanged,
                                                      this, &CaseItemModel::createdTimeChanged);
    connect(m_caseItemPropertySource.get(), &CaseItemPropertySource::accessedDateChanged,
                                                      this, &CaseItemModel::accessedTimeChanged);
}

QString CaseItemModel::caseId() const
{
    return m_caseItemPropertySource->caseIdStr();
}

QString CaseItemModel::caseType() const
{
    return m_caseItemPropertySource->caseType();
}

QString CaseItemModel::caseName() const
{
    return m_caseItemPropertySource->caseName();
}

int CaseItemModel::totalImages() const
{
    return static_cast<int>(m_caseItemPropertySource->numImages());
}

QDateTime CaseItemModel::createdTime() const
{
    return m_caseItemPropertySource->createdDate();
}

QDateTime CaseItemModel::accessedTime() const
{
    return m_caseItemPropertySource->accessedDate();
}

CaseItemModel::CaseOrStudyIdentifier CaseItemModel::getCaseId() const
{
    return m_caseId;
}
