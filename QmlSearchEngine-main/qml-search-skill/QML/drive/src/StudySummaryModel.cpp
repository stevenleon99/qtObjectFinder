/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "StudySummaryModel.h"
#include <drive/common/DriveCommon.h>

StudySummaryModel::StudySummaryModel(QObject* parent)
    : QObject(parent)
    , m_studySummaryPropertySource(std::make_unique<StudySummaryPropertySource>(parent))
{
    connect(m_studySummaryPropertySource.get(), &StudySummaryPropertySource::studyIdStrChanged,
                                                               this, &StudySummaryModel::studyIdChanged);
    connect(m_studySummaryPropertySource.get(), &StudySummaryPropertySource::studyNameChanged,
                                                               this, &StudySummaryModel::studyNameChanged);
    connect(m_studySummaryPropertySource.get(), &StudySummaryPropertySource::studyCreatorChanged,
                                                               this, &StudySummaryModel::creatorNameChanged);
    connect(m_studySummaryPropertySource.get(), &StudySummaryPropertySource::createdTimeChanged,
                                                               this, &StudySummaryModel::createdTimeChanged);
    connect(m_studySummaryPropertySource.get(), &StudySummaryPropertySource::accessedTimeChanged,
                                                               this, &StudySummaryModel::accessedTimeChanged);
}

QString StudySummaryModel::studyId() const
{
    return m_studySummaryPropertySource->studyIdStr();
}

QString StudySummaryModel::studyName() const
{
    return m_studySummaryPropertySource->studyName();
}

QString StudySummaryModel::creatorName() const
{
    return m_studySummaryPropertySource->studyCreator();
}

QString StudySummaryModel::createdTime() const
{
    return drive::common::formatDateTime(
        m_studySummaryPropertySource->createdTime(),
        drive::common::EXTENDED_TIME_FORMAT);
}

QString StudySummaryModel::accessedTime() const
{
    return drive::common::formatDateTime(
        m_studySummaryPropertySource->accessedTime(),
        drive::common::EXTENDED_TIME_FORMAT);
}


void StudySummaryModel::setCaseName(const QString& studyName)
{
    m_studySummaryPropertySource->setStudyName(studyName);
}

void StudySummaryModel::deleteStudy()
{
    m_studySummaryPropertySource->deleteStudy();
}
